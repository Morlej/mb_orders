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

	String inst;
	String username;
	String password;
	String dbtype;
	boolean 		verbose=false;



 public static 
 void main( String args[] ) throws Exception {

	int			usercount=0;
	String 			inst;
	String 			username;
	String 			password;
	String 			dbtype;
	boolean 		verbose=false;

	// Check parameter count (trivial)
	if (args.length<5 ) {
		System.err.println("Usage: java newOrder <inst/db> <user> <password> <type:oracle/mysql> <user_count> [verbose]");
		System.exit(2);
	}
	inst=args[0];
	username=args[1];
	password=args[2];
	dbtype=args[3];
	usercount=Integer.parseInt(args[4]);

	/* Anything in the 6th arg turns on verbose mode */
	if (args.length>5) 
		verbose=true;
	
	newOrder[] no=new newOrder[usercount];
	for (int i=0;i<usercount;i++) {
		no[i]=new newOrder( inst, username, password, dbtype, verbose);
		no[i].start();
	}

	/* Wait for all threads to complete */
	for (int i=0;i<usercount;i++) 
		no[i].join();

  }

	newOrder(String inst, String username, String password, String dbtype, boolean verbose) {

		this.inst=inst;
		this.username=username;
		this.password=password;
		this.dbtype=dbtype;
		this.verbose=verbose;
	}

	

  public void
  run() { 

	Connection 		conn=null;
	ResultSet		rs1,rs2,rs3,rs4;
	int			custCount=0,
				addrCount=0,
				skuCount=0,
				nameCount=0,
				warehouseCount=0;

	// Initialise Random number generator
	Random rnd=new Random();

try {
	if (dbtype.equals("oracle")) {
		DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver ());
		
		conn=DriverManager.getConnection ("jdbc:oracle:thin:@"+inst,
			username, password);
	} else {
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn=DriverManager.getConnection ("jdbc:mysql://localhost/"+inst, username, password);
		} catch (Exception e) {
			throw new java.sql.SQLException("Unable to load mysql JDBC driver.");
		}
	}

	Statement trc=conn.createStatement();
	if (dbtype.equals("oracle")) {
		trc.execute("alter session set events '10046 trace name context forever, level 12'");
	}
	conn.setAutoCommit(false);

	/* Parse the cursors */
	PreparedStatement ps1=	conn.prepareStatement(
		"SELECT cust_id, addr_id,forename,lastname "+
		"  FROM cust "+
		" WHERE cust_id=?");

	PreparedStatement ps2= conn.prepareStatement(
		"SELECT cust_id, addr_id,forename,lastname "+
		"  FROM cust "+
		" WHERE lastname like (select "+(dbtype.equals("oracle")?"substr(name,1,3)||'%'":"concat(substring(name,1,3),'%')")+" from nameroots "+
		"		where name_id=?) "+
		(dbtype.equals("oracle")?"    AND rownum=1":"LIMIT 1"));

	PreparedStatement ps3= conn.prepareStatement(
		"SELECT item_id, stock_id, whs_id, stock_level "+
		"  FROM stock "+
		" WHERE item_id =? "+
		"FOR UPDATE"+(dbtype.equals("oracle")?" OF stock_level":""));

	PreparedStatement oseq= conn.prepareStatement(
		"SELECT order_seq.nextval FROM SYS.DUAL");

	PreparedStatement insOrder= conn.prepareStatement(
		"INSERT INTO orders values (	?, ?, ?, "+
			(dbtype.equals("oracle")?"sysdate":"now()")+
			", 'N','OPEN')");
		
	PreparedStatement findSKU= conn.prepareStatement(
		" SELECT item_id "+
		"   FROM items "+
		"  WHERE name like (select "+(dbtype.equals("oracle")?"substr(name,1,3)||'%'":"concat(substring(name,1,3),'%')")+" from nameroots "+
		"		where name_id=?) "+
		(dbtype.equals("oracle")?"    AND rownum=1":"LIMIT 1"));
	PreparedStatement updStock= conn.prepareStatement(
		"UPDATE stock SET stock_level=stock_level-1 WHERE item_id=?");

	PreparedStatement allocStock= conn.prepareStatement(
		"INSERT INTO stock_allocations values ( ?, ?, 1)");
	
	PreparedStatement lineItems= conn.prepareStatement(
		"INSERT INTO line_items VALUES ("+
		"? "+
		", ?, ?,1)");
