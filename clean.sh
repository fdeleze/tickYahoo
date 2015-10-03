#!/bin/bash

if [ $# -ne 1 ]; then
  echo "syntax: clean.sh ticker"
  exit -1
fi

stock=$1
cd  $HOME/trading

dformat=`date '+%Y%m%d'`
mkdir -p ./$stock
mkdir -p $stock/$dformat
mv $stock.csv $stock/$dformat/
mv $stock"_header.csv" $stock/$dformat/
mv $stock"_kdb.q" $stock/$dformat/
mv $stock"_raw.csv" $stock/$dformat/

