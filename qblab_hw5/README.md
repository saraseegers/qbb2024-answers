1.1, 1.2, 2, 3.3, 3.6

1.1: Can you think of a reason why this sample does not match the expected GC content distribution and base content at the beginning of sequences?
This is likely due to issues with sequencing close to primers as there is usually more discrepancy at these sites. 


1.2: Overrepresented sequences
You may also notice that there are several overrepresented sequences in these sample reads. Blast provides a handy tool for determining if a sequence matches any sequences in NCBI’s database of sequences from a large set of species. Use the blast web interface to determine if you can identify what the most overrepresented sequence us from

What is the origin of the most overrepresented sequence in this sample? Does it make sense?
For sample_1 and sample_2, almost all of the overrepresented sequences are from drosophila melanagaster and are largely in serine protease 1. One of the first papers that comes up when search about the role of ersine protease 1 in ddrosophila is there role in digestion which aligns with the gut data we are sampling (https://pubmed.ncbi.nlm.nih.gov/12568721/).

2: If you were to reject any samples with the percentage of unique reads less than 45%, how many samples would you keep?
None of them, as all of the samples have a unique read that is less than 45%. 


Can you see the blocks of triplicates clearly? Try adjusting the min slider up. Does this suggest anything about consistency between replicates?
I do not see any blocks to triplicates clearly unless I decrease the MAX. If I slide the min bar I get more red squares indicating less similarity so overall more variance between replicates. 

3.3: Examine the PCA plot. Does everything look okay (We wouldn’t ask if it did)?
LFC_FE and FE seem to potentially have a swapped sample. LFC_FE 3 and FE 1. It looks like this because all of the triplicates are very closely grouped except these 2. Overall, there ar very clear clusters. 

3.6: Do the categories of enrichments make sense? Why?
There are a range of categories that make sense to be enriched in the gut such as endopeptidase activity, enzyme-linked receptor protein signaling, organic substance biosynthesis process, macromolecule metabolic process, and fatty acid metabolic process. 