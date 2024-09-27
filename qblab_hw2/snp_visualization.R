# Load necessary libraries
library(ggplot2)
library(dplyr)

# Step 1: Load the SNP enrichment data from the file 'snp_counts.txt'
snp_data <- read.table("snp_counts.txt", header=TRUE, sep="\t")

# Step 2: Log2-transform the enrichment values
snp_data$log2_enrichment <- log2(snp_data$Enrichment)

# Step 3: Create a ggplot with 4 lines, one for each feature
# The plot will have MAF on the X-axis and log2-transformed enrichment on the Y-axis

# Convert MAF to a factor for proper ordering in the plot
snp_data$MAF <- as.factor(snp_data$MAF)

# Create the plot
snp_plot <- ggplot(snp_data, aes(x=MAF, y=log2_enrichment, color=Feature, group=Feature)) +
  geom_line(size=1) +  # Line for each feature
  geom_point(size=2) +  # Points for each MAF-feature combination
  scale_y_continuous(name="Log2 Enrichment") +  # Y-axis label
  scale_x_discrete(name="Minor Allele Frequency (MAF)") +  # X-axis label
  theme_minimal() +  # Use a clean, minimal theme
  ggtitle("SNP Enrichment Across Features and MAF Levels") +  # Title
  theme(plot.title = element_text(hjust = 0.5)) +  # Center the title
  labs(color="Feature")  # Legend label

# Step 4: Save the plot as 'snp_enrichments.pdf'
ggsave("snp_enrichments.pdf", plot=snp_plot, width=8, height=6)

# Inform the user that the plot has been saved
cat("Plot saved as 'snp_enrichments.pdf'.\n")
