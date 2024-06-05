#!/usr/bin/env python3
################################################################################
# Order Entry Benchmark
#
# genaddr.py - Generate address data
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

def randname(roots, card, num):
    ret = roots[(int(num * random.random()) % card) * int(num / card)]
    return ret if ret else "wibble"

def generate_addresses(uuid_pk, naddr):
    if naddr == 0:
        print("naddr not defined. Exiting", file=sys.stderr)
        exit(2)
    
    roots = load_roots("nameroots.dat")
    
    num = len(roots)
    
    with open("gen/addresses.gen", 'w') as outf:
        for i in range(1, naddr + 1):
            if uuid_pk == 1:
                key = str(uuid.uuid4())
            else:
                key = i
            
            address = (
                f"{key} {int(random.random() * 200)} "
                f"{randname(roots, naddr, num)} "
                f"{randname(roots, 1000, num)} "
                f"{randname(roots, 50, num)} "
                f"{randname(roots, 50, num)[:4]}{randname(roots, 10000, num)[:4]}"
            )
            outf.write(f"{address}\n")

def main():
    parser = argparse.ArgumentParser(description="Generate random address data")
    parser.add_argument('-v', '--uuid_pk', type=int, required=True, help="UUID primary key flag")
    parser.add_argument('-a', '--naddr', type=int, required=True, help="Number of addresses")

    args = parser.parse_args()
    
    generate_addresses(args.uuid_pk, args.naddr)

if __name__ == "__main__":
    main()
