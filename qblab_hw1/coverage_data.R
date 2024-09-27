# Load necessary libraries
library(ggplot2)

# Step 1: Read the coverage data
# Assuming genome_coverage.txt is a single-column text file with coverage values
coverage_data <- scan("30_genome_coverage.txt")

# Step 2: Plot the histogram of coverage data
png("ex1_30x_cov.png", width = 600, height = 800)  # Save the plot as PNG

# Create the histogram
hist(coverage_data, breaks = 50, freq = TRUE, col = "lightblue", 
     main = "Coverage Across Genome", 
     xlab = "Coverage", 
     ylab = "Frequency",
     xlim = c(0, 80),
     ylim = c(0, 450000))

# Step 3: Overlay Poisson distribution
# Define lambda for Poisson distribution
lambda <- 30

# Define the range of coverage values (from 0 to max value in coverage data)
coverage_values <- 0:max(coverage_data)

# Get the Poisson PMF for each coverage value
poisson_prob <- dpois(coverage_values, lambda = lambda)

# Scale the Poisson distribution to match the histogram frequency
scaled_poisson <- poisson_prob * length(coverage_data) * diff(hist(coverage_data, plot = FALSE)$breaks)[1]

# Add the Poisson distribution line to the plot
lines(coverage_values, scaled_poisson, col = "red", lwd = 2, type = "b", pch = 19)

# Step 4: Overlay Normal distribution
# Mean and standard deviation for the Normal distribution
mean_normal <- 30
sd_normal <- sqrt(30)  # 1.73; 3.16; 5.47

# Get the Normal PDF for each coverage value
normal_prob <- dnorm(coverage_values, mean = mean_normal, sd = sd_normal)

# Scale the Normal distribution to match the histogram frequency
scaled_normal <- normal_prob * length(coverage_data) * diff(hist(coverage_data, plot = FALSE)$breaks)[1]

# Add the Normal distribution line to the plot
lines(coverage_values, scaled_normal, col = "blue", lwd = 2, type = "b", pch = 19)

# Step 5: Add a legend
legend("topright", legend = c("Histogram", "Poisson (λ = 3)", "Normal (mean = 3, sd = 1.73)"), 
       col = c("lightblue", "red", "blue"), lwd = 2, pch = 19)

# Save the plot
dev.off()


