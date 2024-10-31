#Everything you’ll need to do for this assignment will be done in this script and submitted via GitHub.
#Use comments to separate your code blocks into Exercise 1, Step 1.1; Exercise 1, Step 1.2; etc., 
#and include written answers to questions as comments.

#Exercise 1 
#Step 1.1 Loading data and importing libraries
library(tidyverse)
library(DESeq2)
#1.1.1 read the data and metadata into separate tibbles 
data_df <- read_delim("gtex_whole_blood_counts_downsample.txt")
data_df[1:5,] 

metadata_df <- read_delim("gtex_metadata_downsample.txt")
metadata_df[1:5,] 

#1.1.2
# move the sample IDs from the first column to row names
data_df <- column_to_rownames(data_df, var = "GENE_NAME")
colnames(data_df)
rownames(metadata_df)
data_df[1:5,] #check the tibble

#1.1.3
#move the subject IDs, which are stored in the first column to instead be stored as row names.
metadata_df <- column_to_rownames(metadata_df, var = "SUBJECT_ID")
colnames(metadata_df)
rownames(data_df)
data_df[1:5,] #1.1.4 checking tibble

#Step 1.2 Create a DESeq2 object
#1.2.2 ensure that the columns of the count matrix and the rows of the column data (information about samples) are in the same order.
all(colnames(data_df) == rownames(metadata_df))

# load DESeq2 object
dds <- DESeqDataSetFromMatrix(countData = data_df,
                              colData = metadata_df,
                              design = ~ SEX + DTHHRDY + AGE)
#Step 1.3 Normalization and PCA
#1.3.1
vsd <- vst(dds)
#1.3.2 Perform PCA with different grouping variables and save plots

# PCA plot colored by SEX
plotPCA(vsd, intgroup = "SEX")

# PCA plot colored by DTHHRDY
plotPCA(vsd, intgroup = "DTHHRDY")

# PCA plot colored by AGE
plotPCA(vsd, intgroup = "AGE")

# Step 1.3.2: Perform PCA with different grouping variables, display and save plots

# PCA plot colored by SEX
pca_sex <- plotPCA(vsd, intgroup = "SEX")
ggsave("PCA_by_SEX.png", plot = pca_sex, width = 6, height = 4, dpi = 300)

# PCA plot colored by DTHHRDY
pca_dthhrdy <- plotPCA(vsd, intgroup = "DTHHRDY")
ggsave("PCA_by_DTHHRDY.png", plot = pca_dthhrdy, width = 6, height = 4, dpi = 300)

# PCA plot colored by AGE
pca_age <- plotPCA(vsd, intgroup = "AGE")
ggsave("PCA_by_AGE.png", plot = pca_age, width = 6, height = 4, dpi = 300)

#1.3.3: What proportion of variance in the gene expression data is explained by each of the first two principal components? 
#Which principal components appear to be associated with which subject-level variables? Interpret these patterns in your own
#words and record your answers as a comment in your code.
### 48% of the variance is explained by PC1 and 7% by PC2. Based on the graphs, I see clear separation between the fast death of natural causes e vs ventilator death, I think this is PC1. And age seems to be PC2. 

#Exercise 2
#extract the VST expression matrix and bind it to the metadata, such that the whole data frame can be used as input to a regression model
# Step 1: Convert the VST expression matrix to a tibble and transpose it
vsd_df <- assay(vsd) %>%
  t() %>%
  as_tibble(rownames = "SUBJECT_ID")  # Keeps SUBJECT_ID for alignment

# Step 2: Ensure metadata has correct row names and bind metadata to expression data by matching SUBJECT_ID
metadata_df <- rownames_to_column(metadata_df, var = "SUBJECT_ID")
vsd_df <- left_join(metadata_df, vsd_df, by = "SUBJECT_ID")

# Step 3: Fit a linear model for WASH7P
m1 <- lm(formula = WASH7P ~ DTHHRDY + AGE + SEX, data = vsd_df)

# Summarize and tidy the model output
m1_summary <- summary(m1) %>%
  broom::tidy()

# Display the tidy output
print(m1_summary)
#2.1.1: Does WASH7P show significant evidence of sex-differential expression (and if so, in which direction)? Explain your answer.
#The p value is not significant for a difference in expression between males and females. There is a slight increased seen in men, but a p value of .279 is non significant. 

