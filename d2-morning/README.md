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

##GENCODE 1
## Answer 1

##how many Ig genes are on each chromosome:
-197187 chr1
152252 chr2
125673 chr3
89404 chr4
88813 chr5
98731 chr6
94826 chr7
71707 chr8
78461 chr9
84404 chr10
118912 chr11
107195 chr12
37836 chr13
67151 chr14
67686 chr15
82525 chr16
115794 chr17
34928 chr18
110920 chr19
48597 chr20
23680 chr21
42191 chr22
78013 chrX
7833 chrY
- grep "IG_._gene" genes.gtf | cut -f 1 | uniq -c
-  52 chr2
  91 chr14
  16 chr15
   6 chr16
   1 chr21
  48 chr22

  ##GENCODE 2
  ## Answer
  -grep "gene_type.*pseudogene.*tag" gene.gtf | less -S
  -pseudogenes are not an effective way to identitify lines because the overlapping_pseudogenes would also be incorporated.

  ##GENCODE 3 
  ## Answer
  cut -f1,4,5,14 gene-tabs.gtf > genes.bed