# =============================================================================
# Balance Diagnostics for IPW
# Output: gtsummary HTML table + ggplot Love Plot + PS overlap plot
# =============================================================================

# --- Package Installation ---
required_pkgs <- c("cobalt", "WeightIt", "dplyr", "gtsummary", "gt", "ggplot2", "tidyr")
missing_pkgs <- required_pkgs[!vapply(
  required_pkgs,
  requireNamespace,
  logical(1),
  quietly = TRUE
)]
if (length(missing_pkgs) > 0) {
  install.packages(missing_pkgs)
}

library(cobalt)
library(WeightIt)
library(dplyr)
library(gtsummary)
library(gt)
library(ggplot2)
library(tidyr)

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
df <- read.csv("data/09_r-workflow/df_binary.csv")

# --- Calculate IPW Weights ---
w <- weightit(
  treatment ~ age + sex + comorbidity + severity,
  data = df,
  method = "ps",
  estimand = "ATE"
)

# Add propensity scores to data
df$ps <- w$ps
df$ipw <- w$weights

# --- Baseline Characteristics Table (gtsummary) ---
baseline_table <- df |>
  select(treatment, age, sex, comorbidity, severity) |>
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
      severity ~ "Severity score"
    ),
    digits = all_continuous() ~ 1
  ) |>
  add_p() |>
  add_overall() |>
  modify_header(label ~ "**Variable**") |>
  modify_caption("**Table 1. Baseline Characteristics Before Weighting**")

# Save baseline table as HTML
baseline_table |>
  as_gt() |>
  gtsave(file.path(output_dir, "06_baseline_unweighted.html"))

# --- Balance Table (cobalt) ---
bal_out <- bal.tab(
  w,
  un = TRUE,
  disp.v.ratio = TRUE,
  thresholds = c(m = 0.1)
)

# Extract balance data
bal_df <- bal_out$Balance
bal_df <- bal_df[!grepl("prop.score", rownames(bal_df)), ]

# Create balance summary table
balance_summary <- data.frame(
  Variable = c("Age", "Sex", "Comorbidity", "Severity"),
  `SMD Before` = round(bal_df$Diff.Un, 3),
  `SMD After` = round(bal_df$Diff.Adj, 3),
  `Variance Ratio Before` = round(bal_df$V.Ratio.Un, 2),
  `Variance Ratio After` = round(bal_df$V.Ratio.Adj, 2),
  `Balanced` = ifelse(abs(bal_df$Diff.Adj) < 0.1, "Yes", "No"),
  check.names = FALSE
)

# --- Balance Table (gt) ---
balance_table <- balance_summary |>
  gt() |>
  tab_header(
    title = md("**Covariate Balance Assessment**"),
    subtitle = "Standardized Mean Differences Before and After IPW"
  ) |>
  tab_spanner(
    label = "SMD",
    columns = c(`SMD Before`, `SMD After`)
  ) |>
  tab_spanner(
    label = "Variance Ratio",
    columns = c(`Variance Ratio Before`, `Variance Ratio After`)
  ) |>
  tab_style(
    style = cell_fill(color = "#d4edda"),
    locations = cells_body(
      columns = Balanced,
      rows = Balanced == "Yes"
    )
  ) |>
  tab_style(
    style = cell_fill(color = "#f8d7da"),
    locations = cells_body(
      columns = Balanced,
      rows = Balanced == "No"
    )
  ) |>
  tab_footnote(
    footnote = "SMD < 0.1 indicates adequate balance",
    locations = cells_column_labels(columns = `SMD After`)
  ) |>
  tab_footnote(
    footnote = "Variance ratio should be between 0.5 and 2.0",
    locations = cells_column_labels(columns = `Variance Ratio After`)
  ) |>
  tab_source_note(
    source_note = md("**Interpretation**: All covariates should have SMD < 0.1 after weighting for adequate balance.")
  )

balance_table |>
  gtsave(file.path(output_dir, "06_balance_table.html"))

# --- Love Plot (ggplot2 custom version) ---
love_data <- data.frame(
  Variable = rep(c("Age", "Sex", "Comorbidity", "Severity"), 2),
  SMD = c(bal_df$Diff.Un, bal_df$Diff.Adj),
  Timing = factor(
    rep(c("Before Weighting", "After Weighting"), each = 4),
    levels = c("Before Weighting", "After Weighting")
  )
)

