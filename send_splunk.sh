#!/usr/bin/env bash

#python --version
#python -m pip install -r requirments.txt
#sh send_splunk.sh "http://10.5.0.5:4318" $1 $Mem $Time $As


Mem=$(echo $3  | awk '{ print sprintf("%.f", $1); }')
Time=$(echo $4  | awk '{ print sprintf("%.f", $1); }')
As=$(echo $5  | awk '{ print sprintf("%.f", $1); }')

echo $2" "$Mem" "$Time" "$As >> data/final.dat

python lib/splunk.py  $1 $2 $Mem $Time $As 


