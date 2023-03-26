.org $080D
.segment "ONCE"

CHROUT = $FFD2

   jmp start

foo: .word $1234
bar: .word $5678
result: .word 0
start:
   lda foo
   clc
   adc bar
   sta result
   lda foo+1
   adc bar+1
   sta result+1
   jsr print_hex
   lda result
   jsr print_hex
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