love_plot <- ggplot(love_data, aes(x = abs(SMD), y = reorder(Variable, abs(SMD)), 
                                    color = Timing, shape = Timing)) +
  geom_vline(xintercept = 0.1, linetype = "dashed", color = "#E63946", linewidth = 1) +
  geom_vline(xintercept = 0, linetype = "solid", color = "gray70") +
  geom_point(size = 5, alpha = 0.8) +
  geom_segment(
    data = love_data |> 
      pivot_wider(names_from = Timing, values_from = SMD, id_cols = Variable) |>
      mutate(
        Before = abs(`Before Weighting`),
        After = abs(`After Weighting`)
      ),
    aes(x = Before, xend = After, 
        y = Variable, yend = Variable),
    inherit.aes = FALSE,
    color = "gray50",
    arrow = arrow(length = unit(0.15, "cm"), type = "closed"),
    linewidth = 0.5
  ) +
  scale_color_manual(
    values = c("Before Weighting" = "#E63946", "After Weighting" = "#2E86AB"),
    name = ""
  ) +
  scale_shape_manual(
    values = c("Before Weighting" = 16, "After Weighting" = 17),
    name = ""
  ) +
  annotate(
    "text",
    x = 0.12,
    y = 0.5,
    label = "Threshold = 0.1",
    color = "#E63946",
    hjust = 0,
    size = 4.5
  ) +
  labs(
    title = "Love Plot: Covariate Balance",
    subtitle = "Absolute Standardized Mean Differences Before and After IPW",
    x = "Absolute SMD",
    y = ""
  ) +
  theme_presentation(base_size = 16) +
  theme(panel.grid.major.y = element_blank()) +
  scale_x_continuous(limits = c(0, max(abs(love_data$SMD)) * 1.2))

ggsave(
  file.path(output_dir, "06_love_plot.png"),
  love_plot,
  width = 9,
  height = 5,
  dpi = 300
)

# --- Propensity Score Overlap Plot ---
ps_plot <- ggplot(df, aes(x = ps, fill = factor(treatment))) +
  geom_density(alpha = 0.6, color = NA) +
  scale_fill_manual(
    values = c("0" = "#E63946", "1" = "#2E86AB"),
    labels = c("Control", "Treatment"),
    name = "Group"
  ) +
  geom_rug(aes(color = factor(treatment)), alpha = 0.3, sides = "b") +
  scale_color_manual(
    values = c("0" = "#E63946", "1" = "#2E86AB"),
    guide = "none"
  ) +
  labs(
    title = "Propensity Score Distribution",
    subtitle = "Assessing Overlap Between Treatment Groups",
    x = "Propensity Score",
    y = "Density"
  ) +
  theme_presentation(base_size = 16) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2))

ggsave(
  file.path(output_dir, "06_ps_overlap.png"),
  ps_plot,
  width = 9,
  height = 5,
  dpi = 300
)

# --- Weight Distribution Plot ---
weight_plot <- ggplot(df, aes(x = ipw, fill = factor(treatment))) +
  geom_histogram(alpha = 0.6, position = "identity", bins = 30, color = "white") +
  scale_fill_manual(
    values = c("0" = "#E63946", "1" = "#2E86AB"),
    labels = c("Control", "Treatment"),
    name = "Group"
  ) +
  geom_vline(
    xintercept = mean(df$ipw),
    linetype = "dashed",
    color = "gray30",
    linewidth = 1
  ) +
  annotate(
    "text",
    x = mean(df$ipw) + 0.1,
    y = Inf,
    label = sprintf("Mean = %.2f", mean(df$ipw)),
    vjust = 2,
    hjust = 0,
    size = 5
  ) +
  labs(
    title = "IPW Weight Distribution",
    subtitle = sprintf("Max weight = %.2f, Min weight = %.2f", max(df$ipw), min(df$ipw)),
    x = "IPW Weight",
    y = "Count"
  ) +
  theme_presentation(base_size = 16)

ggsave(
  file.path(output_dir, "06_weight_distribution.png"),
  weight_plot,
  width = 9,
  height = 5,
  dpi = 300
)

# --- Effective Sample Size Table ---
ess_control <- sum(df$ipw[df$treatment == 0])^2 / sum(df$ipw[df$treatment == 0]^2)
ess_treatment <- sum(df$ipw[df$treatment == 1])^2 / sum(df$ipw[df$treatment == 1]^2)
n_control <- sum(df$treatment == 0)
n_treatment <- sum(df$treatment == 1)

