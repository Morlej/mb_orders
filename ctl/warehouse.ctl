--------------------------------------------------------------------------------
-- Order Entry Benchmark 
--
-- warehouse.ctl - Load warehouse data
--
-- Copyright (C) 2002 Scale Abilities Ltd. 
--------------------------------------------------------------------------------
-- Who		When		What
-- ---		----		----
-- J.Morle	01-MAY-2002	Creation
--
--------------------------------------------------------------------------------
-- $Header: /repository/scaleabilities/bench/orders/ctl/warehouse.ctl,v 1.3 2002/07/09 15:13:43 morlej Exp $
--------------------------------------------------------------------------------

load data
infile 'gen/warehouse.gen'
into table whouse
fields terminated by ' '
(whs_id, name, addr_id)
