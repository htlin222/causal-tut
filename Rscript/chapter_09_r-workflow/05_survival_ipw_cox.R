# =============================================================================
# IPW-Weighted Cox Regression for Survival Outcome
# Output: gtsummary HTML table + ggplot forest plot + KM curve
# =============================================================================

# --- Package Installation ---
required_pkgs <- c("survival", "WeightIt", "dplyr", "gtsummary", "gt", "ggplot2", "broom", "survey", "ggsurvfit")
missing_pkgs <- required_pkgs[!vapply(
  required_pkgs,
  requireNamespace,
  logical(1),
  quietly = TRUE
)]
if (length(missing_pkgs) > 0) {
  install.packages(missing_pkgs)
}

library(survival)
library(WeightIt)
library(dplyr)
library(gtsummary)
library(gt)
library(ggplot2)
library(broom)
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
output_dir <- "output/chapter_09"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

# --- Load Data ---
df <- read.csv("data/09_r-workflow/df_survival.csv")

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
  modify_caption("**Table 1. Baseline Characteristics (IPW Cox Analysis)**")

# Save baseline table as HTML
baseline_table |>
  as_gt() |>
  gtsave(file.path(output_dir, "05_baseline_ipw_cox.html"))

# --- Calculate IPW Weights ---
w <- weightit(
  treatment ~ age + sex + comorbidity + severity,
  data = df,
  method = "ps"
)

# Add weights to data
df$ipw <- w$weights

# --- IPW-Weighted Cox Regression ---
fit_cox <- coxph(
  Surv(time, event) ~ treatment,
  data = df,
  weights = ipw
)

# --- Extract Results ---
cox_summary <- summary(fit_cox)
cox_tidy <- tidy(fit_cox, exponentiate = TRUE, conf.int = TRUE)

cox_results <- data.frame(
  Estimand = "Hazard Ratio (HR)",
  Estimate = cox_summary$conf.int[1, "exp(coef)"],
  SE = cox_summary$coefficients[1, "se(coef)"],
  CI_lower = cox_summary$conf.int[1, "lower .95"],
  CI_upper = cox_summary$conf.int[1, "upper .95"],
  p_value = cox_summary$coefficients[1, "Pr(>|z|)"]
)

# --- Cox Results Table (gt-based) ---
# Create a clean results table using gt directly
cox_table <- data.frame(
  Variable = "Treatment (vs Control)",
  HR = round(cox_summary$conf.int[1, "exp(coef)"], 2),
  `95% CI` = sprintf(
    "(%.2f, %.2f)",
    cox_summary$conf.int[1, "lower .95"],
    cox_summary$conf.int[1, "upper .95"]
  ),
  `P-value` = format.pval(cox_summary$coefficients[1, "Pr(>|z|)"], digits = 3),
  check.names = FALSE
)

cox_table |>
  gt() |>
  tab_header(
    title = md("**Table 2. IPW-Weighted Cox Regression Results**"),
    subtitle = "Hazard Ratio for Treatment Effect"
  ) |>
  tab_source_note(
    source_note = md("**Clinical Interpretation**: HR < 1 indicates treatment reduces hazard (protective effect).")
  ) |>
  gtsave(file.path(output_dir, "05_ipw_cox_results.html"))

# --- Detailed Results Table (gt) ---
detailed_table <- cox_results |>
  gt() |>
  tab_header(
    title = md("**IPW-Weighted Cox Regression Results**"),
    subtitle = "Hazard Ratio for Treatment Effect"
  ) |>
  fmt_number(columns = c(Estimate, SE, CI_lower, CI_upper), decimals = 3) |>
  fmt_scientific(columns = p_value, decimals = 2) |>
  cols_label(
    Estimand = "Estimand",
    Estimate = "HR",
    SE = "SE (log HR)",
    CI_lower = "95% CI Lower",
    CI_upper = "95% CI Upper",
    p_value = "P-value"
  ) |>
  tab_footnote(
    footnote = "IPW weights calculated using logistic regression propensity scores",
    locations = cells_title(groups = "subtitle")
  ) |>
  tab_source_note(
    source_note = md(sprintf(
      "**Interpretation**: HR = %.2f means treatment group has %.0f%% %s hazard compared to control.",
      cox_results$Estimate,
      abs(1 - cox_results$Estimate) * 100,
      ifelse(cox_results$Estimate < 1, "lower", "higher")
    ))
  )

detailed_table |>
  gtsave(file.path(output_dir, "05_ipw_cox_detailed.html"))

