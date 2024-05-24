/*
################################################################################
# Order Entry Benchmark 
#
# replenish.sql - Top up stock levels
#
# Copyright (C) 2002 Scale Abilities Ltd. 
################################################################################
# Who		When		What
# ---		----		----
# J.Morle	01-MAY-2002	Creation
#
################################################################################
# $Header: /repository/scaleabilities/bench/orders/tx/replenish.sql,v 1.2 2002/06/20 17:54:10 morlej Exp $
################################################################################
*/
update stock set stock_level=stock_level+30
where stock_level<50;
commit;
exit
