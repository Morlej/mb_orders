--------------------------------------------------------------------------------
-- Order Entry Benchmark 
--
-- tab.sql - Create user and database objects for benchmark
--
-- Copyright (C) 2002 Scale Abilities Ltd. 
--------------------------------------------------------------------------------
-- Who		When		What
-- ---		----		----
-- J.Morle	01-MAY-2002	Creation
--
--------------------------------------------------------------------------------
-- $Header: /repository/scaleabilities/bench/orders/schema/tab_fl.sql,v 1.1 2003/10/14 11:26:59 morlej Exp $
--------------------------------------------------------------------------------

create user orders identified by orders;
grant dba to orders;

connect orders/orders;
create table cust ( 	cust_id 	number(15) not null,
			addr_id 	number(15) not null,
			forename	varchar2(64) not null,
			lastname	varchar2(64) not null
		) 
tablespace data
storage ( freelists 23 );
create unique index custpk on cust (cust_id) tablespace indx storage ( freelists 23 );
create index custfk on cust (addr_id) tablespace indx storage ( freelists 23 );
create index custnam on cust (lastname,forename) tablespace indx storage ( freelists 23 );

create table addr (	addr_id		number(15) not null,
			housenum	number(5) not null,
			street		varchar2(128) not null,
			town		varchar2(64) not null,
			county		varchar2(64) not null,
			postcode	varchar2(10) not null
) tablespace data storage ( freelists 23 );
create unique index addrpk on addr(addr_id) tablespace indx storage ( freelists 23 );
create index addr1 on addr(housenum) tablespace indx storage ( freelists 23 );
create index addr2 on addr(postcode) tablespace indx storage ( freelists 23 );
create index addr3 on addr(town) tablespace indx storage ( freelists 23 );
create index addr4 on addr(street) tablespace indx storage ( freelists 23 );

create table stock ( 	stock_id	number(15) not null,
			item_id		number(15) not null,
			whs_id		number(15) not null,
			stock_level	number(10) not null
) tablespace data storage ( freelists 23 );
create unique index stockpk on stock(stock_id) tablespace indx storage ( freelists 23 );
create index stockfk on stock(whs_id) tablespace indx storage ( freelists 23 );
create index stockfk2 on stock(item_id) tablespace indx storage ( freelists 23 );

create table whouse (	whs_id		number(15) not null,
			name		varchar2(100) not null,
			addr_id		number(15) not null
) tablespace data storage ( freelists 23 );
create unique index whspk on whouse(whs_id) tablespace indx storage ( freelists 23 );
create index whsnam on whouse(name) tablespace indx storage ( freelists 23 );

create table line_items (	line_id		number(15) not null,
				order_id	number(15) not null,
				item_id		number(15) not null,
				quantity	number(10) not null
) tablespace data storage ( freelists 23 );
create unique index lipk on line_items(line_id) tablespace indx storage ( freelists 23 );
create index lifk1 on line_items(order_id) tablespace indx storage ( freelists 23 );
create index lifk2 on line_items(item_id) tablespace indx storage ( freelists 23 );

create table orders (		order_id	number(15) not null,
				shipaddr	number(15) not null,
				cust_id		number(15) not null,
				order_dt	date not null,
				paid		varchar2(1) not null,
				status		varchar2(10) not null
) tablespace data storage ( freelists 23 );
create unique index orderpk on orders(order_id) tablespace indx storage ( freelists 23 );
create index orderfk1 on orders(shipaddr) tablespace indx storage ( freelists 23 );
create index orderfk2 on orders(cust_id) tablespace indx storage ( freelists 23 );
create index orderdt on orders(order_dt) tablespace indx storage ( freelists 23 );
create bitmap index paidbm on orders(paid) tablespace indx storage ( freelists 23 );
create bitmap index statbm on orders(status) tablespace indx storage ( freelists 23 );

create table items (		item_id		number(15) not null,
				name		varchar2(128) not null,
				item_dsc	varchar2(512) not null,
				unitcost	number(8,3) not null
) tablespace data storage ( freelists 23 );
create unique index itempk on items(item_id) tablespace indx storage ( freelists 23 );


create table stock_allocations ( stock_id 	number(15) not null,
				 order_id	number(15) not null,
				 quantity	number(15) not null
) tablespace data storage ( freelists 23 );
create index sa_fk1 on stock_allocations (stock_id) tablespace indx storage ( freelists 23 );
create index sa_fk2 on stock_allocations (order_id) tablespace indx storage ( freelists 23 );

create table nameroots ( name_id	number(15) not null,
			 name		varchar2(512)
) tablespace data storage ( freelists 23 );
create unique index namepk on nameroots(name_id) tablespace indx storage ( freelists 23 );


create sequence cust_seq start with 1000000 increment by 1 noorder cache 2000;
create sequence addr_seq start with 1000000 increment by 1 noorder cache 2000;
create sequence order_seq start with 1000000 increment by 1 noorder cache 2000;
create sequence line_seq start with 1000000 increment by 1 noorder cache 2000;
