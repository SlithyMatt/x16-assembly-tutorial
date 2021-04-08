#!/bin/sh

python 4bpp_bitmap.py brillig.data
cl65 -t cx16 -o BITMAP.PRG -l bitmap.list bitmap.asm
