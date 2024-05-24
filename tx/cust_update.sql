/*
################################################################################
# Order Entry Benchmark 
#
# cust_update.sql - Simulate customer detail updates
#
# Copyright (C) 2002 Scale Abilities Ltd. 
################################################################################
# Who		When		What
# ---		----		----
# J.Morle	01-MAY-2002	Creation
#
################################################################################
# $Header: /repository/scaleabilities/bench/orders/tx/cust_update.sql,v 1.2 2002/06/20 17:54:10 morlej Exp $
################################################################################
*/

update cust set forename=lastname, lastname=forename
where cust_id=trunc(dbms_random.value(1,500000));
commit;
exit
