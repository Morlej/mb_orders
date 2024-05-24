#!/bin/bash 
################################################################################
# Order Entry Benchmark 
#
# gendata.sh - Call all data generation routines
#
# Copyright (C) 2002 Scale Abilities Ltd. 
################################################################################
# Who		When		What
# ---		----		----
# J.Morle	01-MAY-2002	Creation
#
################################################################################
# $Header: /repository/scaleabilities/bench/orders/gendata.sh,v 1.1 2002/06/20 17:54:10 morlej Exp $
################################################################################

# How many distinct customers?
ncust=5000000
# How many addresses?
naddr=5000000
# How many SKUs?
nitems=10000
# How much stock for each SKU?
itemquant=10000
# How many warehouses?
warehouses=5

VARS="-v warehouses=$warehouses -v itemquant=$itemquant -v nitems=$nitems -v naddr=$naddr -v ncust=$ncust"

set -x
./genaddr.awk $VARS
./gencust.awk $VARS
./genitems.awk $VARS
./genstock.awk $VARS
set +x
