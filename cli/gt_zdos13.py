#!/usr/bin/env python
import sys
from zdos13_tech import ZDOS13_TECH_STACK

def list_modules():
    for t in ZDOS13_TECH_STACK:
        print(f"- {t}")

def main():
    if len(sys.argv) < 2:
        print("Uso: gt_zdos13 <list>")
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == "list":
        list_modules()
    else:
        print(f"Comando sconosciuto: {cmd}")
        sys.exit(1)

if __name__ == "__main__":
    main()
