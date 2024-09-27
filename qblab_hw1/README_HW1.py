
##Exercise 1
##Step 1.1: Calculate the number of reads needed = 30,000
#num_reads = (coverage * genome_size) // read_length
 
##Step 1.2: Create an array to hold the coverage for each position in the genome
 
#Step 1.3
#uploaded as ex1_3x_cov.png
 
##Step 1.4
#1. 5.03% has zero coverage. 
#2. This matches the Poisson and normal distrubution expectation exactly.
 
 ##Step 1.5
#1. Simulate the reads
#2. Uploaded as ex1_10x_cov.png
#3. 1. 0.01% has zero coverage.
#   2. Normal and Poisson distribution expectations overall match the graph. In a slight difference of expectations, Poisson distribution expects slightly more coverage at lower frequencies than normal distribution expectations. At higher coverage, Poisson expects slightly lower frequency than normal distribution expects. 

##Step 1.6
#1. Simulate the reads
#2. Uploaded as ex1_30x_cov.png
#3. 1. 0.00% has zero coverage.
#   2. Normal and POission distribution expectations are much higher than the actual histogram data. 

##Exercise 2
#Step 2.5
#ATTTTCTCACATTTA

#Step 2.6 What would it take to accurately reconstruct the sequence of the genome? 
# We would need enough reads to cover the entire genome so there would be no gaps anywhere and each kmer would overlap with another. We would need to find a way to deal with any confusing regions of the genome such as sections with many repeats. One tactic would be to use longer kmers as these would offer more information and specificity to the genome but also in how they overlap with other kmers. Also, since they would have a higher probability of being unique from the increased length, they would be less likely to result in multiple paths, which we would be able to see in the De Bruijn graph. We would also need to have enough reads so help confirm the specificity of each kmer. This way if one did not align correctly there would be others to bridge the gaps. In summary, kmer length and read depth are key to reconstructing the genome. 
 