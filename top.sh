#!/bin/bash

# top per process every 3 sec
output_timestamp_top() {
	echo "TIME\tNAME\tPID\tCPU\tMEM ..."
	while true
	do
		top=`top -c -b -n1 | grep docker |grep -v grep | awk '{print $12"\t"$1"\t"$9"\t"$10}'` 
		echo `date +%T`"\t"$top 
		sleep 3
	done
}

output_timestamp_top
