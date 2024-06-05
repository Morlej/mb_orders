--------------------------------------------------------------------------------
-- Order Entry Benchmark 
--
-- warehouse.ctl - Load warehouse data
--
--------------------------------------------------------------------------------

load data
infile 'gen/warehouse.gen'
into table whouse
fields terminated by ' '
(whs_id, name, addr_id)
