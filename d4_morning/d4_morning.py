#!/usr/bin/env python3

#how to make code executable: in terminal run chmod +x name of script 
#conda environment for being able to use python in terminal - to get out conda deactivate



#Import packages 
import sys 
import numpy

#1: get first file from user input (should be gene-tissue data: gene_tissue)
filename = sys.argv[1]
#open file
fs = open(filename, mode='r')

#create dict to hold samples for gene-tissue pairs
relevant_samples = {}
#print(relevant_samples) - this shows empty dict 
#step through file 
for line in fs:
    #split line in file on tabs
    fields = line.rstrip("\n").split("\t")
    #create key form gene and tissue names
    key = (fields[0], fields[2])
    #initalize dictionary element with key 
    #Value is list to hold samples
    relevant_samples[key] = []
    #print(relevant_samples) - shows the dictionary with tissues and genes 
#close the file when done
fs.close()


#get metafile name GTX sample attributesDS.txt showing each sample ID that corresponds to suject and tissue 
filename = sys.argv[2]
#open file
fs = open(filename, mode='r')
#skip line
fs.readline()
#create dict to hold samples for tissue name
tissue_samples = {}
#step through file 
for line in fs:
    #split line into fields
    fields = line.rstrip("\n").split("\t")
     #create key form gene and tissue
    key = fields[6]
    Value = fields[0]
         #initalize dict from key with list to hold samples 
    tissue_samples.setdefault(key, [])
    tissue_samples[key].append(Value)
fs.close()
#print(tissue_samples)

#get metafile gtc name RNAseQCv1.1.9_gene_tmp_gct
filename = sys.argv[3]
#open file
fs = open(filename, mode='r')
#skip line 2 times
fs.readline()
fs.readline()
#Get sample IDs 

header = fs.readline().rstrip("\n").split("\t")
header = header[2:]
#print(header[0:10]) this checks that first 2 lines were skipped 

#initlaize dictionary to hold indicies of samples associated with tissues 
tissue_columns = {}
#print(tissue_columns) just show dict 
for tissue, samples in tissue_samples.items():

     tissue_columns.setdefault(tissue, [])
     for sample in samples:
         if sample in header:
             position = header.index(sample)
             tissue_columns[tissue].append(position)
#print(tissue_columns)
#get each tissue and how many samples for each one
for key in tissue_columns.keys():
    print(key,len(tissue_columns[key]))

#results from above: muscle - skeletal has the most and cells - leukemia cell line has the least. 
# Whole Blood 755
# Brain - Frontal Cortex (BA9) 209
# Adipose - Subcutaneous 663
# Muscle - Skeletal 803
# Artery - Tibial 663
# Artery - Coronary 240
# Heart - Atrial Appendage 429
# Adipose - Visceral (Omentum) 541
# Ovary 180
# Uterus 142
# Vagina 156
# Breast - Mammary Tissue 459
# Skin - Not Sun Exposed (Suprapubic) 604
# Minor Salivary Gland 162
# Brain - Cortex 255
# Adrenal Gland 258
# Thyroid 653
# Lung 578
# Spleen 241
# Pancreas 328
# Esophagus - Muscularis 515
# Esophagus - Mucosa 555
# Esophagus - Gastroesophageal Junction 375
# Stomach 359
# Colon - Sigmoid 373
# Small Intestine - Terminal Ileum 187
# Colon - Transverse 406
# Prostate 245
# Testis 361
# Skin - Sun Exposed (Lower leg) 701
# Nerve - Tibial 619
# Heart - Left Ventricle 432
# Pituitary 283
# Brain - Cerebellum 241
# Cells - Cultured fibroblasts 504
# Artery - Aorta 432
# Cells - EBV-transformed lymphocytes 174
# Brain - Cerebellar Hemisphere 215
# Brain - Caudate (basal ganglia) 246
# Brain - Nucleus accumbens (basal ganglia) 246
# Brain - Putamen (basal ganglia) 205
# Brain - Hypothalamus 202
# Brain - Spinal cord (cervical c-1) 159
# Liver 226
# Brain - Hippocampus 197
# Brain - Anterior cingulate cortex (BA24) 176
# Brain - Substantia nigra 139
# Kidney - Cortex 85
# Brain - Amygdala 152
# Cervix - Ectocervix 9
# Fallopian Tube 9
# Cervix - Endocervix 10
# Bladder 21
# Kidney - Medulla 4
# Cells - Leukemia cell line (CML) 0


