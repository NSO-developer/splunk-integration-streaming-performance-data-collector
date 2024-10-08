
x=0
while [ $x -le $1 ]
do
  lux --var=X=$x test.lux
  x=$(( $x + $2 ))
done

echo "All Done"



