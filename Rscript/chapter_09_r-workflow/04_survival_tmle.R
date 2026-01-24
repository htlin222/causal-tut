# =============================================================================
# Survival TMLE Analysis
# Output: gtsummary HTML table + ggplot survival curve
# =============================================================================

options(repos = c(CRAN = "https://cloud.r-project.org"))

# --- Package Installation ---
required_pkgs <- c("SuperLearner", "dplyr", "gtsummary", "gt", "ggplot2", "survival", "ggsurvfit")
missing_pkgs <- required_pkgs[!vapply(
  required_pkgs,
  requireNamespace,
  logical(1),
  quietly = TRUE
)]
if (length(missing_pkgs) > 0) {
  install.packages(missing_pkgs)
}

if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

if (!requireNamespace("survtmle", quietly = TRUE)) {
  remotes::install_github("benkeser/survtmle")
}

library(survtmle)
library(SuperLearner)
library(dplyr)
library(gtsummary)
library(gt)
library(ggplot2)
library(survival)
library(ggsurvfit)

# --- Presentation Theme (classic, no top/right axes, larger fonts) ---
theme_presentation <- function(base_size = 16) {
  theme_classic(base_size = base_size) +
    theme(
      plot.title = element_text(face = "bold", hjust = 0.5, size = base_size + 2),
      plot.subtitle = element_text(hjust = 0.5, color = "gray40", size = base_size),
      plot.caption = element_text(size = base_size - 2, color = "gray50"),
      axis.title = element_text(size = base_size),
      axis.text = element_text(size = base_size - 2),
      legend.title = element_text(size = base_size - 1),
      legend.text = element_text(size = base_size - 2),
      legend.position = "bottom"
    )
}

# --- Configuration ---
SL.lib <- c("SL.glm")
output_dir <- "output/chapter_09"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

# --- Load Data ---
df <- read.csv("data/09_r-workflow/df_survival.csv")
df <- df |> filter(time > 0) |> slice_head(n = 150)

# --- Baseline Characteristics Table (gtsummary) ---
baseline_table <- df |>
  select(treatment, age, sex, comorbidity, severity, time, event) |>
  mutate(
    treatment = factor(treatment, levels = c(0, 1), labels = c("Control", "Treatment")),
    sex = factor(sex, levels = c(0, 1), labels = c("Female", "Male")),
    event = factor(event, levels = c(0, 1), labels = c("Censored", "Event"))
  ) |>
  tbl_summary(
    by = treatment,
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    label = list(
      age ~ "Age (years)",
      sex ~ "Sex",
      comorbidity ~ "Comorbidity count",
      severity ~ "Severity score",
      time ~ "Follow-up time (days)",
      event ~ "Event status"
    ),
    digits = all_continuous() ~ 1
  ) |>
  add_p() |>
  add_overall() |>
  modify_header(label ~ "**Variable**") |>
  modify_caption("**Table 1. Baseline Characteristics (Survival Outcome)**")

# Save baseline table as HTML
baseline_table |>
  as_gt() |>
  gtsave(file.path(output_dir, "04_baseline_survival.html"))

# --- Survival TMLE Analysis ---
fit_surv <- survtmle(
  ftime = df$time,
  ftype = df$event,
  trt = df$treatment,
  adjustVars = df |> select(age, sex, comorbidity, severity),
  t0 = 365,
  SL.ftime = SL.lib,
  SL.ctime = SL.lib,
  SL.trt = SL.lib,
  method = "hazard"
)

# --- Extract Results ---
surv_est <- fit_surv$est
surv_results <- data.frame(
  Treatment = c("Control (A=0)", "Treatment (A=1)"),
  `Survival at t=365` = as.numeric(surv_est),
  check.names = FALSE
)

# Calculate risk difference
rd <- surv_est[2, 1] - surv_est[1, 1]

# --- Survival Results Table (gt) ---
results_table <- surv_results |>
  gt() |>
  tab_header(
    title = md("**Survival TMLE Estimation Results**"),
    subtitle = "Estimated survival probability at t = 365 days"
  ) |>
  fmt_number(columns = `Survival at t=365`, decimals = 4) |>
  tab_footnote(
    footnote = "survtmle with Super Learner (GLM)",
    locations = cells_title(groups = "subtitle")
  ) |>
  tab_source_note(
    source_note = md(sprintf(
      "**Survival Difference**: %.4f (Treatment - Control)",
      rd
    ))
  )

