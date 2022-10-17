.org $080D
.segment "ONCE"
.segment "CODE"

CHROUT = $FFD2
NEWLINE = $0D
SPACE = $20

   jmp start

header: .asciiz " a  x  y sp sr"

start:
   ldx #0
@header_loop:
   lda header,x
   beq @header_done
   jsr CHROUT
   inx
   bra @header_loop
@header_done:
   lda #NEWLINE
   jsr CHROUT

   jsr print_regs
   lda #$12
   ldx #$34
   ldy #$56
   jsr print_regs
   pha
   jsr print_regs
   tsx
   jsr print_regs
   php
   jsr print_regs
   ply
   jsr print_regs
   plp
   jsr print_regs
   rts

print_regs:
   php
   pha
   phx
   php ; push P again for quick retrieval
   jsr print_hex
   lda #SPACE
   jsr CHROUT
   txa
   jsr print_hex
   lda #SPACE
   jsr CHROUT
   tya
   jsr print_hex
   lda #SPACE
   jsr CHROUT
   tsx
   txa
   clc
   adc #6 ; calculate SP from before JSR
   jsr print_hex
   lda #SPACE
   jsr CHROUT
   pla ; pull earlier P into A
   jsr print_hex
   lda #NEWLINE
   jsr CHROUT
   plx
   pla
   plp
   rts


print_hex:
   pha	   ; push original A to stack
   lsr
   lsr
   lsr
   lsr      ; A = A >> 4
   jsr print_hex_digit
   pla      ; pull original A back from stack
   and #$0F ; A = A & 0b00001111
   jsr print_hex_digit
   rts

print_hex_digit:
   cmp #$0A
   bpl @letter
   ora #$30    ; PETSCII numbers: 1=$31, 2=$32, etc.
   bra @print
@letter:
   clc
   adc #$37		; PETSCII letters: A=$41, B=$42, etc.
@print:
   jsr CHROUT
   rts
