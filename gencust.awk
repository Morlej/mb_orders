#!/usr/bin/gawk -f
################################################################################
# Order Entry Benchmark 
#
# gencust.awk - Generate customer data
#
# Copyright (C) 2002 Scale Abilities Ltd. 
################################################################################
# Who		When		What
# ---		----		----
# J.Morle	01-MAY-2002	Creation
#
################################################################################
# $Header: /repository/scaleabilities/bench/orders/gencust.awk,v 1.3 2002/07/09 15:13:43 morlej Exp $
################################################################################

BEGIN { 
        if (ncust==0) {
                print "ncust not defined. Exiting" >"/dev/stderr"
                exit(2);
        }
	
	roots="nameroots.dat";
	i=0;
	while (getline <roots) {
		root[i++]=$1;
	}
	close(roots);
	num=asort(root);
	outf="gen/customers.gen";
	for (i=1;i<=ncust;i++) {
		print i,int(rand()*ncust),
			randname(4000),
			randname(2000)>outf;
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
