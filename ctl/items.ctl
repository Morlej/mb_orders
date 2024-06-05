--------------------------------------------------------------------------------
-- Order Entry Benchmark 
--
-- items.ctl - SQL*Loader control file for loading items data
--
--------------------------------------------------------------------------------

load data
infile 'gen/items.gen'
into table items
fields terminated by ' '
(item_id, name, item_dsc, unitcost)
