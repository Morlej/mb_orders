--------------------------------------------------------------------------------
-- Order Entry Benchmark 
--
-- items.ctl - SQL*Loader control file for loading items data
--
-- Copyright (C) 2002 Scale Abilities Ltd. 
--------------------------------------------------------------------------------
-- Who		When		What
-- ---		----		----
-- J.Morle	01-MAY-2002	Creation
--
--------------------------------------------------------------------------------
-- $Header: /repository/scaleabilities/bench/orders/ctl/items.ctl,v 1.3 2002/07/09 15:13:43 morlej Exp $
--------------------------------------------------------------------------------

load data
infile 'gen/items.gen'
into table items
fields terminated by ' '
(item_id, name, item_dsc, unitcost)
