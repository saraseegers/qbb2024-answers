# day-2 lunch anwsers

## Answer 1
(qb24) cmdb@QuantBio-11 d2-morning % cut -f 7 hg38-gene-metadata-feature.tsv | sort | uniq -c 
#19618 protein_coding
#The biotype I would like to learn about is snoRNA, I am not familar with this and its role in cardiac signaling. I wonder how it is regulated in patients with cardiovasular morbibities, especiialy in the role of treatments that are known to have cardiovasular toxicity. 


## Answer 2
cut -f 1 hg38-gene-metadata-go.tsv | uniq -c | sort

#273 ENSG00000168036

grep "ENSG00000168036" hg38-gene-metadata-go.tsv | sort -k 3 > name_1006.txt
#Based on these GO terms I think this is a highly conserved gene as it is involved with differentiation and proliferation of may different tissues. 

#GENCODE 1
#grep -w gene gencode.v46.basic.annotation.gtf > gene.gtf
## Answer 1

##how many Ig genes are on each chromosome:

f 1 gencode.v46.basic.annotation.gtf | uniq -c | sort

 143 chrM
107196 chr12
110921 chr19
115795 chr17
118913 chr11
125674 chr3
152253 chr2
197188 chr1
23681 chr21
34929 chr18
37837 chr13
42192 chr22
48598 chr20
67152 chr14
67687 chr15
71708 chr8
78014 chrX
7834 chrY
78462 chr9
82526 chr16
84405 chr10
88814 chr5
89405 chr4
94827 chr7
98732 chr6


#grep "IG_._gene" genes.gtf | cut -f 1 | uniq -c
-  52 chr2
  91 chr14
  16 chr15
   6 chr16
   1 chr21
  48 chr22

 #GENCODE 2
  ## Answer
grep "gene_type.*pseudogene.*tag" gene.gtf | less -S
  -pseudogenes are not an effective way to identitify lines because the overlapping_pseudogenes would also be incorporated.

 #GENCODE 3 
  ## Answer
  cut -f1,4,5,14 gene-tabs.gtf > genes.bed