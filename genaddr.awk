#!/usr/bin/gawk -f
################################################################################
# Order Entry Benchmark 
#
# genaddr.awk - Generate random address data
#
# Copyright (C) 2002 Scale Abilities Ltd. 
################################################################################
# Who		When		What
# ---		----		----
# J.Morle	01-MAY-2002	Creation
#
################################################################################
# $Header: /repository/scaleabilities/bench/orders/genaddr.awk,v 1.3 2002/07/09 15:13:43 morlej Exp $
################################################################################

BEGIN { 
        if (naddr==0) {
                print "naddr not defined. Exiting" >"/dev/stderr"
                exit(2);
        }
	roots="nameroots.dat";
	i=0;
	while (getline <roots) {
		root[i++]=$1;
	}
	close(roots);
	num=asort(root);
	outf="gen/addresses.gen";
	for (i=1;i<=naddr;i++) {
		print i,int(rand()*200), 
			randname(naddr), 
			randname(1000), 
			randname(50), 
			substr(randname(50),1,4) \
			substr(randname(10000),1,4)>outf;
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
