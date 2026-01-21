required_pkgs <- c("EValue")
missing_pkgs <- required_pkgs[!vapply(
  required_pkgs,
  requireNamespace,
  logical(1),
  quietly = TRUE
)]
if (length(missing_pkgs) > 0) {
  install.packages(missing_pkgs)
}

library(EValue)

studies <- read.csv("data/10_sensitivity/evalue_studies.csv")

for (i in seq_len(nrow(studies))) {
  row <- studies[i, ]
  cat("\n", row$study, "\n", sep = "")
  print(evalues.RR(est = row$rr, lo = row$rr_lo, hi = row$rr_hi, true = 1))
}