# --- Forest Plot (ggplot2) ---
forest_plot <- ggplot(cox_results, aes(x = Estimand, y = Estimate)) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "gray50", linewidth = 0.8) +
  geom_pointrange(
    aes(ymin = CI_lower, ymax = CI_upper),
    color = "#1D3557",
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
    title = "IPW-Weighted Cox Regression: Hazard Ratio",
    subtitle = "Treatment vs Control",
    x = "",
    y = "Hazard Ratio",
    caption = sprintf("P-value: %.2e", cox_results$p_value)
  ) +
  theme_presentation(base_size = 16) +
  theme(
    panel.grid.major.y = element_blank(),
    axis.text.y = element_text(face = "bold", size = 14)
  ) +
  scale_y_continuous(limits = c(0.3, 1.3), breaks = seq(0.4, 1.2, 0.2))

ggsave(
  file.path(output_dir, "05_ipw_cox_forest.png"),
  forest_plot,
  width = 9,
  height = 4,
  dpi = 300
)

# --- Weighted Kaplan-Meier Curves ---
# Create weighted KM using survey package approach
library(survey)

# Create survey design with IPW weights
svy_design <- svydesign(
  ids = ~1,
  weights = ~ipw,
  data = df
)

# Fit weighted KM
km_weighted <- svykm(Surv(time, event) ~ treatment, design = svy_design)

# Extract KM data for both groups
km_data <- rbind(
  data.frame(
    time = km_weighted$`0`$time,
    surv = km_weighted$`0`$surv,
    group = "Control"
  ),
  data.frame(
    time = km_weighted$`1`$time,
    surv = km_weighted$`1`$surv,
    group = "Treatment"
  )
)

km_plot <- ggplot(km_data, aes(x = time, y = surv, color = group)) +
  geom_step(linewidth = 1.2) +
  scale_color_manual(
    values = c("Control" = "#E63946", "Treatment" = "#2E86AB"),
    name = "Group"
  ) +
  labs(
    title = "IPW-Weighted Kaplan-Meier Survival Curves",
    subtitle = sprintf("HR = %.2f (95%% CI: %.2f - %.2f), p = %.3f",
      cox_results$Estimate,
      cox_results$CI_lower,
      cox_results$CI_upper,
      cox_results$p_value
    ),
    x = "Time (days)",
    y = "Survival Probability"
  ) +
  theme_presentation(base_size = 16) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(limits = c(0, max(df$time) * 1.05), expand = c(0.02, 0))

ggsave(
  file.path(output_dir, "05_ipw_cox_km_curve.png"),
  km_plot,
  width = 10,
  height = 6,
  dpi = 300
)

# --- Weight Diagnostics Table ---
weight_diag <- data.frame(
  Metric = c("Min Weight", "Max Weight", "Mean Weight", "SD Weight", 
             "ESS Control", "ESS Treatment", "ESS Ratio"),
  Value = c(
    min(df$ipw),
    max(df$ipw),
    mean(df$ipw),
    sd(df$ipw),
    sum(df$ipw[df$treatment == 0])^2 / sum(df$ipw[df$treatment == 0]^2),
    sum(df$ipw[df$treatment == 1])^2 / sum(df$ipw[df$treatment == 1]^2),
    (sum(df$ipw[df$treatment == 0])^2 / sum(df$ipw[df$treatment == 0]^2)) / sum(df$treatment == 0)
  )
)

weight_table <- weight_diag |>
  gt() |>
  tab_header(
    title = md("**Weight Diagnostics**"),
    subtitle = "IPW Weight Distribution Summary"
  ) |>
  fmt_number(columns = Value, decimals = 2) |>
  tab_source_note(
    source_note = "ESS = Effective Sample Size. ESS Ratio close to 1 indicates uniform weights."
  )

weight_table |>
  gtsave(file.path(output_dir, "05_ipw_weight_diagnostics.html"))

# --- Print Results ---
cat("\n=== IPW-Weighted Cox Regression Results ===\n")
print(summary(fit_cox))
cat("\nWeight Diagnostics:\n")
print(weight_diag)
cat("\nOutput saved to:", output_dir, "\n")
cat("- 05_baseline_ipw_cox.html\n")
cat("- 05_ipw_cox_results.html\n")
cat("- 05_ipw_cox_detailed.html\n")
cat("- 05_ipw_cox_forest.png\n")
cat("- 05_ipw_cox_km_curve.png\n")
cat("- 05_ipw_weight_diagnostics.html\n")
