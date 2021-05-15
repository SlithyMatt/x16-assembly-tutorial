#!/bin/sh

python 4bpp_sprites.py SPRITES.BIN
cl65 -t cx16 -o MUSIC.PRG -l music.list music.asm
