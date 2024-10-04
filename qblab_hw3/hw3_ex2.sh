#!/bin/bash

# #2.1

# REF="/Users/cmdb/qbb2024-answers/qblab_hw3/sacCer3.fa"

# # Number of threads
# THREADS=4

# # Loop through each of the samples (base names without .fastq)
# for SAMPLE in A01_09 A01_11 A01_23 A01_24 A01_27 A01_31 A01_35 A01_39 A01_62 A01_63
# do
#   # Single-end read file 
#   READ="/Users/cmdb/qbb2024-answers/qblab_hw3/${SAMPLE}.fastq"  # Single FASTQ file for this sample

#   # Output file
#   OUT_SAM="/Users/cmdb/qbb2024-answers/qblab_hw3/${SAMPLE}.aligned.sam"

#   # Run the alignment using bwa mem for single-end data
#   bwa mem -t $THREADS -R "@RG\tID:${SAMPLE}\tSM:${SAMPLE}" $REF $READ > $OUT_SAM

# done


#2.2

# Reference genome file
REF="/Users/cmdb/qbb2024-answers/qblab_hw3/sacCer3.fa"

# Number of threads
THREADS=4

# Loop through each of the samples (base names without .fastq)
for SAMPLE in A01_09 A01_11 A01_23 A01_24 A01_27 A01_31 A01_35 A01_39 A01_62 A01_63
do
  # Single-end read file 
  READ="/Users/cmdb/qbb2024-answers/qblab_hw3/${SAMPLE}.fastq"  # Single FASTQ file for this sample

  # Output SAM file 
  OUT_SAM="/Users/cmdb/qbb2024-answers/qblab_hw3/${SAMPLE}.aligned.sam"

  # Run the alignment using bwa mem
  bwa mem -t $THREADS -R "@RG\tID:${SAMPLE}\tSM:${SAMPLE}" $REF $READ > $OUT_SAM

  # Define sorted BAM file output
  OUT_BAM="/Users/cmdb/qbb2024-answers/qblab_hw3/${SAMPLE}.sorted.bam"

  # Sort the SAM file and convert it to BAM format
  samtools sort -O bam -o $OUT_BAM $OUT_SAM

  # Index the sorted BAM file
  samtools index $OUT_BAM
done
