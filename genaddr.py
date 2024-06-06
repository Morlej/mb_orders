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
    if not roots:
        return "NoValue"
    if card > num:
        card = num
    
    # Calculate the index based on the cardinality
    index = (int(num * random.random()) % card) * int(num / card)
    if index >= num:
        index = num - 1  # Ensure the index is within bounds

    ret = roots[index]
    return ret if ret else "NoValue"

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
                f"{randname(roots, 8000, num)} "
                f"{randname(roots, 300, num)} "
                f"{randname(roots, 15, num)} "
                f"{randname(roots, 15, num)[:4]}{randname(roots, 10000, num)[:4]}"
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
