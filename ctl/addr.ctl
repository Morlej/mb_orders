--------------------------------------------------------------------------------
-- Order Entry Benchmark 
--
-- addr.ctl - SQL*Loader control file for loading addresses data
--
-- Copyright (C) 2002 Scale Abilities Ltd. 
--------------------------------------------------------------------------------
-- Who		When		What
-- ---		----		----
-- J.Morle	01-MAY-2002	Creation
--
--------------------------------------------------------------------------------
-- $Header: /repository/scaleabilities/bench/orders/ctl/addr.ctl,v 1.3 2002/07/09 15:13:43 morlej Exp $
--------------------------------------------------------------------------------

load data
infile 'gen/addresses.gen'
into table addr
fields terminated by ' '
(addr_id, housenum, street, town, county, postcode )
