#!/bin/bash
#
# run_test_x_times.sh
#
#   ./run_test_x_times.sh              (runs the test 1 time)
#   ./run_test_x_times.sh 20           (runs the test 20 times)
#

TEST_EXECUTABLE=./test_performance_deploy.sh
TEST_TIMESTAMP=$(date +%Y%m%d%H%M%S)
TIMES=1

if [ $# -eq 1 ]
then
  TIMES=$1
fi

for (( i=1; i<=${TIMES}; i++ ))
do
  echo "##### run: ${i} #####"
  ${TEST_EXECUTABLE}
  echo "#####################"
done
