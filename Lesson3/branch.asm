.org $080D
.segment "ONCE"
.segment "CODE"

CHROUT = $FFD2
NEWLINE = $0D

   jmp start

data:
.byte $01,$23,$45,$67,$89,$AB,$CD,$EF

start:
   ; branching if less than (N set)
   ldx #0
n_loop:
   lda data,x
   cmp #$55
   bmi next_n
   txa
   ora #$30
   jsr CHROUT
next_n:
   inx
   cpx #8
   bne n_loop
   lda #NEWLINE
   jsr CHROUT

   ; branching if carry (C set)
   ldx #0
c_loop:
   lda data,x
   clc
   adc #$55
   bcs next_c
   txa
   ora #$30
   jsr CHROUT
next_c:
   inx
   cpx #8
   bne c_loop
   lda #NEWLINE
   jsr CHROUT

   ; branching if overflow (V set)
   ldx #0
v_loop:
   lda data,x
   clc
   adc #$55
   bvs next_v
   txa
   ora #$30
   jsr CHROUT
next_v:
   inx
   cpx #8
   bne v_loop
   lda #NEWLINE
   jsr CHROUT
   rts
