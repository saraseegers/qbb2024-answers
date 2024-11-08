# Load libraries
BiocManager::install("zellkonverter")
library(zellkonverter)
library(scuttle)
library(scater)
library(ggplot2)
library(scran)

# Load data into 'gut'
gut <- readH5AD("~/qbb2024-answers/qblab_hw8/hw8/v2_fca_biohub_gut_10x_raw.h5ad")

# Confirm 'gut' loaded correctly and assign assay names
assayNames(gut) <- "counts"
gut <- logNormCounts(gut)

# Exercise 1: Answering Questions
# 1. How many genes are quantitated? 13407
n_genes <- nrow(gut)
n_genes
head(n_genes)
# 2. How many cells are in the dataset? 11788
n_cells <- ncol(gut)
n_cells

# 3. What dimension reduction datasets are present? "X_pca"  "X_tsne" "X_umap"
dim_reductions <- reducedDimNames(gut)
dim_reductions

#Inspect cell metadata
#Question 2: Inspect the available cell metadata 

#How many columns are there in colData(gut)? 39
n_cols <- ncol(colData(gut))
n_cols

#Which three column names reported by colnames() seem most interesting? Briefly explain why.
#Tissue, age, sex are the columns that offer valuable information about each cell that is important to consider when interpreting the data. 
colnames(colData(gut))
head(gut)
#Plot cells according to X_umap using plotReducedDim() and colouring by broad_annotation
plotReducedDim(gut, "X_umap", colour_by = "broad_annotation")

#2. Explore data
#Explore gene-level statistics (1 pt)
#Sum the expression of each gene across all cells
gene_sums <- rowSums(assay(gut, "counts"))
gene_sums
head(sort(gene_sums, decreasing = TRUE))

#Create a vector named genecounts by using rowSums() on the counts matrix returned by assay(gut)
#Question 3: Explore the genecounts distribution (1 pt)
#Create genecounts vector by summing expression of each gene across all cells
genecounts <- rowSums(assay(gut, "counts"))
# Summary statistics for genecounts
summary(genecounts)

# Plot a histogram to visualize the distribution of genecounts
hist(genecounts, breaks = 50, main = "Distribution of Gene Counts",
     xlab = "Total Counts per Gene", ylab = "Frequency")




#What is the mean and median genecount according to summary()? What might you conclude from these numbers? mean = 3158; median= 254. These numbers tell me that there is a wide range among gene counts and that there are outliars making the mean so much higher than the median. 
# Summary statistics for genecounts
summary_stats <- summary(genecounts)
mean_genecount <- mean(genecounts)
median_genecount <- median(genecounts)

# Display results
summary_stats
mean_genecount
median_genecount

#What are the three genes with the highest expression after using sort()? What do they share in common?
#ncRNA:lncRNA:Hsromega; pre-rRNA:CR45845; these are all regulatory RNAs, 2 of them are long non-coding RNAs and pre-RNA is involved in housekeeping. Their regulatory role may be why they are so highly expressed. 
top_genes <- head(sort(genecounts, decreasing = TRUE), 3); lncRNA:roX1 
top_genes

#Explore cell-level statistics 
#Question 4a: Explore the total expression in each cell across all genes 
#Create a vector named cellcounts using colSums()
cellcounts <- colSums(assay(gut, "counts"))
# Create a histogram of cellcounts
hist(cellcounts, breaks = 50, main = "Distribution of Total Counts per Cell",
     xlab = "Total Counts per Cell", ylab = "Frequency")
#How would you interpret the cells with much higher total counts (>10,000)? These cells are likely very active as they have more RNA production eluding to more active transcription and likely more protein production. 

#Question 4b: Explore the number of genes detected in each cell
#Create a vector named celldetected using colSums() but this time on assay(gut)>0
celldetected <- colSums(assay(gut, "counts") > 0)
#Create a histogram of celldetected using hist()
# Plot a histogram of celldetected
hist(celldetected, breaks = 50, main = "Distribution of Genes Detected per Cell",
     xlab = "Number of Genes Detected per Cell", ylab = "Frequency")

#What is the mean number of genes detected per cell?
# Calculate the mean number of genes detected per cell = 1059.392
mean_genes_detected <- mean(celldetected)
mean_genes_detected
#What fraction of the total number of genes does this represent? This is the mean of genes divided by the total genes
# Total number of genes
total_genes <- nrow(gut)
# Fraction of total genes detected per cell = 0.07901785
fraction_genes_detected <- mean_genes_detected / total_genes
fraction_genes_detected

#Explore mitochondrial reads 
#sum the expression of all mitochondrial genes across each cell
# Identify all mitochondrial genes
mito_genes <- grep("^MT-|^mt-", rownames(gut), value = TRUE)

# make mitochondrial counts- genes and sum their expression across each cell
mito_counts <- colSums(assay(gut, "counts")[mito_genes, ])
mito_counts

