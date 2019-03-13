#!/bin/bash 

# netstat monitor per port every 3 sec
output_timestamp_netstat() {
	echo "TIME\t8009\t8109"
	while true
	do
		netstat_8009=`netstat -an|grep ":8009 " |grep ESTABLISHED |grep -v grep |wc -l`
		netstat_8109=`netstat -an|grep ":8109 " |grep ESTABLISHED |grep -v grep |wc -l`
		echo `date +%T`"\t"$netstat_8009"\t"$netstat_8109 
		sleep 3
	done
} 

output_timestamp_netstat
