--------------------------------------------------------------------------------
-- Order Entry Benchmark 
--
-- cust.ctl - SQL*Loader control file for loading customer data
-- Copyright (C) 2002 Scale Abilities Ltd. 
--------------------------------------------------------------------------------
-- Who		When		What
-- ---		----		----
-- J.Morle	01-MAY-2002	Creation
--
--------------------------------------------------------------------------------
-- $Header: /repository/scaleabilities/bench/orders/ctl/cust.ctl,v 1.3 2002/07/09 15:13:43 morlej Exp $
--------------------------------------------------------------------------------

load data
infile 'gen/customers.gen'
into table cust
fields terminated by ' '
(cust_id, addr_id, forename, lastname)
