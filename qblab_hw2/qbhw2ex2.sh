#!/bin/bash

# Create the output file and add a header
echo -e "MAF\tFeature\tEnrichment" > snp_counts.txt

# Loop through each MAF file (assuming 5 files, from MAF 0.1 to MAF 0.5)
for maf_file in chr1_snps_0.{1..5}.bed; do
  # Calculate total SNP count and size across the whole chromosome
  total_snps=$(bedtools coverage -a genome_chr1.bed -b "$maf_file" | awk '{s+=$4} END {print s}')
  total_bases=$(bedtools coverage -a genome_chr1.bed -b "$maf_file" | awk '{s+=$3-$2} END {print s}')
  
  # Calculate background SNP density (total SNPs per base)
  background=$(echo "scale=10; $total_snps / $total_bases" | bc -l)

  # Loop through each feature (exons, introns, cCRES, other)
  for feature in exons_chr1.bed introns_chr1.bed cCres_merged.bed other_chr1.bed; do
    # Calculate SNPs and bases for the feature
    feature_snps=$(bedtools coverage -a "$feature" -b "$maf_file" | awk '{s+=$4} END {print s}')
    feature_bases=$(bedtools coverage -a "$feature" -b "$maf_file" | awk '{s+=$3-$2} END {print s}')
    
    # Calculate SNP density for the feature
    feature_density=$(echo "scale=10; $feature_snps / $feature_bases" | bc -l)
    
    # Calculate enrichment (feature density / background density)
    enrichment=$(echo "scale=10; $feature_density / $background" | bc -l)
    
    # Extract MAF value from filename
    maf_value=$(echo "$maf_file" | grep -oE '[0-9]+\.[0-9]+')
    
    # Save the result in the output file
    echo -e "$maf_value\t$(basename $feature .bed)\t$enrichment" >> snp_counts.txt
  done
done