#Create a vector named mito of mitochondrial gene names using grep() to search rownames(gut) for the pattern ^mt: and setting value to TRUE
mito <- grep("^mt:", rownames(gut), value = TRUE)
#Create a DataFrame named df using perCellQCMetrics() specifying that subsets=list(Mito=mito)
df <- perCellQCMetrics(gut, subsets = list(Mito = mito))
df <- as.data.frame(df)
summary(df)
#Confirm that the mean sum and detected match your previous calculations by converting df to a data.frame using as.data.frame() and then running summary()
#Add metrics to cell metadata using colData(gut) <- cbind( colData(gut), df )
colData(gut) <- cbind(colData(gut), df)

#Question 5: Visualize percent of reads from mitochondria 
#Use plotColData() to plot the subsets_Mito_percent on the y-axis against the broad_annotation on the x-axis rotating the x-axis labels using theme( axis.text.x=element_text( angle=90 ) ) and submit this plot
plotColData(gut, y = "subsets_Mito_percent", x = "broad_annotation") +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(y = "Mitochondrial Percent", x = "Cell Type")
#Which cell types may have a higher percentage of mitochondrial reads? Why might this be the case? Epithelial cells are the highest and this could be because of how energetically active they are in the gut with secreting, absorption, and other processes that require lots of energy. 

#3. Identify marker genes
#Analyze epithelial cells (3 pt)
#Question 6a: Subset cells annotated as “epithelial cell”

#Create an vector named coi that indicates cells of interest where TRUE and FALSE are determined by colData(gut)$broad_annotation == "epithelial cell"
coi <- colData(gut)$broad_annotation == "epithelial cell"
#Create a new SingleCellExperiment object named epi by subsetting gut with [,coi]
epi <- gut[, coi]
#Plot epi according to X_umap and colour by annotation and submit this plot
plotReducedDim(epi, "X_umap", colour_by = "annotation") +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "UMAP of Epithelial Cells", colour = "Cell Annotation")

#Identify marker genes in the anterior midgut

#Create a list named marker.info that contains the pairwise comparisons between all annotation categories using scoreMarkers( epi, colData(epi)$annotation )
marker.info <- scoreMarkers(epi, colData(epi)$annotation)
#Identify the top marker genes in the anterior midgut according to mean.AUC using the following code
# Select markers for "enterocyte of anterior adult midgut epithelium"
chosen <- marker.info[["enterocyte of anterior adult midgut epithelium"]]

# Order genes by mean AUC in descending order
ordered <- chosen[order(chosen$mean.AUC, decreasing = TRUE),]

# Display the top marker genes
head(ordered[, 1:4])

#Question 6b: Evaluate top marker genes 

#What are the six top marker genes in the anterior midgut?- Mal-A6 Predicted to be involved in carbohydrate metabolic process; Men-b glucose homeostasis; vnd transcription factor ; betaTry digestive enzyme ; Mal-A1 arbohydrate metabolic process, Nhe2 increases intracellular pH
chosen <- marker.info[["enterocyte of anterior adult midgut epithelium"]]
#Order genes by mean
ordered <- chosen[order(chosen$mean.AUC, decreasing = TRUE),]
# Show top 6 marker genes
top_marker_genes <- head(ordered, 6)
top_marker_genes[, 1:4] 
#Based on their functions at flybase.org, what macromolecule does this region of the gut appear to specialize in metabolizing? Carbohydrates. 
#Plot the expression of the top marker gene across cell types using plotExpression() and specifying the gene name as the feature and annotation as the x-axis and submit this plot
top_gene <- rownames(top_marker_genes)[1]
plotExpression(epi, features = top_gene, x = "annotation") +
  labs(title = paste("Expression of", top_gene, "Across Cell Types"),
       x = "Cell Type Annotation",
       y = "Expression Level") +
  theme(axis.text.x = element_text(angle = 90))

#Analyze somatic precursor cell
#Repeat the analysis for somatic precursor cells
#Subset cells with the broad annotation somatic precursor cell
coi <- colData(gut)$broad_annotation == "somatic precursor cell"
somatic_precursors <- gut[, coi]
#Identify marker genes for intestinal stem cell
#Question 7: Evaluate top marker genes 
marker.info <- scoreMarkers(somatic_precursors, colData(somatic_precursors)$annotation)
#markers for "intestinal stem cell"
chosen <- marker.info[["intestinal stem cell"]]
ordered <- chosen[order(chosen$mean.AUC, decreasing = TRUE),]
#Create a vector goi that contains the names of the top six genes of interest by rownames(ordered)[1:6]
goi <- rownames(ordered)[1:6]
goi

#Plot the expression of the top six marker genes across cell types using plotExpression() and specifying the goi vector as the features and submit this plot
plotExpression(somatic_precursors, features = goi, x = "annotation") +
  labs(title = "Expression of Top Marker Genes in Somatic Precursors",
       x = "Cell Type Annotation",
       y = "Expression Level") +
  theme(axis.text.x = element_text(angle = 90))

#Which two cell types have more similar expression based on these markers? Enteroblast and intenstinal stemcell
#Which marker looks most specific for intestinal stem cells? DI looks the most specific. 
  







