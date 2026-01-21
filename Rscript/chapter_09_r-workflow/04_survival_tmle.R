options(repos = c(CRAN = "https://cloud.r-project.org"))

required_pkgs <- c("SuperLearner", "dplyr")
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

SL.lib <- c("SL.glm")

df <- read.csv("data/09_r-workflow/df_survival.csv")
df <- df |> filter(time > 0) |> slice_head(n = 150)

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

print(fit_surv$est)
