#!/usr/bin/env python
import numpy as np
import pandas as pd
import imageio
from skimage.transform import resize
import matplotlib.pyplot as plt
import seaborn as sns

# Constants
GENES = ["APEX1", "PIM2", "POLR2B", "SRSF1"]
FIELDS = ["field0", "field1"]
CHANNELS = ["DAPI", "nascentRNA", "PCNA"]
MIN_PIXELS = 100
MAX_PIXELS = 1_000_000

# Helper Functions
def load_images(genes, fields, channels):
    """Load images into a list of arrays with shape (H, W, C)."""
    image_arrays = []
    for gene in genes:
        for field in fields:
            max_height, max_width = 0, 0
            channel_images = []

            # Determine the maximum dimensions for this stack
            for channel in channels:
                filename = f"{gene}_{field}_{channel}.tif"
                img = imageio.v3.imread(filename).astype(np.uint16)
                max_height, max_width = max(max_height, img.shape[0]), max(max_width, img.shape[1])
                channel_images.append(img)

            # Create img_stack with the maximum dimensions
            img_stack = np.zeros((max_height, max_width, len(channels)), dtype=np.uint16)

            # Resize images to match the maximum dimensions
            for i, img in enumerate(channel_images):
                if img.shape[0] != max_height or img.shape[1] != max_width:
                    img = resize(img, (max_height, max_width), preserve_range=True, anti_aliasing=True).astype(np.uint16)
                img_stack[:, :, i] = img

            image_arrays.append((gene, field, img_stack))
    return image_arrays

def find_labels(mask):
    """Find connected components in the binary mask using instructor-provided method."""
    l = 0
    labels = np.zeros(mask.shape, np.int32)
    equivalence = [0]
    if mask[0, 0]:
        l += 1
        equivalence.append(l)
        labels[0, 0] = l
    for y in range(1, mask.shape[1]):
        if mask[0, y]:
            if mask[0, y - 1]:
                labels[0, y] = equivalence[labels[0, y - 1]]
            else:
                l += 1
                equivalence.append(l)
                labels[0, y] = l
    for x in range(1, mask.shape[0]):
        if mask[x, 0]:
            if mask[x - 1, 0]:
                labels[x, 0] = equivalence[labels[x - 1, 0]]
            elif mask[x - 1, 1]:
                labels[x, 0] = equivalence[labels[x - 1, 1]]
            else:
                l += 1
                equivalence.append(l)
                labels[x, 0] = l
        for y in range(1, mask.shape[1] - 1):
            if mask[x, y]:
                if mask[x - 1, y]:
                    labels[x, y] = equivalence[labels[x - 1, y]]
                elif mask[x - 1, y + 1]:
                    if mask[x - 1, y - 1]:
                        labels[x, y] = min(equivalence[labels[x - 1, y - 1]], equivalence[labels[x - 1, y + 1]])
                        equivalence[labels[x - 1, y - 1]] = labels[x, y]
                        equivalence[labels[x - 1, y + 1]] = labels[x, y]
                    elif mask[x, y - 1]:
                        labels[x, y] = min(equivalence[labels[x, y - 1]], equivalence[labels[x - 1, y + 1]])
                        equivalence[labels[x, y - 1]] = labels[x, y]
                        equivalence[labels[x - 1, y + 1]] = labels[x, y]
                    else:
                        labels[x, y] = equivalence[labels[x - 1, y + 1]]
                elif mask[x - 1, y - 1]:
                    labels[x, y] = equivalence[labels[x - 1, y - 1]]
                elif mask[x, y - 1]:
                    labels[x, y] = equivalence[labels[x, y - 1]]
                else:
                    l += 1
                    equivalence.append(l)
                    labels[x, y] = l
        if mask[x, -1]:
            if mask[x - 1, -1]:
                labels[x, -1] = equivalence[labels[x - 1, -1]]
            elif mask[x - 1, -2]:
                labels[x, -1] = equivalence[labels[x - 1, -2]]
            elif mask[x, -2]:
                labels[x, -1] = equivalence[labels[x, -2]]
            else:
                l += 1
                equivalence.append(l)
                labels[x, -1] = l
    equivalence = np.array(equivalence)
    for i in range(1, len(equivalence))[::-1]:
        labels[np.where(labels == i)] = equivalence[i]
    ulabels = np.unique(labels)
    for i, j in enumerate(ulabels):
        labels[np.where(labels == j)] = i
    return labels

