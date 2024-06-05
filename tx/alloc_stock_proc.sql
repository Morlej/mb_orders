/*
################################################################################
# Order Entry Benchmark 
#
# alloc_stock_pkg.sql - stored procedure to allocate stock by id
#
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
