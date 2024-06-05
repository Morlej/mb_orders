--------------------------------------------------------------------------------
-- Order Entry Benchmark 
--
-- addr.ctl - SQL*Loader control file for loading addresses data
--
--------------------------------------------------------------------------------

load data
infile 'gen/addresses.gen'
into table addr
fields terminated by ' '
(addr_id, housenum, street, town, county, postcode )
