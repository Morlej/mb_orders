--------------------------------------------------------------------------------
-- Order Entry Benchmark 
--
-- cust.ctl - SQL*Loader control file for loading customer data
--------------------------------------------------------------------------------

load data
infile 'gen/customers.gen'
into table cust
fields terminated by ' '
( addr_id, forename, lastname, cust_id)
