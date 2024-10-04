#a shell file is an executable BASH code storage format. 
#!/usr/bin/env bash

##Exercise 1
##1.1 how long are the sequence reads? 
    #answer: sequence length 76
#unix code  wfastqc A01_09.fastq
#1.2. How many reads are present within the file?
#unix code  wfastqc A01_09.fastq 
    #answer:  2678192/4 = 669548
#1.3 Based on the previous questions, what is the expected average of depth coverage?
    #answer: if you divide the reads by the genome size, which for yeast is about 12.1e6, you get an average of ~4 for depth coverage. 
#1.4 Which sample has the largest and which has the smallest file size?
#unix code= du -h *.fastq
    #answer: smallest= 110M	A01_27.fastq   largest=149M	A01_62.fastq 
#1.5 Open the HTML report. unix code: fastqc A01_09.fastq. 
#What is the median base quality along the read?    
    #answer: ~36-34
#How does this translate to the probability that a given base is an error? 
    #answer: The PHRED average is >30 meaning the reads are very accurate. The median score also being high means that a given base is likely correct. 
#Do you observe much variation in quality with respect to the position in the read?
    #answer: yes, there is much lower quality at the ends of the genome. 

##Exercise 2
#2.1 How many chromosomes are in the yeast genome?
#code: grep "^>" sacCer3.fa |         
#pipe> wc -l
      #anwser:17

##Exercise 2
#2.2 How many total read alignments are recorded in the SAM file for A01_09?
#code:grep -v "^@" A01_09.aligned.sam | wc -l
    #answer:669548
#2.3 How many of the alignments are to loci on chromosome III?
#code: grep -v "^@" A01_09.aligned.sam | awk '$3 == "chrIII"' | wc -l
    #answer: 17815
#2.4
#2.5 How many SNPs do you observe in this window? Are there any SNPs about which you are uncertain? 
    #answer: I see 3 SNPs within this window, chrI:113,132, chrI:113,207, chrI:113,326. I am not certain that chrI:113,326 is a SNP as it only has 2 hits, more data is needed to confirm. 
#2.6 What is the position of the SNP in this window?
    #answer:chrIV:825,834 which does not fall inside of a gene. 

##Exercise 3 
#3.1 Interpret the figure.
    #answer: This figure shows a mostly normal distribition of allele frequency among the 10 variants and 5 samples. This is as expected but based on how this question was asked I think I might be interpreting this incorrectly. 
#3.2 Interpret the figure. 
    #answer: This figure shows a more Poisson distribution. There are no samples with a read depth of 0 which is expected due to the increased depth. 