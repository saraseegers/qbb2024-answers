# install.packages("ggfortify")
# install.packages("hexbin")
# BiocManager::install("DESeq2")
# BiocManager::install("vsn")
#load libraries 
library(DESeq2)
library(vsn)
library(matrixStats)
library(readr)
library(dplyr)
library(tibble)
library(hexbin)
library(ggfortify)
#3.1
sessionInfo()

# Load the salmon merged file
data = readr::read_tsv("salmon.merged.gene_counts.tsv")

# Use gene_name as row names (this is done because gene_name is unique and useful for indexing)
data = column_to_rownames(data, var = "gene_name")

# Remove the gene_id column as it's redundant
data = data %>% dplyr::select(-"2gene_id")

# Convert all numeric columns (gene expression counts) to integers
data = data %>% dplyr::mutate_if(is.numeric, as.integer)

# Keep rows with at least 100 total reads across all samples (filtering low-coverage genes)
data = data[rowSums(data) > 100, ]

# Select samples covering midgut sections A1, A2-3, Cu, LFC-Fe, Fe, P1, and P2-4
narrowed_data = data %>% select("A1_Rep1":"P2-4_Rep3")

# Swap the columns for LFC-Fe_Rep3 and Fe_Rep1 in the narrowed data
narrowed_data[, c("LFC-Fe_Rep3", "Fe_Rep1")] <- narrowed_data[, c("Fe_Rep1", "LFC-Fe_Rep3")]
#3.2
# Create metadata with tissue types and replicates
narrowed_metadata = tibble(
  tissue = as.factor(c("A1", "A1", "A1", "A2-3", "A2-3", "A2-3", 
                       "Cu", "Cu", "Cu", "LFC_Fe", "LFC_Fe", "LFC_Fe", "Fe", "Fe","Fe", 
                       "P1", "P1", "P1", "P2-4", "P2-4", "P2-4")),
  rep = as.factor(c(1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2,3))
)


# Create a DESeq2 object from the narrowed data and metadata
ddsNarrowed = DESeqDataSetFromMatrix(countData = as.matrix(narrowed_data), 
                                     colData = narrowed_metadata, 
                                     design = ~tissue)

# Check the DESeq2 object
ddsNarrowed

#3.3
#plot data and correct for batch defects with the vst function 
vst_transformed_data = vst(ddsNarrowed)
#plot data
meanSdPlot(assay(vst_transformed_data))

library(ggplot2)

pca_data = plotPCA(vst_transformed_data, intgroup=c("rep","tissue"), returnData=TRUE)
ggplot(pca_data, aes(PC1, PC2, color=tissue, shape=rep)) +
  geom_point(size=5)

#put data into a matrix so can fix the swapped samples
pca_matrix = as.matrix(pca_data)
head(pca_matrix)

data[, c("LFC-Fe_Rep3", "Fe_Rep1")] <- data[, c("Fe_Rep1", "LFC-Fe_Rep3")]
head(data[, c("LFC-Fe_Rep3", "Fe_Rep1")])

# Recreate the DESeq2 dataset
ddsNarrowed = DESeqDataSetFromMatrix(countData = as.matrix(narrowed_data), 
                                     colData = narrowed_metadata, 
                                     design = ~tissue)

# Correct for batch defects with the vst function
vst_transformed_data = vst(ddsNarrowed)

# Recompute PCA
pca_data = plotPCA(vst_transformed_data, intgroup=c("rep", "tissue"), returnData=TRUE)

# Plot PCA with ggplot2
ggplot(pca_data, aes(PC1, PC2, color=tissue, shape=rep)) +
  geom_point(size=5)

# Convert combined data frame to a matrix
combined_matrix = as.matrix(assay(vst_transformed_data))
 
#3.4
combined = combined_matrix[,seq(1, 21, 3)]
combined = combined + combined_matrix[,seq(2, 21, 3)]
combined = combined + combined_matrix[,seq(3, 21, 3)]
combined = combined / 3
# Step 2: Calculate standard deviation for each gene
sds = rowSds(as.matrix(combined))

#3.5
filt = sds > 1
filtered_data = combined[filt, ]

#Set seed into 12 clusters 
set.seed(42)
kmeans_result = kmeans(filtered_data, centers = 12)
#Cluster labels 
cluster_labels = kmeans_result$cluster
#Sort rows
ordered_data = filtered_data[order(cluster_labels), ]
#Sort clusters
sorted_labels = cluster_labels[order(cluster_labels)]
#Generate heatmap
heatmap(ordered_data, Rowv = NA, Colv = NA, RowSideColors = RColorBrewer::brewer.pal(12, "Paired")[sorted_labels])
