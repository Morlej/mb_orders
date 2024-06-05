#-------------------------------------------------------------------------------
#-- Order Entry Benchmark 
#--
#-- tab_pg.sh - Create user and database objects for benchmark
#--
#-------------------------------------------------------------------------------

psql -w -d postgres <<ENDSQL
drop schema orders cascade;
create schema orders;
set search_path to orders;

create table cust ( 	cust_id 	UUID  not null DEFAULT gen_random_uuid(),
			addr_id 	UUID  not null,
			forename	varchar(64) not null,
			lastname	varchar(64) not null,
	PRIMARY KEY (cust_id)
		);
CREATE	INDEX cust_addr ON cust (addr_id);
CREATE	INDEX cust_name ON cust (lastname,forename);

create table addr (	addr_id		UUID not null DEFAULT gen_random_uuid(),
			housenum	integer not null,
			street		varchar(128) not null,
			town		varchar(64) not null,
			county		varchar(64) not null,
			postcode	varchar(10) not null,
	PRIMARY KEY (addr_id)
) ;
CREATE INDEX addr1 ON addr (housenum);
CREATE INDEX addr2 ON addr (postcode);
CREATE INDEX addr3 ON addr (town);
CREATE INDEX addr4 ON addr (street);

create table stock ( 	stock_id	integer not null,
			item_id		integer not null,
			whs_id		integer not null,
			stock_level	integer not null,
	PRIMARY KEY(stock_id)
) ;
CREATE	INDEX stock1 ON stock (whs_id);
CREATE	INDEX stock2 ON stock (item_id);

create table whouse (	whs_id		integer not null,
			name		varchar(100) not null,
			addr_id		integer not null,
	PRIMARY KEY(whs_id)
) ;
CREATE	INDEX whouse1 ON whouse (name);

create table line_items (	line_id		UUID not null DEFAULT gen_random_uuid(),
				order_id	integer not null,
				item_id		integer not null,
				quantity	integer not null,
	PRIMARY KEY(line_id)
) ;
CREATE	INDEX li1 ON line_items (order_id);
CREATE	INDEX li2 ON line_items (item_id);

create table orders (		order_id	UUID not null DEFAULT gen_random_uuid(),
				shipaddr	integer not null,
				cust_id		integer not null,
				order_dt	timestamp not null,
				paid		varchar(1) not null,
				status		varchar(10) not null,
	PRIMARY KEY(order_id)
) ;
CREATE	INDEX orders1 ON orders (shipaddr);
CREATE	INDEX orders2 ON orders (cust_id);
CREATE	INDEX orders3 ON orders (order_dt);

create table items (		item_id		integer not null,
				name		varchar(128) not null,
				item_dsc	varchar(512) not null,
				unitcost	float not null,
	PRIMARY KEY(item_id)
) ;

create table stock_allocations ( stock_id 	integer not null,
				 order_id	integer not null,
				 quantity	integer not null
) ;
CREATE	INDEX sa1 ON stock_allocations (stock_id);
CREATE	INDEX sa2 ON stock_allocations (order_id);

create table nameroots ( name_id	UUID not null DEFAULT gen_random_uuid(),
			 name		varchar(255),
	PRIMARY KEY(name_id)
) ;

ENDSQL
exit
