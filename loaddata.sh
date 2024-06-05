#!/bin/bash 
################################################################################
# Order Entry Benchmark 
#
# loadata.sh - Load all generated data
#
################################################################################

export ORACLE_SID=orders

echo -n "Have you run schema/tab.sql to create the user and objects? "
read a
if [ "$a" != "y" ]
then
	echo "exiting"
	exit 2
fi

exec 2>&1
exec >loaddata.out

sqlplus perfstat/perfstat <<ENDSQL
execute statspack.snap(I_UCOMMENT=> 'Load start');
exit
ENDSQL

echo "Starting addr at `date`"
sqlldr userid=orders/orders parfile=ctl/sqlldr.par control=ctl/addr.ctl 
echo "Starting cust at `date`"
sqlldr userid=orders/orders parfile=ctl/sqlldr.par control=ctl/cust.ctl 
echo "Starting items at `date`"
sqlldr userid=orders/orders parfile=ctl/sqlldr.par control=ctl/items.ctl 
echo "Starting namesroot at `date`"
sqlldr userid=orders/orders parfile=ctl/sqlldr.par control=ctl/namesroot.ctl 
echo "Starting stock at `date`"
sqlldr userid=orders/orders parfile=ctl/sqlldr.par control=ctl/stock.ctl 
echo "Starting whouse at `date`"
sqlldr userid=orders/orders parfile=ctl/sqlldr.par control=ctl/warehouse.ctl 

sqlplus perfstat/perfstat <<ENDSQL
execute statspack.snap(I_UCOMMENT=> 'Start index rebuilds');
exit
ENDSQL

echo "Starting index rebuilds (where needed) at `date`"
sqlplus orders/orders <<ENDSQL
select 'alter index '||index_name||' rebuild;' from user_indexes where status='UNUSABLE'

spool rebuild_ind.sql
/
spool off
set echo on timi on time on
start rebuild_ind
!rm rebuild_ind.sql
exit
ENDSQL

echo "ended at `date`"

sqlplus perfstat/perfstat <<ENDSQL
execute statspack.snap(I_UCOMMENT=> 'Load end');
exit
ENDSQL
