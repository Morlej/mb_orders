#!/bin/bash 
################################################################################
# Order Entry Benchmark 
#
# loadata_pg.sh - Load all generated data into mysql database
#
################################################################################

echo -n "Have you run schema/tab_pg.sh to create the database and objects? "
read a
if [ "$a" != "y" ]
then
	echo "exiting"
	exit 2
fi

psql -d postgres <<ENDSQL
\t on
set search_path to orders;
select 'ITEMS', now();
\copy items FROM 'gen/items.gen' DELIMITER ' '

select 'NAMEROOTS', now();
\copy nameroots (name) FROM 'nameroots.dat' DELIMITER ' '

select 'STOCK', now();
\copy stock FROM 'gen/stock.gen' DELIMITER ' '

select 'WAREHOUSE', now();
\copy whouse FROM 'gen/warehouse.gen' DELIMITER ' '

select 'ADDRESSES', now();
\copy addr FROM 'gen/addresses.gen' DELIMITER ' '

select 'CUSTOMERS', now();
\copy orders.cust (addr_id, forename, lastname, cust_id) FROM 'gen/customers.gen' DELIMITER ' '