/* mysql auto_increment test
	PreparedStatement lineItems= conn.prepareStatement(
		"INSERT INTO line_items VALUES ("+
		(dbtype.equals("oracle")?"line_seq.nextval":"null")+
		", ?, ?,1)");
*/

	/* Find out exactly how large the data sets are */
	rs1=trc.executeQuery("select max(cust_id) from cust");
	rs1.next();
	custCount=rs1.getInt(1);
	rs1.close();
	rs1=trc.executeQuery("select max(addr_id) from addr");
	rs1.next();
	addrCount=rs1.getInt(1);
	rs1.close();
	rs1=trc.executeQuery("select max(stock_id) from stock");
	rs1.next();
	skuCount=rs1.getInt(1);
	rs1.close();
	rs1=trc.executeQuery("select max(NAME_ID) from nameroots");
	rs1.next();
	nameCount=rs1.getInt(1);
	rs1.close();
	rs1=trc.executeQuery("select count(*) from whouse");
	rs1.next();
	warehouseCount=rs1.getInt(1);
	rs1.close();

	for (int j=1;j<=50;j++) {
		PreparedStatement tmpps;
		boolean		foundCust=false;
		while (!foundCust) {
			if (j%2==1) {
				if (verbose)
					System.out.println("Customer lookup by ID");
				
				/* Case 1: Have the customer ID */
				tmpps=ps1;
				tmpps.setInt(1,rnd.nextInt(custCount));
			} else {
				if (verbose)
					System.out.println("Customer lookup by substring");
				/* Case 2: Need to search for customer ID */
				tmpps=ps2;
				tmpps.setInt(1,rnd.nextInt(nameCount));
			}
			rs1=tmpps.executeQuery();
			foundCust=rs1.next();
			if (verbose)
				System.out.println("Customer = "+rs1.getInt(1));
			if (!foundCust)
				rs1.close();
		}

		int cust_id=rs1.getInt(1);
		int addr_id=rs1.getInt(2);
		String forename=rs1.getString(3);
		String lastname=rs1.getString(4);
		rs1.close();

		long nextoseq=0;
		if (dbtype.equals("oracle")) {
			rs1=oseq.executeQuery();
			rs1.next();
			nextoseq=rs1.getLong(1);

			insOrder.setLong(1,nextoseq);
		} else {
			insOrder.setNull(1,java.sql.Types.INTEGER);
		}

		insOrder.setInt(2,rnd.nextInt(addrCount)); // Random shipping address
		insOrder.setInt(3,cust_id);
		insOrder.execute();

		if (!dbtype.equals("oracle"))
			nextoseq=((com.mysql.jdbc.PreparedStatement)insOrder).getLastInsertID();

		if (verbose)
			System.out.println("Created order ID: "+nextoseq);

		conn.commit();

		/* Add line items of up to four items that are in stock */

		int itemID=0,stockID=0,whsID=0,stockLevel=0;
		for (int i=0;i<4;i++) {

			stockLevel=0;

			while(stockLevel<1) { 
				// Get SKU
				while (true) { 

					findSKU.setInt(1,rnd.nextInt(nameCount));
					rs1=findSKU.executeQuery();
					if (!rs1.next()) {
						rs1.close();
						continue;
					} else
						break;
				}
				itemID=rs1.getInt(1);
				rs1.close();


				ps3.setInt(1,itemID);
				rs1=ps3.executeQuery();
				if (!rs1.next()) {
					System.out.println("poo");
					System.exit(2);
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
			allocStock.setLong(2,nextoseq);
			allocStock.executeUpdate();
//			lineItems.setLong(1,nextoseq);
//			lineItems.setInt(2,itemID);
			lineItems.setInt(1,getKey());
			lineItems.setLong(2,nextoseq);
			lineItems.setInt(3,itemID);
			lineItems.executeUpdate();
			if (verbose)
				System.out.println("Allocated Line item: "+itemID);
			conn.commit();
		}	
		System.out.println("Order ID "+nextoseq+" complete");
		
	}
    } catch (SQLException se) {
		System.err.println("SQLException in thread!");
		se.printStackTrace();
		// Fall through to death
    }
}

static int key=0;
static Object mutex=new Object();

int getKey() {

	synchronized (mutex) {
		return key++;
	}

}

}
