#-------------------------------------------------------------------------------
#-- Order Entry Benchmark 
#--
#-- tab_mysql.sh - Create user and database objects for benchmark
#--
#-- Copyright (C) 2002 Scale Abilities Ltd. 
#-------------------------------------------------------------------------------
#-- Who		When		What
#-- ---		----		----
#-- J.Morle	01-MAY-2002	Creation
#--
#-------------------------------------------------------------------------------
#-- $Header: /repository/scaleabilities/bench/orders/schema/tab_mysql.sh,v 1.2 2003/09/25 13:56:08 morlej Exp $
#-------------------------------------------------------------------------------

echo "Enter root password to DROP and recreate existing orders database:"
stty -echo
read pass
stty echo

mysqladmin -u root --password=$pass drop orders 
mysqladmin -u root --password=$pass create orders

mysql --password=$pass -u root <<ENDSQL
use orders;
create table cust ( 	cust_id 	INTEGER  not null AUTO_INCREMENT,
			addr_id 	INTEGER  not null,
			forename	varchar(64) not null,
			lastname	varchar(64) not null,
	PRIMARY KEY (cust_id),
	INDEX (addr_id),
	INDEX (lastname,forename)
		) 
TYPE=INNODB;

create table addr (	addr_id		integer not null AUTO_INCREMENT,
			housenum	integer not null,
			street		varchar(128) not null,
			town		varchar(64) not null,
			county		varchar(64) not null,
			postcode	varchar(10) not null,
	PRIMARY KEY (addr_id),
	INDEX (housenum),
	INDEX (postcode),
	INDEX (town),
	INDEX (street)
) TYPE=INNODB;

create table stock ( 	stock_id	integer not null,
			item_id		integer not null,
			whs_id		integer not null,
			stock_level	integer not null,
	PRIMARY KEY(stock_id),
	INDEX (whs_id),
	INDEX (item_id)
) TYPE=INNODB;

create table whouse (	whs_id		integer not null,
			name		varchar(100) not null,
			addr_id		integer not null,
	PRIMARY KEY(whs_id),
	INDEX (name)
) TYPE=INNODB;

create table line_items (	line_id		integer not null AUTO_INCREMENT,
				order_id	integer not null,
				item_id		integer not null,
				quantity	integer not null,
	PRIMARY KEY(line_id),
	INDEX (order_id),
	INDEX (item_id)
) TYPE=INNODB;

create table orders (		order_id	integer not null AUTO_INCREMENT,
				shipaddr	integer not null,
				cust_id		integer not null,
				order_dt	datetime not null,
				paid		varchar(1) not null,
				status		varchar(10) not null,
	PRIMARY KEY(order_id),
	INDEX (shipaddr),
	INDEX (cust_id),
	INDEX (order_dt)
) TYPE=INNODB;
# NOT created for mysql...
#create bitmap index paidbm on orders(paid) tablespace indx;
#create bitmap index statbm on orders(status) tablespace indx;

create table items (		item_id		integer not null,
				name		varchar(128) not null,
				item_dsc	varchar(512) not null,
				unitcost	float not null,
	PRIMARY KEY(item_id)
) TYPE=INNODB;

create table stock_allocations ( stock_id 	integer not null,
				 order_id	integer not null,
				 quantity	integer not null,
	INDEX (stock_id),
	INDEX (order_id)
) TYPE=INNODB;

create table nameroots ( name_id	integer not null auto_increment,
			 name		varchar(255),
	PRIMARY KEY(name_id)
) TYPE=INNODB;

grant all privileges on *.* to orders@localhost identified by 'orders';
grant all privileges on *.* to orders@'%' identified by 'orders';

ENDSQL
exit