def create_binary_mask(dapi_channel):
    """Create a binary mask using the mean as the threshold."""
    if np.any(dapi_channel):  # Ensure the channel contains valid data
        return dapi_channel > np.mean(dapi_channel)
    else:
        print("Warning: Empty DAPI channel detected. Skipping mask creation.")
        return np.zeros_like(dapi_channel, dtype=bool)

def filter_labels(labels, min_size, max_size):
    """Filter labels by size and relabel."""
    sizes = np.bincount(labels.ravel())
    valid_labels = np.where((sizes >= min_size) & (sizes <= max_size))[0]
    return np.isin(labels, valid_labels) * labels

def calculate_signals(labels, image, gene, field):
    """Extract mean signals and compute log2 ratio."""
    results = []
    for label_id in range(1, np.max(labels) + 1):
        mask = labels == label_id
        pcna_signal = np.mean(image[mask, 1])
        nrna_signal = np.mean(image[mask, 2])
        log2_ratio = np.log2(nrna_signal / pcna_signal) if pcna_signal > 0 else np.nan
        results.append({
            "gene": gene,
            "field": field,
            "nucleiNumber": label_id,
            "nascentRNA": nrna_signal,
            "PCNA": pcna_signal,
            "log2_ratio": log2_ratio
        })
    return results

# Plotting Functions
def plot_signals(data):
    """Generate violin plots for nascentRNA, PCNA, and log2 ratios."""
    df = pd.DataFrame(data)

    # Plot nascentRNA
    plt.figure(figsize=(10, 6))
    sns.violinplot(x='gene', y='nascentRNA', data=df, scale='width')
    plt.title('Nascent RNA Signal by Gene')
    plt.xlabel('Gene')
    plt.ylabel('Nascent RNA Signal')
    plt.savefig('nascentRNA_violin_plot.png')
    plt.close()

    # Plot PCNA
    plt.figure(figsize=(10, 6))
    sns.violinplot(x='gene', y='PCNA', data=df, scale='width')
    plt.title('PCNA Signal by Gene')
    plt.xlabel('Gene')
    plt.ylabel('PCNA Signal')
    plt.savefig('PCNA_violin_plot.png')
    plt.close()

    # Plot log2_ratio
    plt.figure(figsize=(10, 6))
    sns.violinplot(x='gene', y='log2_ratio', data=df, scale='width')
    plt.title('Log2 Ratio of Nascent RNA to PCNA by Gene')
    plt.xlabel('Gene')
    plt.ylabel('Log2 Ratio')
    plt.savefig('log2_ratio_violin_plot.png')
    plt.close()

# Main Processing Pipeline
def process_images(images):
    """Process images to create masks, filter nuclei, and extract data."""
    data = []
    for gene, field, img in images:
        # Create binary mask and label
        binary_mask = create_binary_mask(img[:, :, 0])
        labeled_img = find_labels(binary_mask)

        # Filter labels by size
        filtered_labels = filter_labels(labeled_img, MIN_PIXELS, MAX_PIXELS)

        # Further filter by mean ± std
        sizes = np.bincount(filtered_labels.ravel())[1:]
        mean_size = np.mean(sizes)
        std_size = np.std(sizes)
        final_labels = filter_labels(filtered_labels, mean_size - std_size, mean_size + std_size)

        # Extract data
        data.extend(calculate_signals(final_labels, img, gene, field))
    return data

# Load, Process, and Save Results
if __name__ == "__main__":
    try:
        images = load_images(GENES, FIELDS, CHANNELS)
        nuclei_data = process_images(images)
        pd.DataFrame(nuclei_data).to_csv("Nuclei.csv", index=False)
        plot_signals(nuclei_data)
        print("Processing complete. Results and violin plots saved.")
    except Exception as e:
        print(f"An error occurred: {e}")








