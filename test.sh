#!/bin/bash

COUNTER=0
while [ $COUNTER -lt 100 ]; do
	mysql -h 192.168.42.10 -u root -ptest test_rick -e 'select * from your_table limit 1000;' > result-mysql; echo "$? $(date +%M:%S)" >> test_succes; sleep 0.5
	let COUNTER=COUNTER+1
done
