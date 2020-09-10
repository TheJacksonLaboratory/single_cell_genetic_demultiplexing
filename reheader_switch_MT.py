#!/usr/bin/env python

"""
Put MT contig before sex chromosomes instead of after
"""
import sys, argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("headerfile", metavar="")
    parser.add_argument("outfile", metavar="")
    args = parser.parse_args()
    
    foundX = False
    foundY = False
    x_line = None
    y_line = None
    out = open(args.outfile, 'w')
    f = open(args.headerfile, 'r')
    for line in f:
        if "contig=<ID=X" in line:
            foundX = True
            x_line = line
        elif "contig=<ID=Y" in line:
            foundY = True
            y_line = line
        elif "contig=<ID=MT" in line:
            assert foundX
            assert foundY
            out.write(line)
            out.write(x_line)
            out.write(y_line)
        else:
            out.write(line)
    f.close()
    out.close()

if __name__ == "__main__":
    sys.exit(main())
