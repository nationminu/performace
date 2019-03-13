#!/bin/bash 

# jstat monitor per pid every 3 sec
output_timestamp_jstat() {
	echo "TIME\tgc"
	jstat -gc 17138 3000 | while read line
	do 
		echo `date +%T` $line  
	done
} 

output_timestamp_jstat
