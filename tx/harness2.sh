#!/bin/bash
################################################################################
# Order Entry Benchmark 
#
# harness.sh - Run benchmark 
#
# Copyright (C) 2002 Scale Abilities Ltd. 
################################################################################
# Who		When		What
# ---		----		----
# J.Morle	01-MAY-2002	Creation
#
################################################################################
# $Header: /repository/scaleabilities/bench/orders/tx/harness.sh,v 1.2 2002/06/20 17:54:10 morlej Exp $
################################################################################

echo "How many OE clerks?"
read oe
sqlplus -s perfstat/perfstat <<ENDSQL
execute statspack.snap(i_ucomment=>'begin bench');
exit
ENDSQL
java -classpath /opt/oracle/oracle920/jdbc/lib/classes12.jar:. newOrder pikachu:1521:ssd orders orders $oe &
PID=$!
while [ `ps -fp ${PID} | wc -l` -gt 1 ]
do
	sqlplus -s orders/orders @replenish
	sqlplus -s orders/orders @cust_update
	sqlplus -s orders/orders @cust_update
	sqlplus -s orders/orders @cust_update
	sqlplus -s orders/orders @cust_update
	sqlplus -s orders/orders @cust_update
	sqlplus -s orders/orders @cust_update
	sleep 1
done

sqlplus -s perfstat/perfstat <<ENDSQL
execute statspack.snap(i_ucomment=>'end bench');
exit
ENDSQL
