#!/usr/bin/env python3

import sys

my_file = open( sys.argv[1] )


#this line is getting file
#sys provides communication bc command line and script
#argv is a list of evyerthing that was typed in at the terminal  

for my_line in my_file:
    if "##" in my_line:
        continue
    fields = my_line.split("\t") 

    s = fields[8]. split(";")[2].lstrip('gene_name "').rstrip('"')

    print( fields [0], fields [3], fields [4], s)

    

my_file.close()

