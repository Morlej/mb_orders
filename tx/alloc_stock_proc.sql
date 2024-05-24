/*
################################################################################
# Order Entry Benchmark 
#
# alloc_stock_pkg.sql - stored procedure to allocate stock by id
#
# Copyright (C) 2002 Scale Abilities Ltd. 
################################################################################
# Who		When		What
# ---		----		----
# J.Morle	01-MAY-2002	Creation
#
################################################################################
# $Header: /repository/scaleabilities/bench/orders/tx/alloc_stock_proc.sql,v 1.1 2003/11/04 14:42:00 morlej Exp $
################################################################################
*/


create or replace procedure orders.alloc_stock( in_order_id IN NUMBER,
						in_item_id IN NUMBER, 
						in_stock_id IN NUMBER ) 
IS
BEGIN
		UPDATE stock SET stock_level=stock_level-1 WHERE item_id=in_item_id;
		INSERT INTO stock_allocations values ( in_stock_id, in_order_id, 1);
		INSERT INTO line_items VALUES ( line_seq.nextval, 
						in_order_id,
						in_item_id,
						1);

END alloc_stock;
/
