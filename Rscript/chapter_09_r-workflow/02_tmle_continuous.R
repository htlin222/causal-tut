required_pkgs <- c("tmle", "SuperLearner", "dplyr")
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

SL.lib <- c("SL.glm", "SL.glmnet")

df <- read.csv("data/09_r-workflow/df_continuous.csv")

fit_cont <- tmle(
  Y = df$outcome,
  A = df$treatment,
  W = df |> select(age, sex, comorbidity, severity),
  Q.SL.library = SL.lib,
  g.SL.library = SL.lib,
  family = "gaussian"
)

print(fit_cont$estimates$ATE)
