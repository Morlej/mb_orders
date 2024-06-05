/*
################################################################################
# Order Entry Benchmark 
#
# cust_update.sql - Simulate customer detail updates
#
################################################################################
*/

update cust set forename=lastname, lastname=forename
where cust_id=trunc(dbms_random.value(1,500000));
commit;
exit
