#!/bin/bash

echo -e enst_id'\t'ensp_id'\t'uniprot_protein_length'\t'Final_mapping_uniprot_id'\t'Gene_Symbol > map.list
sed -n '2,$p' uniprotkb_Canis_lupus_familiaris_AND_re_2025_02_25.tsv > noHeader.txt

while read line
do
	TID=$(echo "$line" | cut -f8 -d$'\t'| cut -f1 -d';' | cut -f1 -d. )
	PNAME=$(cat tid_pid.list | awk -v var=$TID 'var==$1 {print $2}')
	LENGTH=$(echo "$line" | cut -f7  -d$'\t')
	UNIID=$(echo "$line" | cut -f1  -d$'\t')
	GNAME=$(echo "$line" | cut -f5  -d$'\t')
	
	echo $GNAME | awk -F" " '{for (i=1;i<=NF;i++) {print $i}}' | while read gname
	do
		echo -e $TID'\t'$PNAME'\t'$LENGTH'\t'$UNIID'\t'$gname
	done
done < noHeader.txt   >> map.list
