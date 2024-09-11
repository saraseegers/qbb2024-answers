#!/usr/bin/env python3

#imports system
import sys

#this line is getting file
#sys provides communication bc command line and script
#argv is a list of evyerthing that was typed in at the terminal  
my_file = open( sys.argv[1] )


for my_line in my_file:
    if "##" in my_line:
        continue
    fields = my_line.split("\t") 

    s = fields[8]. split(";")[2].lstrip('gene_name "').rstrip('"')

    #join fields with tab character for BED format 
    print( fields [0], fields [3], fields [4], s, sep= '\t')

#close file     
my_file.close()

