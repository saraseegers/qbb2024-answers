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
  ylab("Number of Genes") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 

#Violin plot is once again a nice representation of the # of genes from each sample, the CNL cells have the lowest number, this could be due to the being cancerous and the genes have been hijacked to preform just survival and proliferative properties more than other types. Testis express more genes than other mammalian tissues according to Xia.et al 2021. 

#Q8
ggplot(data= TruSeq, mapping = aes(x = SMTSISCH, y = SMRIN)) +
  geom_point(size = 0.5, alpha = 0.5) +
  xlab("RNA Integrity Number") +
  ylab("Ischemic Time") +
  facet_wrap("SMTSD") +
  geom_smooth(method = "lm")
#  Most tissues do not have major changes in RIN with ischemic time. The cervix and Fallopian tubes and other mucous membranes seem to have the most degradation with increased ischemia. 

#Q9
ggplot(data= TruSeq, mapping = aes(x = SMTSISCH, y = SMRIN,)) +
  geom_point(size = 0.5, alpha = 0.5, aes(color = "SMATSSCR")) +
  xlab("RNA Integrity Number") +
  ylab("Ischemic Time") +
  facet_wrap("SMTSD") +
  geom_smooth(method = "lm")
        

  

  
#Q9


 
  
  
       



