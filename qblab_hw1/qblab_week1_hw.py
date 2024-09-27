#!/usr/bin/env python3
#import systems 

import sys
import numpy as np 
import random
import scipy

#parameters
genome_length = 1_000_000
read_length = 100
coverage_target = 30

#total reads needed
total_reads = (coverage_target * genome_length) // read_length
#print(f"total reads needed: {total_reads}") #30000 reads needed 

##initalize array to track coverage at each position in genome 
genome_coverage = np.zeros(genome_length, dtype=int)
print(genome_coverage)

## here we are making a look simulating the position of reads
for i in range(total_reads):
   ##generates a random starting posotion for each read bu makes sure it does not extend the genome
  startpos = random.randint(0, genome_length - read_length+1)
  #print(startpos)
   ##calculates the end position of the read
  endpos = startpos + read_length
  coverage_target[startpos:endpos] += 1
#print("coverage simuation complete.")

## get the range of coverages observed
 
maxcoverage = max(genome_coverage)
xs = list(range(0, maxcoverage+1))

## Get the poisson probability mass function (PMF) at each of the coverage levels
poisson_estimates = get_poisson_estimates(xs, poisson_lambda = coverage_target)

## Get normal pdf at each of these (i.e. the density between each adjacent pair of points)
normal_estimates = get_normal_estimates(xs, mean = genome_coverage, stddev = sqrt(genome_coverage))

## now plot the histogram and probability distributions
# Step 1.4: Save the coverage array to a file

with open('30_genome_coverage.txt', 'w') as f:
    for coverage_value in genome_coverage:
        f.write(str(coverage_value) + '\n')
