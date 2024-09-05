#!/usr/bin/env python3
#open File
#skip 2 lines 
#split column header by tabs and skip first 2 entries \t = tabs
#create way to hold gene names 
#create way to hold expression values
#for each line
 #   split line 
  #  save field 0 into gene ids
   # save gield 1 into gene names
    #save 2+ into expression valiues



import sys

import numpy 

fs = open(sys.argv[1], mode='r')
fs.readline()
fs.readline()
line = fs.readline()
fields = line.strip("\n").split("\t")
tissues = fields[2:]
gene_names = []
gene_IDs = []
gene_expression = []

for line in fs:
    fields = line.strip("\n").split("\t") 
    gene_IDs.append(fields[0])
    gene_names.append(fields[1])

    gene_expression.append(fields[2:])
fs.close()

tissues = numpy.array(tissues)
gene_IDs = numpy.array(gene_IDs)
gene_names = numpy.array(gene_names)
expression = numpy.array(gene_expression, dtype=float)


expression_pseudo1 = expression +1 
expression_log_transform = numpy.log2(expression_pseudo1)
expression_log_transform_mean = numpy.mean(expression_log_transform)
#print(expression_log_transform_mean)
# print(whole_data_set_mean_log2)
# print(whole_data_set_median_log2)

expression_pseudo1 = expression +1 
expression_log_transform = numpy.log2(expression_pseudo1)
expression_log_transform_median = numpy.median(expression_log_transform)
# print(expression_log_transform_median)




#expression_copy = numpy.copy(expression_log_transform)
sorted_expression = numpy.sort(expression_log_transform, axis=1)

highest_expression = sorted_expression[:,-1]
second_highest_expression = sorted_expression[:,-2]
diff_array= highest_expression - second_highest_expression 
# print(diff_array)

print(numpy.sum(diff_array >= 10))




# print("Values > 10", diff_array(diff_array > 10))
# print(numpy.sum(diff_array >=10))




# print(gene_IDs)
# print(gene_names)
# print(expression)
    #Day 3 
    ## Q2: You must tell numpy what kind of data it is because it needs to know it is numbers, not just a string so that numpy can run statistics on it. 
    ##Q3: skip 
    ##Q4: calculate the mean expression valeus for the first 10 genes using the mean function 
    ##[3.08153704e-03 3.76213244e+00 0.00000000e+00 5.00325926e-03
 ##0.00000000e+00 2.02259981e-02 3.88654981e-02 4.82672185e-02
 ##2.59725509e-02 6.00239091e-02]

##Q5: mean and median of whole gene expression
##16.557814350910945
##0.0271075
##The median indicates there are lots of low values for gene expression and a large outlier that is high since the mean is higher.
# mean_expression = numpy.mean(expression[:10], axis=1)
# print(mean_expression)

#Q6
##log2 mean: 1.1150342022364093
##log2 median: 0.03858718613570538
##The log values are closer to one another.  
# expression_pseudo1 = expression +1 
# expression_log_transform = numpy.log2(expression_pseudo1)
# expression_log_transform_mean = numpy.mean(expression_log_transform)
# print(expression_log_transform_mean)
# # print(whole_data_set_mean_log2)
# # print(whole_data_set_median_log2)

# expression_pseudo1 = expression +1 
# expression_log_transform = numpy.log2(expression_pseudo1)
# expression_log_transform_median = numpy.median(expression_log_transform)
# print(expression_log_transform_median)


# whole_data_set_mean = numpy.mean(expression)
# whole_data_set_median = numpy.median(expression)
# print(whole_data_set_mean)
# print(whole_data_set_median)





#Q7 Create a copy of the expression array using numpy.copy
#The below array contains the sorted expression values
# 1.1150342022364093
# [[ 0.          0.          0.         ...  0.          0.
#    0.22206634]
#  [ 0.94482997  1.27302048  1.28604722 ...  3.01492297  3.01747478
#    3.03386521]
#  [ 0.          0.          0.         ...  0.          0.
#    0.        ]
#  ...
#  [11.17148332 12.55955634 13.12922505 ... 15.44651472 15.48282056
#   15.51653415]
#  [ 0.          0.          0.         ...  2.5977433   2.71840985
#    3.19887442]
#  [ 0.          0.52925825  0.65598007 ...  3.01289222  3.06364444
#    3.60455768]]

#Difference: [0.22206634 0.01639043 0.         ... 0.03371359 0.48046457 0.54091323]

#Q8 
#there are 33 genes that have a difference > 10. 