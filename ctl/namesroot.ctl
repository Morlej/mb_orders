--------------------------------------------------------------------------------
-- Order Entry Benchmark 
--
-- namesroot.ctl - SQL*Loader control file for loading name stub data
--
-- Copyright (C) 2002 Scale Abilities Ltd. 
--------------------------------------------------------------------------------
-- Who		When		What
-- ---		----		----
-- J.Morle	01-MAY-2002	Creation
--
--------------------------------------------------------------------------------
-- $Header: /repository/scaleabilities/bench/orders/ctl/namesroot.ctl,v 1.3 2002/07/09 15:13:43 morlej Exp $
--------------------------------------------------------------------------------

load data
infile 'nameroots'
into table nameroots
fields terminated by ' '
(name_id SEQUENCE(MAX,1), name)
