#!/usr/bin/awk -f
################################################################################
# Order Entry Benchmark 
#
# genitems.awk - Generate stock items
#
################################################################################

BEGIN { 
	if (nitems==0) {
		print "nitems not defined. Exiting" >"/dev/stderr"
		exit(2);
	}
	roots="nameroots.dat";
	i=0;
	while (getline <roots) {
		root[i++]=$1;
	}
	close(roots);
	num=asort(root);
	outf="gen/items.gen";
	for (i=1;i<=nitems;i++) {
		print i, randname(2000),
			randname(1000) \
			randname(1000) \
			randname(1000) \
			randname(1000) \
			randname(1000) \
			randname(1000) \
			randname(1000) \
			randname(1000) ,
			20000*rand()>outf;
	}
	close(outf);
      }
function randname( card) {


	ret=(root[(int(num*rand())%card)*int(num/card)]);
	if (ret!="")
		return ret;
	else
		return "wibble";
}
