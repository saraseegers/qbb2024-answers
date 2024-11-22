#!/usr/bin/env python
from collections import defaultdict
import numpy as np
import imageio
import os
import scipy
import matplotlib.pyplot as plt

# Define the folder path
folder_path = "/Users/cmdb/qbb2024-answers/qblab_hw10/hw10/image_data"

# Filter to include only valid image files
file_list = [f for f in os.listdir(folder_path) if f.lower().endswith(('.tif', '.png', '.jpg'))]
print(f"Filtered file list: {file_list}")

# Group files by gene and field
grouped_files = defaultdict(lambda: {"DAPI": None, "PCNA": None, "nascentRNA": None})

for file in file_list:
    parts = file.split("_")  # Split file names into parts
    gene = parts[0]          # First part is the gene
    field = parts[1]         # Second part is the field
    channel = parts[2].split(".")[0]  # Last part is the channel (e.g., DAPI, PCNA, nascentRNA)
    grouped_files[f"{gene}_{field}"][channel] = os.path.join(folder_path, file)

# Debug: Check grouped files
print(f"Grouped files: {grouped_files}")

# Define the output file
output_file = "/Users/cmdb/qbb2024-answers/qblab_hw10/hw10/results/nucleus_signal_data.txt"
os.makedirs(os.path.dirname(output_file), exist_ok=True)

# Write results to the output file
with open(output_file, "w") as f:
    f.write("Gene,nascentRNA,PCNA,ratio\n")  # Header

    for gene_field, channels in grouped_files.items():
        # Skip if any channel is missing
        if not all([channels["DAPI"], channels["PCNA"], channels["nascentRNA"]]):
            print(f"Skipping {gene_field} due to missing channels.")
            continue

        # Load images for DAPI, PCNA, and nascentRNA
        dapi_img = imageio.v3.imread(channels["DAPI"]).astype(np.float32)
        pcna_img = imageio.v3.imread(channels["PCNA"]).astype(np.float32)
        rna_img = imageio.v3.imread(channels["nascentRNA"]).astype(np.float32)

        # Normalize PCNA and nascentRNA images
        pcna_img -= np.amin(pcna_img)
        if np.amax(pcna_img) > 0:
            pcna_img /= np.amax(pcna_img)

        rna_img -= np.amin(rna_img)
        if np.amax(rna_img) > 0:
            rna_img /= np.amax(rna_img)

        # Create binary mask for DAPI and find labeled nuclei
        dapi_mask = dapi_img > np.mean(dapi_img)  # Threshold using mean intensity
        labels, _ = scipy.ndimage.label(dapi_mask)

        # Process each nucleus
        for nucleus_id in range(1, np.amax(labels) + 1):  # Skip label 0 (background)
            where = np.where(labels == nucleus_id)
            mean_pcna = np.mean(pcna_img[where])
            mean_rna = np.mean(rna_img[where])
            ratio = np.log2(mean_rna / mean_pcna) if mean_pcna > 0 else "NA"

            # Write results
            gene = gene_field.split("_")[0]
            f.write(f"{gene},{mean_rna},{mean_pcna},{ratio}\n")

print(f"Results written to {output_file}.")
