#!/bin/bash 
################################################################################
# Order Entry Benchmark 
#
# loadata_mysql.sh - Load all generated data into mysql database
#
# Copyright (C) 2002 Scale Abilities Ltd. 
################################################################################
# Who		When		What
# ---		----		----
# J.Morle	01-MAY-2002	Creation
#
################################################################################
# $Header: /repository/scaleabilities/bench/orders/loaddata_mysql.sh,v 1.3 2003/10/14 11:26:59 morlej Exp $
################################################################################


echo -n "Have you run schema/tab_mysql.sh to create the database and objects? "
read a
if [ "$a" != "y" ]
then
	echo "exiting"
	exit 2
fi

mysql -p -u root orders <<ENDSQL
select 'ITEMS', now();
load data LOCAL INFILE 'gen/items.gen'
REPLACE
INTO TABLE items
FIELDS TERMINATED BY ' '
(item_id, name, item_dsc, unitcost);

select 'NAMEROOTS', now();
load data LOCAL INFILE 'nameroots.dat'
REPLACE
INTO TABLE nameroots
FIELDS TERMINATED BY ' '
(name);

select 'STOCK', now();
load data LOCAL INFILE 'gen/stock.gen'
REPLACE
INTO TABLE stock
FIELDS TERMINATED BY ' '
(stock_id, item_id, whs_id, stock_level);

select 'WAREHOUSE', now();
load data LOCAL INFILE 'gen/warehouse.gen'
REPLACE
INTO TABLE whouse
FIELDS TERMINATED BY ' '
(whs_id, name, addr_id);

select 'ADDRESSES', now();
load data LOCAL INFILE 'gen/addresses.gen'
REPLACE
INTO TABLE addr
FIELDS TERMINATED BY ' '
(addr_id, housenum, street, town, county, postcode );

select 'CUSTOMERS', now();
load data LOCAL INFILE 'gen/customers.gen'
REPLACE
INTO TABLE cust
FIELDS TERMINATED BY ' '
(cust_id, addr_id, forename, lastname);

ENDSQL
