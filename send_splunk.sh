#!/usr/bin/env bash

#python --version
#python -m pip install -r requirments.txt
echo $2" "$3" "$4" "$5 >> data/final.dat

python lib/splunk.py  $1 $2 $3 $4 $5 


