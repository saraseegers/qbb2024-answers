library(tidyverse)
library(ggthemes)

df <- read_tsv("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt") 
view(df)
#Q1
read_delim(file = "~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")

#Q2
df
glimpse(df)

#Q3
TruSeq <- df %>%
  filter(SMGEBTCHT == "TruSeq.v1")

#Q4
ggplot(data = TruSeq) +
  geom_bar(mapping = aes(x = SMTSD)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 

#Q5 a histogram is a good way to visualize this data since it is one variable being looked at.
#The shape is unimodal.
ggplot(data = TruSeq) +
  geom_histogram(bins = 10, mapping = aes(x = SMRIN)) +
  xlab("RNA Integrity Number") +
 
    
#Q6
ggplot(data= TruSeq, mapping = aes(x = SMTSD, y = SMRIN)) +
  geom_violin() +
  xlab("Tissue Type") +
  ylab("RNA Integrity Number") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 
#No major differences across tissue types as seen in the violin plot which shows the range within each tissue type, cultured fibroblasts and the leukemia cell line had the highest RIN likely because they are more actively proliferating. 

#Q7
ggplot(data= TruSeq, mapping = aes(x = SMTSD, y = SMGNSDTC)) +
  geom_violin() +
  xlab("Tissue Type") +
  ylab("RNA Integrity Number") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 

#Violin plot is once again a nice representation of the # of genes from each sample, the CNL cells have the lowest number, this could be due to the being cancerous and the genes have been hijacked to preform just survivial and proliferative properties more than other types. Tes

  



 
  
  
       



