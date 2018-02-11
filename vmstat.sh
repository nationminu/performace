#!/bin/sh

vmstat_to_log() {
  vmstat 5 | while read line
  do
   echo `date +%T` $line
  done
}

vmstat_to_log
