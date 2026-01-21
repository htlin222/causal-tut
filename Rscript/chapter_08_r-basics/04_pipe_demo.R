required_pkgs <- c("dplyr")
missing_pkgs <- required_pkgs[!vapply(
  required_pkgs,
  requireNamespace,
  logical(1),
  quietly = TRUE
)]
if (length(missing_pkgs) > 0) {
  install.packages(missing_pkgs)
}

library(dplyr)

patients <- read.csv("data/08_r-basics/patients_basic.csv")

result <- patients |>
  filter(age > 50) |>
  select(id, age, treatment, outcome)

print(result)
