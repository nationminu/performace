#!/bin/sh

node=`hostname`
rm -f /tmp/cpu_all.tmp /tmp/zzzz.tmp /tmp/${node}_nmon_cpu.csv
for nmon_file in `ls /root/nmon/*nmon`
do
  datestamp=`echo ${nmon_file} | cut -f2 -d"_"`
  grep CPU_ALL, $nmon_file > /tmp/cpu_all.tmp
  grep ZZZZ $nmon_file > /tmp/zzzz.tmp
  grep -v "CPU Total " /tmp/cpu_all.tmp | sed "s/,/ /g" | \
  while read NAME TS USER SYS WAIT IDLE rest
  do
    timestamp=`grep ${TS} /tmp/zzzz.tmp | awk -F, '{print $4" "$3}'`
    TOTAL=`echo "scale=1;${USER}+${SYS}" | bc`
    echo $timestamp,$USER,$SYS,$WAIT,$IDLE,$TOTAL >> \
    /tmp/${node}_nmon_cpu.csv
  done
  rm -f /tmp/cpu_all.tmp /tmp/zzzz.tmp
done
