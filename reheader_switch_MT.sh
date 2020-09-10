#!/bin/bash

FAST_OUT_DIR=$(mktemp -d -p /fastscratch/skelld)
bcftools view -h $1 > $FAST_OUT_DIR/hh
grep -v annotate $FAST_OUT_DIR/hh > $FAST_OUT_DIR/hh2
python reheader_switch_MT.py $FAST_OUT_DIR/hh2 $FAST_OUT_DIR/hh3
#head -n 24 $FAST_OUT_DIR/hh2 > $FAST_OUT_DIR/hh3
#head -n 27 $FAST_OUT_DIR/hh2 | tail -n 1 >> $FAST_OUT_DIR/hh3
#head -n 26 $FAST_OUT_DIR/hh2 | tail -n 2 >> $FAST_OUT_DIR/hh3
#head -n 50 $FAST_OUT_DIR/hh2 | tail -n 23 >> $FAST_OUT_DIR/hh3

mv $FAST_OUT_DIR/hh3 $1.reheader
rm -f $FAST_OUT_DIR/hh*
rmdir $FAST_OUT_DIR
