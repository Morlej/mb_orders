#!/bin/bash 
################################################################################
# Order Entry Benchmark 
#
# harness_oracle.sh - Run benchmark 
#
################################################################################

export TWO_TASK=orders
unset ORACLE_SID 

echo "How many OE clerks?"
read oe

# Start monitoring
sqlplus -s orders/orders <<ENDSQL
execute dbms_workload_repository.create_snapshot;
exit
ENDSQL


VERBOSE=""
java -classpath $ORACLE_HOME/jdbc/lib/ojdbc6.jar:. newOrder pikachu:1521:orders orders orders oracle $oe ${VERBOSE} &
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
sqlplus -s orders/orders <<ENDSQL
execute dbms_workload_repository.create_snapshot;
ENDSQL
