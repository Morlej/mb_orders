#!/bin/bash 
################################################################################
# Order Entry Benchmark 
#
# gendata.sh - Call all data generation routines
#
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
# Use UUID keys?
UUID_PK=1

VARS="-v uuid_pk=${UUID_PK} -v warehouses=$warehouses -v itemquant=$itemquant -v nitems=$nitems -v naddr=$naddr -v ncust=$ncust"

mkdir gen 2>/dev/null

echo "Addresses"
./genaddr.py --uuid_pk ${UUID_PK} --naddr $naddr
echo "Customers"
./gencust.py --uuid_pk ${UUID_PK} --naddr $naddr --warehouses $warehouses --itemquant $itemquant --nitems $nitems --ncust $ncust
echo "Items"
./genitems.awk $VARS
echo "Stock"
./genstock.awk $VARS
