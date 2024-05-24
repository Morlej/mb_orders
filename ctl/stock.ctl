--------------------------------------------------------------------------------
-- Order Entry Benchmark 
--
-- stock.ctl - Load stock items
--
-- Copyright (C) 2002 Scale Abilities Ltd. 
--------------------------------------------------------------------------------
-- Who		When		What
-- ---		----		----
-- J.Morle	01-MAY-2002	Creation
--
--------------------------------------------------------------------------------
-- $Header: /repository/scaleabilities/bench/orders/ctl/stock.ctl,v 1.3 2002/07/09 15:13:43 morlej Exp $
--------------------------------------------------------------------------------

load data
infile 'gen/stock.gen'
into table stock
fields terminated by ' '
(stock_id, item_id, whs_id, stock_level)
