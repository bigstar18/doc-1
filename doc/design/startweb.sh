#!/bin/sh

i=0
for name in 'tc_broker_gnnt' 'tc_warehouse_gnnt' 'tc_tradeweb_gnnt' 'tc_mgr_gnnt' 'tc_front_gnnt' 
do 
	echo "****************************************************"
	echo $name
	echo "****************************************************"
	$name restart &
	i=`expr $i + 1`
	i=`expr $i \* 3`
	#echo $i
	sleep 20
#}&
done
#wait
