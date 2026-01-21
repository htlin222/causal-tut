options(repos = c(CRAN = "https://cloud.r-project.org"))

required_pkgs <- c(
  "tmle",
  "SuperLearner",
  "cobalt",
  "WeightIt",
  "ggplot2",
  "dplyr",
  "survival",
  "EValue"
)

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
