library(ggplot2)

df <- data.frame(
  category = c("A", "B", "C", "D"),
  value = c(12, 7, 15, 9)
)

ggplot(df, aes(x = category, y = value)) +
  geom_col(fill = "#4E79A7") +
  labs(
    title = "Sample Bar Chart",
    x = "Category",
    y = "Value"
  ) +
  theme_minimal(base_size = 12)
