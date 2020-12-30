.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start         ; absolute

data:
.byte $01,$23,$45,$67,$89,$AB,$CD,$EF

results:
.byte 0,0,0

start:
   lda #$C1
   pha
   plp
   clc
   clv
   lda #0
   adc #127
   adc #1
   adc #127
   adc #1


return:
   rts