ess_table <- data.frame(
  Group = c("Control", "Treatment", "Total"),
  `Original N` = c(n_control, n_treatment, n_control + n_treatment),
  `Effective N` = c(ess_control, ess_treatment, ess_control + ess_treatment),
  `ESS Ratio` = c(
    ess_control / n_control,
    ess_treatment / n_treatment,
    (ess_control + ess_treatment) / (n_control + n_treatment)
  ),
  check.names = FALSE
) |>
  gt() |>
  tab_header(
    title = md("**Effective Sample Size (ESS)**"),
    subtitle = "Impact of IPW on Sample Size"
  ) |>
  fmt_number(columns = c(`Original N`, `Effective N`), decimals = 0) |>
  fmt_percent(columns = `ESS Ratio`, decimals = 1) |>
  tab_style(
    style = cell_fill(color = "#fff3cd"),
    locations = cells_body(
      columns = `ESS Ratio`,
      rows = `ESS Ratio` < 0.5
    )
  ) |>
  tab_footnote(
    footnote = "ESS Ratio < 50% indicates substantial information loss due to extreme weights",
    locations = cells_column_labels(columns = `ESS Ratio`)
  ) |>
  tab_source_note(
    source_note = md("**Interpretation**: ESS Ratio close to 100% indicates uniform weights with minimal information loss.")
  )

ess_table |>
  gtsave(file.path(output_dir, "06_ess_table.html"))

# --- Comprehensive Diagnostics Summary ---
diag_summary <- data.frame(
  Diagnostic = c(
    "All SMD < 0.1",
    "PS Overlap Adequate",
    "Max Weight < 10",
    "ESS Ratio > 50%"
  ),
  Status = c(
    ifelse(all(abs(bal_df$Diff.Adj) < 0.1), "PASS", "FAIL"),
    ifelse(
      min(df$ps[df$treatment == 1]) < max(df$ps[df$treatment == 0]) &&
      max(df$ps[df$treatment == 1]) > min(df$ps[df$treatment == 0]),
      "PASS", "FAIL"
    ),
    ifelse(max(df$ipw) < 10, "PASS", "FAIL"),
    ifelse(min(ess_control / n_control, ess_treatment / n_treatment) > 0.5, "PASS", "FAIL")
  ),
  Value = c(
    sprintf("Max SMD = %.3f", max(abs(bal_df$Diff.Adj))),
    sprintf("PS range: [%.2f, %.2f]", min(df$ps), max(df$ps)),
    sprintf("Max weight = %.2f", max(df$ipw)),
    sprintf("Min ESS ratio = %.1f%%", min(ess_control / n_control, ess_treatment / n_treatment) * 100)
  )
)

summary_table <- diag_summary |>
  gt() |>
  tab_header(
    title = md("**Balance Diagnostics Summary**"),
    subtitle = "Key Metrics for Assessing IPW Quality"
  ) |>
  tab_style(
    style = list(
      cell_fill(color = "#d4edda"),
      cell_text(weight = "bold")
    ),
    locations = cells_body(
      columns = Status,
      rows = Status == "PASS"
    )
  ) |>
  tab_style(
    style = list(
      cell_fill(color = "#f8d7da"),
      cell_text(weight = "bold")
    ),
    locations = cells_body(
      columns = Status,
      rows = Status == "FAIL"
    )
  ) |>
  tab_source_note(
    source_note = md("**All diagnostics should PASS before proceeding with causal effect estimation.**")
  )

summary_table |>
  gtsave(file.path(output_dir, "06_diagnostics_summary.html"))

# --- Print Results ---
cat("\n=== Balance Diagnostics Summary ===\n")
print(bal.tab(w, thresholds = c(m = 0.1)))
cat("\nEffective Sample Sizes:\n")
cat(sprintf("  Control: %.1f / %d (%.1f%%)\n", ess_control, n_control, ess_control / n_control * 100))
cat(sprintf("  Treatment: %.1f / %d (%.1f%%)\n", ess_treatment, n_treatment, ess_treatment / n_treatment * 100))
cat("\nOutput saved to:", output_dir, "\n")
cat("- 06_baseline_unweighted.html\n")
cat("- 06_balance_table.html\n")
cat("- 06_love_plot.png\n")
cat("- 06_ps_overlap.png\n")
cat("- 06_weight_distribution.png\n")
cat("- 06_ess_table.html\n")
cat("- 06_diagnostics_summary.html\n")
