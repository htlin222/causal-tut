required_pkgs <- c("survival", "WeightIt")
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

df <- read.csv("data/09_r-workflow/df_survival.csv")

w <- weightit(
  treatment ~ age + sex + comorbidity + severity,
  data = df,
  method = "ps"
)

fit_cox <- coxph(
  Surv(time, event) ~ treatment,
  data = df,
  weights = w$weights
)

print(summary(fit_cox))
