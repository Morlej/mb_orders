/*
################################################################################
# Order Entry Benchmark 
#
# replenish.sql - Top up stock levels
#
################################################################################
*/
update stock set stock_level=stock_level+30
where stock_level<50;
commit;
exit
