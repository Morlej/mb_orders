#!/usr/bin/env python3
################################################################################
# Order Entry Benchmark 
#
# gencust.py - Generate customer data
#
################################################################################

import argparse
import random
import uuid

def load_roots(file_path):
    roots = []
    with open(file_path, 'r') as file:
        for line in file:
            roots.append(line.strip())
    return roots

def load_addresses(file_path):
    addresses = []
    with open(file_path, 'r') as file:
        for line in file:
            addresses.append(line.strip().split()[0])
    return addresses

def randname(roots, card, num):
    ret = roots[(int(num * random.random()) % card) * int(num / card)]
    return ret if ret else "wibble"

def generate_customers(uuid_pk, warehouses, itemquant, nitems, naddr, ncust):
    if ncust == 0:
        print("ncust not defined. Exiting", file=sys.stderr)
        exit(2)
    
    roots = load_roots("nameroots.dat")
    addr_uuids = load_addresses("gen/addresses.gen")
    
    num = len(roots)
    
    with open("gen/customers.gen", 'w') as outf:
        for i in range(1, ncust + 1):
            if uuid_pk == 1:
                key = str(uuid.uuid4())
                fk = addr_uuids[int(random.random() * ncust)]
            else:
                key = i
                fk = int(random.random() * ncust)
            
            outf.write(f"{key} {fk} {randname(roots, 4000, num)} {randname(roots, 2000, num)}\n")

def main():
    parser = argparse.ArgumentParser(description="Generate customer data")
    parser.add_argument('-v', '--uuid_pk', type=int, required=True, help="UUID primary key flag")
    parser.add_argument('-w', '--warehouses', type=int, required=True, help="Number of warehouses")
    parser.add_argument('-i', '--itemquant', type=int, required=True, help="Item quantity")
    parser.add_argument('-n', '--nitems', type=int, required=True, help="Number of items")
    parser.add_argument('-a', '--naddr', type=int, required=True, help="Number of addresses")
    parser.add_argument('-c', '--ncust', type=int, required=True, help="Number of customers")

    args = parser.parse_args()
    
    generate_customers(args.uuid_pk, args.warehouses, args.itemquant, args.nitems, args.naddr, args.ncust)

if __name__ == "__main__":
    main()

