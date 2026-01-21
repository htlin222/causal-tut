x <- 10
name <- "treatment"

ages <- c(45, 52, 67, 38)
mean_age <- mean(ages)

patients <- data.frame(
  id = 1:4,
  age = ages,
  treatment = c(1, 1, 0, 0)
)

print(x)
print(name)
print(mean_age)
print(patients)