# Fit a linear model for SLC25A47, including DTHHRDY, AGE, and SEX as predictors
m2 <- lm(formula = SLC25A47 ~ DTHHRDY + AGE + SEX, data = vsd_df)

# Summarize and tidy the model output
m2_summary <- summary(m2) %>%
  broom::tidy()

# Display the tidy output for interpretation
print(m2_summary)

#2.1.2 Repeat for gene SLC25A47.
# Fit a linear model for SLC25A47, including DTHHRDY, AGE, and SEX as predictors
##This gene is significantly increased in males with a p value of 0.002. There is also a significant downregulation in DTHHRDYventilator_case. 
m2 <- lm(formula = SLC25A47 ~ DTHHRDY + AGE + SEX, data = vsd_df)

# Summarize and tidy the model output
m2_summary <- summary(m2) %>%
  broom::tidy()

# Display the tidy output for interpretation
print(m2_summary)

#Step 2.2: Perform differential expression analysis “the right way” with DESeq2
#2.2.1 differential expression analysis the right way with DESeq

# DESeq to fit the model on the original count data
dds <- DESeq(dds)

#Step 2.3 Extract and interpret results for sex differential expression 
#2.3.1 Extract results for sex differential expression
res_sex <- results(dds, name = "SEX_male_vs_female") %>%
  as_tibble(rownames = "GENE_NAME")
print(res_sex)

#2.3.2 How many genes exhibit significant differential expression between males and females at a 10% FDR? 262
# Count the number of genes with padj < 0.1
significant_genes <- res_sex %>%
  filter(!is.na(padj) & padj < 0.1) %>%
  nrow()
print(significant_genes)

#2.2.3
#Load gene-to-chromosome mappings
gene_mapping <- read_delim("gene_locations.txt")

#Merge with differential expression results
merged_results <- left_join(res_sex, gene_mapping, by = "GENE_NAME")
#2.3.3
#padj from smallest to largest
ordered_results <- merged_results %>%
  arrange(padj)
  
# Display the ordered results
print(ordered_results)
### The Y chromosome is the most strongly up-regulated in males versus females since females lack a Y chromosome. 

#2.3.4
# Examine WASH7P and SLC25A47
#WASH7P is still not significantly up-regulated and is significantly upregulated but by orders of magnitude more than with the previous analysis. 
selected_genes <- ordered_results %>%
  filter(GENE_NAME %in% c("WASH7P", "SLC25A47"))

print(selected_genes)

#Step 2.4 Extract and interpret the results for differential expression by death classification
#2.4.1
# 2.4.1 Differential expression analysis based on death classification (DTHHRDY)

#Death classification comparison
resultsNames(dds)
# Pull death classification comparisons 
res_death <- results(dds, name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes") %>%
  as_tibble(rownames = "GENE_NAME")
# Pull sig death classification comparisons 
significant_genes_death <- res_death %>%
  filter(!is.na(padj) & padj < 0.1) %>%
  nrow()
print(significant_genes_death)
##How many genes are differentially expressed according to death classification at a 10% FDR? 16069
#2.4.2 This makes sense to me because the PCA suggested that sex was less a differential factor than cause of death.

#Exercise 3: Visualization
#3.1 make volcano plot from 2.3 expression data

#Load libraries
library(ggplot2)
library(dplyr)

#prep data for plot- log transform and set threshold 
volcano_data <- res_sex %>%
  mutate(neg_log10_padj = -log10(padj), significant = abs(log2FoldChange) > 1 & padj < 0.1)

#volcano plot 
volcano_plot <- ggplot(data = volcano_data, aes(x = log2FoldChange, y = neg_log10_padj)) +
  geom_point(aes(color = significant)) +
  geom_text(
    data = volcano_data %>% filter(significant),
    aes(x = log2FoldChange, y = neg_log10_padj + 0.5, label = GENE_NAME),
    size = 3,
    vjust = 1,
    hjust = 0.5
  ) +
  theme_bw() +
  theme(legend.position = "none") +
  scale_color_manual(values = c("darkgray", "coral")) +
  labs(
    y = expression(-log[10]("adjusted p-value")),
    x = expression(log[2]("fold change")),
    title = "Volcano Plot of Differential Expression Results"
  ) +
  ylim(0, 100)  # Adjusting the upper limit of the y-axis since some genes keep getting cut off- some will just be out of range I guess?
#Save the plot as a PNG file
ggsave("volcano_plot.png", plot = volcano_plot, width = 8, height = 10, dpi = 300)







