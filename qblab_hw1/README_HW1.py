import random
 
# Step 1: Set the parameters
genome_size = 1000000  # 1Mbp genome
read_length = 100      # 100bp reads
coverage = 30          # 30x coverage
 
 
##Q1.1: Calculate the number of reads needed = 30,000
num_reads = (coverage * genome_size) // read_length
 
# Step 2: Create an array to hold the coverage for each position in the genome
genome_coverage = [0] * genome_size
 
# Step 3: Simulate the reads
for i in range(num_reads):
    # Pick a random starting position for the read
    start_pos = random.randint(0, genome_size - read_length)
    
    # Increase the coverage for each position in the read
    for j in range(start_pos, start_pos + read_length):
        genome_coverage[j] += 1
 
# Step 4: Save the coverage array to a file
with open('30_genome_coverage.txt', 'w') as f:
    for coverage_value in genome_coverage:
        f.write(str(coverage_value) + '\n')
 
#print("Simulation complete. Coverage data saved to '30x_genome_coverage.txt'.")

#alterd the above script each time for coverage i.e 3X, 10X, and 30X. 


#How much of the genome has 0 coverage with the 30X simulation?

# Calculate the number of positions with 0x coverage
zero_coverage_positions = genome_coverage.count(0)

# Calculate the percentage of genome with 0x coverage
percentage_zero_coverage = (zero_coverage_positions / genome_size) * 100

# Print the result
print(f"Percentage of genome with 0x coverage: {percentage_zero_coverage:.2f}%")
##Q 1.4: 5.03% has zero coveragse and this matches the Poisson and normal distrubution expectation exactly. Overall Poisson expects less coverage than normal distribution as higher coverage ranges.  
##Q 1.5: at 10X coverage now only 0.01% has zero coverage. At lower coverages, normal distribution expects higher coverage than Poission but very slightly. Both match the histogram well. 
##Q 1.6. at 30X coverage 0.00% has zero coverage. The Poisson and normal distributon overlap but are much higher than the histogram. 

#Q2.5
ATTTTCTCACATTTA

#Q2.6
To accurately reconstruct the sequence we would need enough coverage to make sure each 3mer was in the correct spot. This would be accomplished by overlaying all the 3mers to ensure correct alignment. 


