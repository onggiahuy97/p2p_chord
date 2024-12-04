#!/usr/bin/env python3
import sys
import hashlib

def hash_int(key, m):
    return int(hashlib.sha1(key.encode()).hexdigest(), 16) % (2 ** m)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(1)
    key = sys.argv[1]
    m = int(sys.argv[2])
    print(hash_int(key, m))
