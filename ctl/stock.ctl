--------------------------------------------------------------------------------
-- Order Entry Benchmark 
--
-- stock.ctl - Load stock items
--
--------------------------------------------------------------------------------

load data
infile 'gen/stock.gen'
into table stock
fields terminated by ' '
(stock_id, item_id, whs_id, stock_level)
