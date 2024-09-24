#!/bin/bash


#Exercise 1: Obtain the data
#step 1.1: download SNP files and unpack with given code
tar xzf chr1_snps.tar.gz
#step 1.2: download 1 file from UCSC Genome Table Browser- genes             
#step 1.3: download 2 files from UCSC Genome Table Browser- exons and cCREs
#step 1.4: use bedtools to merge elements within each feature file 
    #1. must sort and then merge each file independently and BEDSORT will do by chromosome automatically 
  
    sort: sort -k1,1 -k2,2n cCres.bed > cCres_sorted.bed
    merge: mergeBed -i cCres_sorted.bed

    sort: sort -k1,1 -k2,2n genes.bed > genes_sorted.bed
    merge: mergeBed -i genes_sorted.bed

    sort: sort -k1,1 -k2,2n exons.bed > exons_sorted.bed
    merge: mergeBed -i exons_sorted.bed

#step 1.5: subtract exons from genes to isolate intronic regions
#-a specifies the file with gene regions from the merged genes file and -b for the exons file. 
bedtools subtract -a genes_merged.bed -b exons_merged.bed > introns_merged.bed

#extract introns only from chromosome 1 even thouhgh should all be from chromosome 1 already and save as its own bed file 
grep "^chr1" introns_merged.bed > introns_chr1.bed

#step 1.6: use bedtools to find intervals not covered by other features i.e find regions not covered by introns, exons, or cCRES
 #-a specifies the entire chromosome 1 region and -b specifies to subtract every file after
 bedtools subtract -a genes.bed -b introns_chr1.bed exons.bed cCres.bed > other_chr1.bed