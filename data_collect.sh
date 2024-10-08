#$1 can be java, python or ncs.smp
PID=$(pgrep $1)
#echo "Monitoring PID: "$PID
Datetime=$(date +%Y%m%d%H%M%S)

start=$(date +%s)
echo -n $start" " >> data/start_time.dat

while true; do
#Data collection
RawData=$(ps -p $PID -o rss=)
echo -n $RawData" " >> data/mem.dat

sleep $2
done 