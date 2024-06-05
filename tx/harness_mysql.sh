#!/bin/bash
################################################################################
# Order Entry Benchmark 
#
# harness_mysql.sh - Run benchmark 
#
################################################################################

echo "How many OE clerks?"
read oe

# Start monitoring
mysql -u orders --password=orders orders <<ENDSQL
CREATE TABLE innodb_monitor(a INT) type = innodb;
ENDSQL

VERBOSE=""
java -classpath ./mysql.jar:. newOrder orders orders orders mysql $oe ${VERBOSE} &
PID=$!
while [ `ps -fp ${PID} | wc -l` -gt 1 ]
do
#	mysql -u orders --password=orders orders <<-ENDSQL
#	source replenish.sql
#	ENDSQL
#	for i in 1 2 3 4 5 6
#	do
#		mysql -u orders --password=orders orders <<-ENDSQL
#		source cust_update.sql
#		ENDSQL
#	done
	sleep 1
done

#sleep 60

# Stop monitoring
mysql -u orders --password=orders orders <<ENDSQL
DROP TABLE innodb_monitor;
ENDSQL
