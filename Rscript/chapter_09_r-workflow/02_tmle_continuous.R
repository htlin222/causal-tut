# =============================================================================
# TMLE Analysis for Continuous Outcome
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
df <- read.csv("data/09_r-workflow/df_continuous.csv")

# --- Baseline Characteristics Table (gtsummary) ---
baseline_table <- df |>
  select(treatment, age, sex, comorbidity, severity, outcome) |>
  mutate(
    treatment = factor(treatment, levels = c(0, 1), labels = c("Control", "Treatment")),
    sex = factor(sex, levels = c(0, 1), labels = c("Female", "Male"))
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
      outcome ~ "Blood pressure change (mmHg)"
    ),
    digits = all_continuous() ~ 1
  ) |>
  add_p() |>
  add_overall() |>
  modify_header(label ~ "**Variable**") |>
  modify_caption("**Table 1. Baseline Characteristics**")

# Save baseline table as HTML
baseline_table |>
  as_gt() |>
  gtsave(file.path(output_dir, "02_baseline_continuous.html"))

# --- TMLE Analysis ---
fit_cont <- tmle(
  Y = df$outcome,
  A = df$treatment,
  W = df |> select(age, sex, comorbidity, severity),
  Q.SL.library = SL.lib,
  g.SL.library = SL.lib,
  family = "gaussian"
)

# --- Extract Results ---
ate_results <- data.frame(
  Estimand = "Average Treatment Effect (ATE)",
  Estimate = fit_cont$estimates$ATE$psi,
  SE = sqrt(fit_cont$estimates$ATE$var.psi),
  CI_lower = fit_cont$estimates$ATE$CI[1],
  CI_upper = fit_cont$estimates$ATE$CI[2],
  p_value = fit_cont$estimates$ATE$pvalue
)

# --- TMLE Results Table (gtsummary style with gt) ---
results_table <- ate_results |>
  gt() |>
  tab_header(
    title = md("**TMLE Estimation Results: Continuous Outcome**"),
    subtitle = "Blood pressure change (mmHg)"
  ) |>
  fmt_number(columns = c(Estimate, SE, CI_lower, CI_upper), decimals = 2) |>
  fmt_scientific(columns = p_value, decimals = 2) |>
  cols_label(
    Estimand = "Estimand",
    Estimate = "Estimate",
    SE = "Std. Error",
    CI_lower = "95% CI Lower",
    CI_upper = "95% CI Upper",
    p_value = "P-value"
  ) |>
  tab_footnote(
    footnote = "TMLE with Super Learner (GLM + GLMNet)",
    locations = cells_title(groups = "subtitle")
  ) |>
  tab_source_note(
    source_note = md("**Clinical Interpretation**: Treatment group showed a mean blood pressure reduction compared to control.")
  )

# Save results table as HTML
results_table |>
  gtsave(file.path(output_dir, "02_tmle_continuous_results.html"))

# --- Forest Plot (ggplot2) ---
forest_plot <- ggplot(ate_results, aes(x = Estimand, y = Estimate)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50", linewidth = 0.8) +
  geom_pointrange(
    aes(ymin = CI_lower, ymax = CI_upper),
    color = "#2E86AB",
    size = 1.5,
    linewidth = 1.2
  ) +
  geom_text(
    aes(label = sprintf("%.2f (%.2f, %.2f)", Estimate, CI_lower, CI_upper)),
    vjust = -1.5,
    size = 5
  ) +
  coord_flip() +
  labs(
    title = "TMLE Estimate: Average Treatment Effect",
    subtitle = "Continuous outcome (blood pressure change, mmHg)",
    x = "",
    y = "Treatment Effect (mmHg)",
    caption = sprintf("P-value: %.2e", ate_results$p_value)
  ) +
  theme_presentation(base_size = 16) +
  theme(
    panel.grid.major.y = element_blank(),
    axis.text.y = element_text(face = "bold", size = 14)
  ) +
  scale_y_continuous(limits = c(-10, 2))

# Save forest plot
ggsave(
  file.path(output_dir, "02_tmle_continuous_forest.png"),
  forest_plot,
  width = 9,
  height = 4,
  dpi = 300
)

# --- Print Results ---
cat("\n=== TMLE Results: Continuous Outcome ===\n")
print(fit_cont$estimates$ATE)
cat("\nOutput saved to:", output_dir, "\n")
cat("- 02_baseline_continuous.html\n")
cat("- 02_tmle_continuous_results.html\n")
cat("- 02_tmle_continuous_forest.png\n")
