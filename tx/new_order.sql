/*
################################################################################
# Order Entry Benchmark 
#
# new_order.sql - PL/SQL program to create new orders
#
# Copyright (C) 2002 Scale Abilities Ltd. 
################################################################################
# Who		When		What
# ---		----		----
# J.Morle	01-MAY-2002	Creation
#
################################################################################
# $Header: /repository/scaleabilities/bench/orders/tx/new_order.sql,v 1.2 2002/06/20 17:54:10 morlej Exp $
################################################################################
*/
set serveroutput on size 32768
DECLARE
l_cust_id	NUMBER;
num1		NUMBER;
i		NUMBER;
l_level		NUMBER;
l_order_id	NUMBER;
l_stock_id	NUMBER;
l_whs_id	NUMBER;
l_item_id	NUMBER;
str1		VARCHAR2(1024);
str2		VARCHAR2(1024);
str3		VARCHAR2(1024);
str4		VARCHAR2(1024);
str5		VARCHAR2(1024);
str6		VARCHAR2(1024);
TYPE itemListType IS TABLE OF NUMBER(15)
	INDEX BY BINARY_INTEGER;
itemList itemListType;

CURSOR c1 (f_cust_id number) is 
SELECT addr_id,forename,lastname
  FROM cust
 WHERE cust_id= l_cust_id;

CURSOR c2 is
SELECT cust_id, addr_id,forename,lastname
  FROM cust
 WHERE lastname like (select substr(name,1,3)||'%' from nameroots
			where name_id=trunc(dbms_random.value(1,62000)));

CURSOR c3(in_id number) IS
SELECT item_id, stock_id, whs_id, stock_level 
  FROM stock
 WHERE item_id = in_id
FOR UPDATE OF stock_level;

BEGIN
execute immediate 'alter session set events ''10046 trace name context forever, level 12''';


FOR I IN 1..50 LOOP
	if (mod(I,2)=1) then
		-- Case 1: Have the customer ID
		l_cust_id:=dbms_random.value(1,500000);
		OPEN c1(l_cust_id);
		FETCH c1 into num1,str1,str2;
		CLOSE c1;

	ELSE
		--Case 2: Need to search for customer ID
		num1:=0;
		WHILE (num1=0) LOOP
			OPEN c2;
			FETCH c2 into l_cust_id, num1,str1,str2;
			CLOSE c2;
		END LOOP;

	END IF;

	SELECT order_seq.nextval INTO l_order_id FROM SYS.DUAL;

	INSERT INTO orders values (	l_order_id, 
					trunc(dbms_random.value(1,500000)),
					l_cust_id, sysdate, 'N','OPEN');
	commit;

	-- Try to find some line items that are in stock
	itemList(0):=dbms_random.value(1,10000);
	itemList(1):=dbms_random.value(1,10000);
	itemList(2):=0;
	itemList(3):=0;
	FOR i IN 2..3 LOOP
		WHILE (itemList(i)=0) LOOP
			BEGIN
				SELECT item_id
				INTO itemList(i)
				FROM items
				WHERE name like (select substr(name,1,3)||'%' from nameroots
					where name_id=trunc(dbms_random.value(1,62000))
				) 
				AND rownum=1;
			EXCEPTION 
				WHEN NO_DATA_FOUND THEN
				itemList(i):=0;
			END;

		END LOOP;
	END LOOP;

	-- Check stock levels for selected items and grab them if possible
	FOR  i IN 0..3 LOOP
		OPEN c3(itemList(i));
		FETCH c3 INTO l_item_id, l_stock_id, l_whs_id, l_level;
		CLOSE c3;
		WHILE (l_level<1) LOOP
			rollback; -- clear bogus locks
			OPEN c3(itemList(i));
			FETCH c3 INTO l_item_id, l_stock_id, l_whs_id, l_level;
			CLOSE c3;
			IF (l_level<1) THEN
				SELECT item_id
				INTO itemList(i)
				FROM items
				WHERE name like (select substr(name,1,3)||'%' from nameroots
					where name_id=trunc(dbms_random.value(1,62000))
				) 
				AND rownum=1;
			END IF;
		END LOOP;
		UPDATE stock SET stock_level=stock_level-1 WHERE item_id=itemList(i);
		INSERT INTO stock_allocations values ( l_stock_id, l_order_id, 1);
		INSERT INTO line_items VALUES (line_seq.nextval, l_order_id, l_item_id,1);
		commit;
		dbms_output.put_line('new order: '||l_order_id);
	END LOOP;
END LOOP;
END;
/
exit
