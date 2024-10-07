#!/usr/bin/env python3

import matplotlib.pyplot as plt

#Open the VCF file 
vcf_file = 'biallelic.vcf'

#Initialize lists to store allele frequencies and read depths
allele_frequencies = []
read_depths = []

#Open the VCF file
with open(vcf_file, 'r') as vcf:
    for line in vcf:
        # Skip header lines
        if line.startswith('#'):
            continue
        
        #Split the line into columns 
        fields = line.rstrip('\n').split('\t')
        
        #Parse INFO column (fields[7]) for af and read depth
        info_field = fields[7].split(';')
        info_dict = {k: v for k, v in (item.split('=') for item in info_field if '=' in item)}

        #get allele frequencies  
        if 'AF' in info_dict:
            allele_frequencies.append(float(info_dict['AF']))
        
        #get dp
        if 'DP' in info_dict:
            dp_values = info_dict['DP'].split(',')
            # Convert the DP values to integers and sum them if there are multiple values
            dp_sum = sum([int(dp) for dp in dp_values])
            read_depths.append(dp_sum)


# Plot Allele Frequency Spectrum
plt.figure(figsize=(10, 6))  # Adjust the figure size
plt.hist(allele_frequencies, bins=20, edgecolor='black')
plt.title('Allele Frequency Spectrum')
plt.xlabel('Allele Frequency')
plt.ylabel('Count')
plt.savefig('allele_frequency_spectrum.png')
plt.close()

# Plot Read Depth Distribution
plt.figure(figsize=(10, 6))  # Adjust the figure size
plt.hist(read_depths, bins=20, edgecolor='black')
plt.title('Read Depth Distribution')
plt.xlabel('Read Depth')
plt.ylabel('Count')
plt.savefig('read_depth_distribution.png')
plt.close()
