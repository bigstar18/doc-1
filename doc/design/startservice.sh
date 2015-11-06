#!/bin/sh

files=`ls`

for f in $files ; do
	mkdir -p $f/logs/
done
mkdir -p ~/HQ/HQService/logs/
mkdir -p ~/HQ/HQTrans/logs/


i=0
for name in 'mq_gnnt' 'au_common_gnnt' 'au_mgr_gnnt' 'au_broker_gnnt' 'au_warehouse_gnnt' 'au_finance_gnnt' 'au_bill_gnnt' 'au_espot_gnnt' 'au_bank_gnnt' 'au_integrated_gnnt' 'core_common_gnnt' 'core_bill_gnnt' 'core_espot_gnnt' 'core_timebargain_gnnt' 'core_conditionPlugin_gnnt' 'core_hqs_gnnt' 'core_hqt_gnnt' 'core_vendue_gnnt' 'core_mgrgetfrontusers_gnnt'
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
