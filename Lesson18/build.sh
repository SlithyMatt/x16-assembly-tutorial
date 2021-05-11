#!/bin/sh

python 4bpp_sprites.py balls.data
cl65 -t cx16 -o SPRITES.PRG -l sprites.list sprites.asm
