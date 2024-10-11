pkill -f data_collect.sh

end=$(date +%s)
echo -n $end" " >> data/end_time.dat

echo $(cat data/start_time.dat)" "$(cat data/end_time.dat) >> data/time_elapse.dat

#Data Processing
#substract
Time=$(awk '{s+=($2-$1)}END{print "",s}' data/time_elapse.dat)
#average
Mem=$(awk '{s+=$1}END{print "",s/NR}' RS=" " data/mem.dat)
As=$(awk '{s+=$1}END{print "",s/NR}' RS=" " data/as.dat)



#Stream to Splunk
sh send_splunk.sh "http://10.5.0.5:4318" $1 $Mem $Time $As




#rm data/*.dat
rm data/start_time.dat
rm data/end_time.dat
rm data/mem.dat
rm data/as.dat
rm data/time_elapse.dat
