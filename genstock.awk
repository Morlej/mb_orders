################################################################################
# Order Entry Benchmark 
#
# genstock.awk - Generate stock
#
################################################################################

BEGIN { 
        if (itemquant==0) {
                print "itemquant not defined. Exiting" >"/dev/stderr"
                exit(2);
        }
        if (warehouses==0) {
                print "warehouses not defined. Exiting" >"/dev/stderr"
                exit(2);
        }

	roots="nameroots.dat";
	i=0;
	while (getline <roots) {
		root[i++]=$1;
	}
	close(roots);
	num=asort(root);
	outf1="gen/stock.gen";
	outf2="gen/warehouse.gen";

	for (i=0;i<warehouses;i++) {
		print i,randname(warehouses), int(500000*rand())>outf2
	}
	close(outf2);
	for (i=1;i<=itemquant;i++) {
		print i, i, i%warehouses, 100>outf1;
	}
	close(outf1);
      }

function randname( card) {


	ret=(root[(int(num*rand())%card)*int(num/card)]);
	if (ret!="")
		return ret;
	else
		return "wibble";
}
