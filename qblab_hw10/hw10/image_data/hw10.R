# Load necessary libraries
library(ggplot2)

# Set the path to the text file
data_file <- "/Users/cmdb/qbb2024-answers/qblab_hw10/hw10/results/nucleus_signal_data.txt"

# Read the data into R
data <- read.csv(data_file)

# View the first few rows of the data
head(data)

str(data)
summary(data)

ggplot(data, aes(x = Gene, y = nascentRNA)) +
  geom_violin(trim = FALSE, fill = "lightblue") +
  geom_jitter(width = 0.2, alpha = 0.5, color = "darkblue") +
  labs(title = "Violin Plot of nascentRNA Signal",
       x = "Gene",
       y = "Mean nascentRNA Signal") +
  theme_minimal()

ggplot(data, aes(x = Gene, y = PCNA)) +
  geom_violin(trim = FALSE, fill = "lightgreen") +
  geom_jitter(width = 0.2, alpha = 0.5, color = "darkgreen") +
  labs(title = "Violin Plot of PCNA Signal",
       x = "Gene",
       y = "Mean PCNA Signal") +
  theme_minimal()

ggplot(data, aes(x = Gene, y = ratio)) +
  geom_violin(trim = FALSE, fill = "lightcoral") +
  geom_jitter(width = 0.2, alpha = 0.5, color = "darkred") +
  labs(title = "Violin Plot of log2(nascentRNA / PCNA) Ratio",
       x = "Gene",
       y = "Log2 Ratio") +
  theme_minimal()

highest_ratio <- data[which.max(data$ratio), ]
lowest_ratio <- data[which.min(data$ratio), ]

print(highest_ratio)
print(lowest_ratio)

# Save the nascentRNA plot
ggsave("nascentRNA_violin_plot.pdf", width = 8, height = 6)

# Save the PCNA plot
ggsave("PCNA_violin_plot.pdf", width = 8, height = 6)

# Save the ratio plot
ggsave("ratio_violin_plot.pdf", width = 8, height = 6)




