#!/bin/bash

head ensembl_biomart_geneids.txt | cut -f2 | grep -v ID| while read line
do
	cat ensembl_biomart_pfam.txt | grep $line
done
