#!/bin/bash

#stock="AAPL"
stock=$1

cd $HOME/trading
url="http://chartapi.finance.yahoo.com/instrument/1.0/"$stock"/chartdata;type=quote;range=1d/csv"
echo $url
wget $url
header=`head  -n17 csv`
#echo $header
core=`awk 'NR > 17' csv`
mv csv $stock"_raw.csv"
echo $header | sed 's/ /\n/g' > $stock"_header.csv"
echo "h:hopen \`:176.58.105.200:3307" >> $stock"_kdb.q"
sys=`uname -s`
for c in $core; do
   d=`echo $c | cut -d ',' -f1` 
   #echo `date -r$d`
   r=`echo $c | cut -d ',' -f2-6`
   if [ $sys == 'Linux' ]; then
      line=`date -d@$d '+%Y.%m.%dT%H:%M:%S.000'`","$r
   else if [ $sys == 'Darwin' ]; then
           line=`date -r$d '+%Y.%m.%dT%H:%M:%S.000'`","$r
        fi
   fi
   echo $line | sed 's/,/;/g' >> $stock".csv"
   echo "h \"\`tick upsert(\`$stock," $line ");\"" | sed 's/,/;/g' >> $stock"_kdb.q"
done
echo "hclose h" >> $stock"_kdb.q"
echo "\\\\" >> $stock"_kdb.q"

if [ $sys == 'Linux' ]; then
	$HOME/q/l32/q $stock"_kdb.q"
else if [ $sys == 'Darwin' ]; then
        $HOME/q/m32/q $stock"_kdb.q"
     fi
fi

if [ $sys == 'Linux' ]; then
   ./clean.sh $stock
else 
   ./yahoo/clean.sh $stock
fi

## insert into a kdb+ database 
## table tick
##
## tick:([ticker:`symbol$();timestamp:`datetime$()]close:`float$();high:`float$();low:`float$();open:`float$();volume:`int$())
##
## `tick upsert(`AAPL;2015.09.25T14:58:12.000;64.3380;64.3380;64.3380;64.3380;200)
