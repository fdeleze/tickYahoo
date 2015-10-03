#!/bin/bash

if [ $# -ne 1 ]; then
   echo "syntax: allticks.sh listtickers.csv"
   exit -1
fi

#readarray tickers < $1

IFS=$'\n' read -d '' -r -a tickers < $1

for t in $tickers; do
   echo "downloading ticker $t"
   ./tick.sh $t
done

