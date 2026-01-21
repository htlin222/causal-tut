required_pkgs <- c("cobalt", "WeightIt")
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

df <- read.csv("data/09_r-workflow/df_binary.csv")

w <- weightit(
  treatment ~ age + sex + comorbidity + severity,
  data = df,
  method = "ps"
)

print(bal.tab(w, thresholds = c(m = 0.1)))

love.plot(
  w,
  thresholds = c(m = 0.1),
  abs = TRUE,
  var.order = "unadjusted"
)
