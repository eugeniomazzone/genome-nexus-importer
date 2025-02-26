#!/bin/bash

cat map_traslation_dic2 | sed -n '2,$p'| while read line
do
	TID=$(echo $line | cut -f1 -d' ')
	PNAME=$(echo $line | cut -f2 -d' ')
	
	TNAME=$(cat map_id_dic1 | awk -v var=$TID 'var==$1 {print $2}')
	echo -e $TNAME'\t'$PNAME
done > tid_pid.list
