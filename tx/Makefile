newOrder.class: newOrder.java
	javac -g -classpath $(ORACLE_HOME)/jdbc/lib/ojdbc6.jar:mysql.jar $<
run: newOrder.class
	java  -classpath $(ORACLE_HOME)/jdbc/lib/ojdbc6.jar:. newOrder localhost:1521:orders orders orders oracle
runmysql: newOrder.class
	java  -classpath $(ORACLE_HOME)/jdbc/lib/ojdbc6.jar:mysql.jar:. newOrder orders root password mysql
