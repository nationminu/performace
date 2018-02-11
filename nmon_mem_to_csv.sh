#!/bin/sh

node=`hostname`
rm -f /tmp/mem.tmp /tmp/zzzz.tmp /tmp/${node}_nmon_mem.csv
echo "DATE,MEMTOTAL,HIGHTOTAL,LOWTOTAL,SWAPTOTAL,MEMFREE,HIGHFREE,LOWFREE,SWAPFREE,MEMSHARED,CACHED,ACTIVE,BIGFREE,BUFFERS,SWAPCACHED,INACTIVE,USED" > /tmp/${node}_nmon_mem.csv
for nmon_file in `ls /root/nmon/*nmon`
do
  datestamp=`echo ${nmon_file} | cut -f2 -d"_"`
  grep MEM, $nmon_file > /tmp/mem.tmp
  grep ZZZZ $nmon_file > /tmp/zzzz.tmp
  grep -v "Memory MB " /tmp/mem.tmp | sed "s/,/ /g" | \
  while read NAME TS MEMTOTAL HIGHTOTAL LOWTOTAL SWAPTOTAL MEMFREE HIGHFREE LOWFREE SWAPFREE MEMSHARED CACHED ACTIVE BIGFREE BUFFERS SWAPCACHED INACTIVE rest
  do
    timestamp=`grep ${TS} /tmp/zzzz.tmp | awk -F, '{print $4" "$3}'`
    USED=`echo "scale=1;${MEMTOTAL}-${MEMFREE}+${BUFFERS}+${CACHED}" | bc`

    echo $timestamp,$MEMTOTAL,$HIGHTOTAL,$LOWTOTAL,$SWAPTOTAL,$MEMFREE,$HIGHFREE,$LOWFREE,$SWAPFREE,$MEMSHARED,$CACHED,$ACTIVE,$BIGFREE,$BUFFERS,$SWAPCACHED,$INACTIVE,$USED >> \
    /tmp/${node}_nmon_mem.csv
  done
  rm -f /tmp/mem.tmp /tmp/zzzz.tmp
done
