
x=0
while [ $x -le $1 ]
do
  lux --var=X=$x test.lux
  TEST_RESULT=$?
  if [ $TEST_RESULT -ne 0 ]; then
    exit $TEST_RESULT
  fi
  x=$(( $x + $2 ))
done

echo "All Done"



