# =============================================================================
# TMLE Analysis for Binary Outcome
# Output: gtsummary HTML table + ggplot forest plot
# =============================================================================

# --- Package Installation ---
required_pkgs <- c("tmle", "SuperLearner", "dplyr", "gtsummary", "gt", "ggplot2")
missing_pkgs <- required_pkgs[!vapply(
  required_pkgs,
  requireNamespace,
  logical(1),
  quietly = TRUE
)]
if (length(missing_pkgs) > 0) {
  install.packages(missing_pkgs)
}

library(tmle)
library(SuperLearner)
library(dplyr)
library(gtsummary)
library(gt)
library(ggplot2)

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
SL.lib <- c("SL.glm", "SL.glmnet")
output_dir <- "output/chapter_09"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

# --- Load Data ---
df <- read.csv("data/09_r-workflow/df_binary.csv")

# --- Baseline Characteristics Table (gtsummary) ---
baseline_table <- df |>
  select(treatment, age, sex, comorbidity, severity, death) |>
  mutate(
    treatment = factor(treatment, levels = c(0, 1), labels = c("Control", "Treatment")),
    sex = factor(sex, levels = c(0, 1), labels = c("Female", "Male")),
    death = factor(death, levels = c(0, 1), labels = c("Alive", "Dead"))
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
      death ~ "Death"
    ),
    digits = all_continuous() ~ 1
  ) |>
  add_p() |>
  add_overall() |>
  modify_header(label ~ "**Variable**") |>
  modify_caption("**Table 1. Baseline Characteristics (Binary Outcome)**")

# Save baseline table as HTML
baseline_table |>
  as_gt() |>
  gtsave(file.path(output_dir, "03_baseline_binary.html"))

# --- TMLE Analysis ---
fit_bin <- tmle(
  Y = df$death,
  A = df$treatment,
  W = df |> select(age, sex, comorbidity, severity),
  Q.SL.library = SL.lib,
  g.SL.library = SL.lib,
  family = "binomial"
)

# --- Extract Results ---
binary_results <- data.frame(
  Estimand = c("Risk Difference (RD)", "Risk Ratio (RR)"),
  Estimate = c(
    fit_bin$estimates$ATE$psi,
    fit_bin$estimates$RR$psi
  ),
  SE = c(
    sqrt(fit_bin$estimates$ATE$var.psi),
    NA  # RR SE not directly available
  ),
  CI_lower = c(
    fit_bin$estimates$ATE$CI[1],
    fit_bin$estimates$RR$CI[1]
  ),
  CI_upper = c(
    fit_bin$estimates$ATE$CI[2],
    fit_bin$estimates$RR$CI[2]
  ),
  p_value = c(
    fit_bin$estimates$ATE$pvalue,
    fit_bin$estimates$RR$pvalue
  )
)

# --- TMLE Results Table (gt) ---
results_table <- binary_results |>
  gt() |>
  tab_header(
    title = md("**TMLE Estimation Results: Binary Outcome**"),
    subtitle = "Death (0/1)"
  ) |>
  fmt_number(columns = c(Estimate, SE, CI_lower, CI_upper), decimals = 3) |>
  fmt_scientific(columns = p_value, decimals = 2) |>
  cols_label(
    Estimand = "Estimand",
    Estimate = "Estimate",
    SE = "Std. Error",
    CI_lower = "95% CI Lower",
    CI_upper = "95% CI Upper",
    p_value = "P-value"
  ) |>
  sub_missing(missing_text = "-") |>
  tab_footnote(
    footnote = "TMLE with Super Learner (GLM + GLMNet)",
    locations = cells_title(groups = "subtitle")
  ) |>
  tab_source_note(
    source_note = md("**Clinical Interpretation**: RD < 0 indicates treatment reduces death risk.")
  )

# Save results table as HTML
results_table |>
  gtsave(file.path(output_dir, "03_tmle_binary_results.html"))

# --- Forest Plot for Binary Outcomes (ggplot2) ---
forest_data <- binary_results |>
  mutate(
    label = sprintf("%.3f (%.3f, %.3f)", Estimate, CI_lower, CI_upper),
    # For RR, reference line is 1; for RD, reference line is 0
    ref_line = ifelse(grepl("RR", Estimand), 1, 0)
  )

# RD Forest Plot
rd_data <- forest_data |> filter(grepl("RD", Estimand))
rd_plot <- ggplot(rd_data, aes(x = Estimand, y = Estimate)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50", linewidth = 0.8) +
  geom_pointrange(
    aes(ymin = CI_lower, ymax = CI_upper),
    color = "#E63946",
    size = 1.5,
    linewidth = 1.2
  ) +
  geom_text(
    aes(label = label),
    vjust = -1.5,
    size = 5
  ) +
  coord_flip() +
  labs(
    title = "Risk Difference (RD)",
    subtitle = "TMLE Estimate",
    x = "",
    y = "Risk Difference",
    caption = sprintf("P-value: %.2e", rd_data$p_value)
  ) +
  theme_presentation(base_size = 16) +
  theme(panel.grid.major.y = element_blank()) +
  scale_y_continuous(limits = c(-0.35, 0.1))

# RR Forest Plot
rr_data <- forest_data |> filter(grepl("RR", Estimand))
rr_plot <- ggplot(rr_data, aes(x = Estimand, y = Estimate)) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "gray50", linewidth = 0.8) +
  geom_pointrange(
    aes(ymin = CI_lower, ymax = CI_upper),
    color = "#457B9D",
    size = 1.5,
    linewidth = 1.2
  ) +
  geom_text(
    aes(label = label),
    vjust = -1.5,
    size = 5
  ) +
  coord_flip() +
  labs(
    title = "Risk Ratio (RR)",
    subtitle = "TMLE Estimate",
    x = "",
    y = "Risk Ratio",
    caption = sprintf("P-value: %.2e", rr_data$p_value)
  ) +
  theme_presentation(base_size = 16) +
  theme(panel.grid.major.y = element_blank()) +
  scale_y_continuous(limits = c(0.3, 1.3))

# Combined forest plot
library(patchwork)
combined_plot <- rd_plot / rr_plot +
  plot_annotation(
    title = "TMLE Estimates: Binary Outcome (Death)",
    theme = theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5))
  )

# Save forest plots
ggsave(
  file.path(output_dir, "03_tmle_binary_forest.png"),
  combined_plot,
  width = 9,
  height = 7,
  dpi = 300
)

# --- Print Results ---
cat("\n=== TMLE Results: Binary Outcome ===\n")
cat("\nRisk Difference (RD):\n")
print(fit_bin$estimates$ATE)
cat("\nRisk Ratio (RR):\n")
print(fit_bin$estimates$RR)
cat("\nOutput saved to:", output_dir, "\n")
cat("- 03_baseline_binary.html\n")
cat("- 03_tmle_binary_results.html\n")
cat("- 03_tmle_binary_forest.png\n")
