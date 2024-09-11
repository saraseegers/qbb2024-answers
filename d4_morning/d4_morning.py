#!/usr/bin/env python3

#Import packages 
import sys 
import numpy

#1: get first file from user input (should be gene-tissue data: gene_tissue)
filename = sys.argv[1]
#open file
fs = open(filename, mode='r')
#create dict to hold samples for gene-tissue pairs
relevant_samples = {}
#step through file 
for line in fs:
    #split line in file on tabs
    fields = line.rstrip("\n").split("\t")
    #create key form gene and tissue names
    key = (fields[0], fields[2])
    #initalize dictionary element with key 
    #Value is list to hold samples
    relevant_samples[key] = []
#close the file when done
fs.close()

#print(relevant_samples)

#get metafile name 
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

#get metafile gtc name 
filename = sys.argv[3]
#open file
fs = open(filename, mode='r')
#skip line 2 times
fs.readline()
fs.readline()
#Get sample IDs 

header = fs.readline().rstrip("\n").split("\t")
header = header[2:]
#print(header)

#initlaize dictionary to hold indicies of samples associated with tissues 
tissue_columns = []

#Reterive values from keys that we set in our dictionary 
for tissue.samples in tissue_samples.item():
    #set default safely adds things so you don't override anything if not already uniqiue value 
    tissue_columns.setdefault(tissue, [])
    #
    for sample in tissue_columns if in tissue_samples

#print(tissue_columns)

#print out each key and length of value in the dictionary 
# print(key, len(value))

#need 2 more for loops to loop for max and min

#find tissue with max number of samples 
max_value = 0
max_tissue = ""

for tissue, samples in tissue_columns.items():

if len(samples) >= max_value:
    max_value = len(samples)
    max_tissue = tissue 

print(max_tissue, max_value)

#find tissue with min number of samples 
min_value = 0
min_tissue = ""

for tissue, samples in tissue_columns.items():

if len(samples) <= min_value:
    min_value = len(samples)
    min_tissue = tissue 

print(max_tissue, min_value)


#Q6- from monday TA session 
head -n 500 GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct > test_data.gct
f = open("test_data.gct", "r")
for l in f: #for line in my file- getting gene name 
   l = l.strip().split("\t")
  
geneName = l[0] #name of the gene

if geneName in relevant_samples.keys(): #pull out corresponding tissue (keys are the tissues)
    myTissue= relevant_samples[geneName] #print out every column (gene) that this tissue appears 
    print(tissue_columns[myTissue]) # keys of tissue_colums are tissues 


