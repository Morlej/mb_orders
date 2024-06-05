/*
################################################################################
# Order Entry Benchmark 
#
# newOrder.java - Java program to create new orders
#
################################################################################
*/
import java.sql.*;
import oracle.jdbc.driver.*;
import java.util.*;
import java.io.*;

public class newOrder extends Thread {

Connection 		conn;
Random rnd;
int id;
static String inst;
static String username;
static String password;

newOrder(int id) throws Exception {

	// Initialise Random number generator
	rnd=new Random();
	this.id=id;

try {
	DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver ());
	
	conn=DriverManager.getConnection ("jdbc:oracle:thin:@"+inst,
		username, password);
	conn.setAutoCommit(false);

	if (id==3) {
		Statement trc=conn.createStatement();
		trc.execute("alter session set events '10046 trace name context forever, level 12'");
	}
} catch (SQLException se) {
	throw new Exception(se);
}
}

 public static 
 void main( String args[] ) throws Exception {

	int count=Integer.parseInt(args[3]);

	inst=args[0];
	username=args[1];
	password=args[2];

	newOrder no[]=new newOrder[count];

	for (int i=0;i<count;i++) {
		 no[i]=new newOrder(i);
	}
	try {
		Thread.sleep(1000);
	} catch (Exception e) { /* ignore */ }
		
	for (int i=0;i<count;i++) {
		no[i].start();
	}
	for (int i=0;i<count;i++) {
		no[i].join();
	}
}

public void
run() {
	int			custCount=0,
				addrCount=0,
				skuCount=0,
				nameCount=0,
				warehouseCount=0;



	ResultSet		rs1,rs2,rs3,rs4;
try {
	Statement		stmt=conn.createStatement();

	/* Parse the cursors */
	PreparedStatement ps1=	conn.prepareStatement(
		"SELECT cust_id, addr_id,forename,lastname "+
		"  FROM cust "+
		" WHERE cust_id=?");

	PreparedStatement ps2= conn.prepareStatement(
		"SELECT cust_id, addr_id,forename,lastname "+
		"  FROM cust "+
		" WHERE lastname like (select substr(name,1,3)||'%' from nameroots "+
		"		where name_id=?) AND rownum=1");

	PreparedStatement ps3= conn.prepareStatement(
		"SELECT item_id, stock_id, whs_id, stock_level "+
		"  FROM stock "+
		" WHERE item_id =? "+
		"FOR UPDATE OF stock_level");

	PreparedStatement oseq= conn.prepareStatement(
		"SELECT order_seq.nextval FROM SYS.DUAL");

	PreparedStatement insOrder= conn.prepareStatement(
		"INSERT INTO orders values (	?, ?, ?, sysdate, 'N','OPEN')");
		
	PreparedStatement findSKU= conn.prepareStatement(
		" SELECT item_id "+
		"   FROM items "+
		"  WHERE name like (select substr(name,1,3)||'%' from nameroots "+
		"		where name_id=?) "+
		"    AND rownum=1");
	PreparedStatement updStock= conn.prepareStatement(
		"UPDATE stock SET stock_level=stock_level-1 WHERE item_id=?");

	PreparedStatement allocStock= conn.prepareStatement(
		"INSERT INTO stock_allocations values ( ?, ?, 1)");
	
	PreparedStatement lineItems= conn.prepareStatement(
		"INSERT INTO line_items VALUES (line_seq.nextval, ?, ?,1)");

	/* Find out exactly how large the data sets are */
	rs1=stmt.executeQuery("select max(cust_id) from cust");
	rs1.next();
	custCount=rs1.getInt(1);
	rs1.close();
	rs1=stmt.executeQuery("select max(addr_id) from addr");
	rs1.next();
	addrCount=rs1.getInt(1);
	rs1.close();
	rs1=stmt.executeQuery("select max(stock_id) from stock");
	rs1.next();
	skuCount=rs1.getInt(1);
	rs1.close();
	rs1=stmt.executeQuery("select max(NAME_ID) from nameroots");
	rs1.next();
	nameCount=rs1.getInt(1);
	rs1.close();
	rs1=stmt.executeQuery("select count(*) from WHOUSE");
	rs1.next();
	warehouseCount=rs1.getInt(1);
	rs1.close();

	for (int j=1;j<=200;j++) {
		PreparedStatement tmpps;
		boolean		foundCust=false;
		while (!foundCust) {
				/* Case 1: Have the customer ID */
				tmpps=ps1;
				tmpps.setInt(1,rnd.nextInt(custCount));
			rs1=tmpps.executeQuery();
			foundCust=rs1.next();
			if (!foundCust)
				rs1.close();
		}

		int cust_id=rs1.getInt(1);
		int addr_id=rs1.getInt(2);
		String forename=rs1.getString(3);
		String lastname=rs1.getString(4);
		rs1.close();

		rs1=oseq.executeQuery();
		rs1.next();
		int nextoseq=rs1.getInt(1);

		insOrder.setInt(1,nextoseq);
		insOrder.setInt(2,rnd.nextInt(addrCount)); // Random shipping address
		insOrder.setInt(3,cust_id);
		insOrder.execute();
		conn.commit();

		/* Add line items of up to four items that are in stock */

		int itemID=0,stockID=0,whsID=0,stockLevel=0;
		for (int i=0;i<4;i++) {

			stockLevel=0;

			while(stockLevel<1) { 
				// Get SKU
/*
				while (true) { 

					findSKU.setInt(1,rnd.nextInt(nameCount));
					rs1=findSKU.executeQuery();
					if (!rs1.next()) {
						rs1.close();
						continue;
					} else
						break;
				}
				rs1.close();
*/
				boolean gotstock=false;
				while (!gotstock) {
					itemID=rnd.nextInt(10000);
					ps3.setInt(1,itemID);
					rs1=ps3.executeQuery();
					if (rs1.next()) {
						gotstock=true;
					} else {
						System.out.println("retrying stock");
					}
				}
				itemID=rs1.getInt(1);
				stockID=rs1.getInt(2);
				whsID=rs1.getInt(3);
				stockLevel=rs1.getInt(4);
				rs1.close();

				if (stockLevel<1) {
					conn.rollback();
					System.out.println("Out of stock for SKU "+itemID);
				}
			}
			// We have an in-stock SKU. Allocate.
			updStock.setInt(1,itemID);
			updStock.executeUpdate();
			allocStock.setInt(1,stockID);
			allocStock.setInt(2,nextoseq);
			allocStock.executeUpdate();
			lineItems.setInt(1,nextoseq);
			lineItems.setInt(2,itemID);
			lineItems.executeUpdate();
			conn.commit();
		}	
		System.out.println("Order ID "+nextoseq+" complete");
		
	}
} catch (SQLException se) {
	se.printStackTrace();
}
 }


}
