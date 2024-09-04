# day-2 lunch anwsers

## Answer 1
- (qb24) cmdb@QuantBio-11 d2-morning % cut -f 7 hg38-gene-metadata-feature.tsv | sort | uniq -c 
- 19618 protein_coding
-The biotype I would like to learn about is snoRNA, I am not familar with this and its role in cardiac signaling. I wonder how it is regulated in patients with cardiovasular morbibities, especiialy in the role of treatments that are known to have cardiovasular toxicity. 


## Answer 2
- cut -f 1 hg38-gene-metadata-go.tsv | uniq -c | sort
- 273 ENSG00000168036

-grep "ENSG00000168036" hg38-gene-metadata-go.tsv | sort -k 3 > name_1006.txt
-Based on these GO terms I think this is a highly conserved gene as it is involved with differentiation and proliferation of may different tissues. 