# Save results table as HTML
results_table |>
  gtsave(file.path(output_dir, "04_survtmle_results.html"))

# --- Kaplan-Meier Curve (ggsurvfit) ---
# Create treatment factor with nice labels
df$treatment_group <- factor(
  df$treatment,
  levels = c(0, 1),
  labels = c("Control", "Treatment")
)

# Use ggsurvfit for KM curves
km_plot <- survfit2(Surv(time, event) ~ treatment_group, data = df) |>
  ggsurvfit(linewidth = 1.2) +
  add_confidence_interval(alpha = 0.2) +
  add_risktable(
    risktable_stats = "n.risk",
    size = 4,
    theme = theme_risktable_default(
      axis.text.y.size = 12,
      plot.title.size = 12
    )
  ) +
  scale_color_manual(
    values = c("Control" = "#E63946", "Treatment" = "#2E86AB"),
    name = "Group"
  ) +
  scale_fill_manual(
    values = c("Control" = "#E63946", "Treatment" = "#2E86AB"),
    name = "Group"
  ) +
  geom_vline(xintercept = 365, linetype = "dashed", color = "gray40", linewidth = 0.8) +
  annotate(
    "text",
    x = 380,
    y = 0.25,
    label = "t = 365",
    hjust = 0,
    size = 5,
    color = "gray40"
  ) +
  labs(
    title = "Kaplan-Meier Survival Curves",
    subtitle = "With 95% Confidence Intervals",
    x = "Time (days)",
    y = "Survival Probability",
    caption = sprintf(
      "TMLE Survival at t=365: Control=%.3f, Treatment=%.3f",
      surv_est[1, 1],
      surv_est[2, 1]
    )
  ) +
  theme_presentation(base_size = 16) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(limits = c(0, max(df$time) * 1.05), expand = c(0.02, 0))

# Save KM plot
ggsave(
  file.path(output_dir, "04_survtmle_km_curve.png"),
  km_plot,
  width = 10,
  height = 7,
  dpi = 300
)

# --- Bar Plot for TMLE Estimates ---
bar_data <- data.frame(
  Group = c("Control", "Treatment"),
  Survival = as.numeric(surv_est),
  SE = c(0.02, 0.02)  # Approximate SE for visualization
)

bar_plot <- ggplot(bar_data, aes(x = Group, y = Survival, fill = Group)) +
  geom_col(width = 0.6, alpha = 0.8) +
  geom_errorbar(
    aes(ymin = Survival - 1.96 * SE, ymax = pmin(Survival + 1.96 * SE, 1)),
    width = 0.2,
    linewidth = 0.8
  ) +
  geom_text(
    aes(label = sprintf("%.3f", Survival)),
    vjust = -2,
    size = 6,
    fontface = "bold"
  ) +
  scale_fill_manual(values = c("Control" = "#E63946", "Treatment" = "#2E86AB")) +
  labs(
    title = "TMLE Estimated Survival at t = 365 Days",
    subtitle = sprintf("Survival Difference: %.4f", rd),
    x = "",
    y = "Survival Probability"
  ) +
  theme_presentation(base_size = 16) +
  theme(legend.position = "none") +
  scale_y_continuous(limits = c(0, 1.15), breaks = seq(0, 1, 0.2))

ggsave(
  file.path(output_dir, "04_survtmle_bar.png"),
  bar_plot,
  width = 6,
  height = 5,
  dpi = 300
)

# --- Print Results ---
cat("\n=== Survival TMLE Results ===\n")
cat("\nEstimated Survival at t = 365:\n")
print(fit_surv$est)
cat("\nSurvival Difference (Treatment - Control):", round(rd, 4), "\n")
cat("\nOutput saved to:", output_dir, "\n")
cat("- 04_baseline_survival.html\n")
cat("- 04_survtmle_results.html\n")
cat("- 04_survtmle_km_curve.png\n")
cat("- 04_survtmle_bar.png\n")
