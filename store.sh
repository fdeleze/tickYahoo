#!/bin/bash

cd $HOME/trading
format=`date '+%Y%m%d'`
sys=`uname -s`

if [ $sys == 'Linux' ]; then
	$HOME/q/l32/q store.q
else if [ $sys == 'Darwin' ]; then
	$HOME/q/m32/q yahoo/store.q
     fi
fi
mv tick.bin tick$format".bin"

mpack -s "tick data "$format tick$format".bin" frederic.deleze@gmail.com,zhamilya.assilbekova@gmail.com
