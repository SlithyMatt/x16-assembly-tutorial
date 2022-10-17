.org $080D
.segment "ONCE"
.segment "CODE"

; Zero Page
CODE = $30

; Kernal
CHRIN    = $FFCF
CHROUT   = $FFD2

; PETSCII
NEWLINE  = $0D
WHITE    = $05
SPACE    = $20
LT_RED   = $96
LT_GREEN = $99
LT_GRAY  = $9B

; Constants
MAX_INPUT = 40

   jmp start

input: .res MAX_INPUT
size: .byte 0

start:
   ldx #0
@read:
   jsr CHRIN
   cmp #NEWLINE
   beq @done
   sta input,x
   inx
   cpx #MAX_INPUT
   bne @read
@done:
   stx size
   lda #NEWLINE
   jsr CHROUT

   ldx #0
print:
   lda input,x
   sta CODE
   bit CODE
   bmi @gray
   bbs6 CODE,@green
   lda #LT_RED
   bra @print_code
@green:
   lda #LT_GREEN
   bra @print_code

@gray:
   lda #LT_GRAY
@print_code:
   jsr CHROUT
   lda CODE
   jsr CHROUT
   inx
   cpx size
   bmi print
   lda #NEWLINE
   jsr CHROUT

   lda #WHITE
   jsr CHROUT
   lda input
   sta CODE
   jsr print_hex
   lda #SPACE
   jsr CHROUT
   lda CODE
   jsr CHROUT
   lda #NEWLINE
   jsr CHROUT

   lda #$80
   tsb CODE
   beq @red
   lda #LT_GRAY
   bra @print_mod
@red:
   lda #LT_RED
@print_mod:
   jsr CHROUT
   lda CODE
   jsr print_hex
   lda #SPACE
   jsr CHROUT
   lda CODE
   jsr CHROUT

   lda #NEWLINE
   jsr CHROUT
   lda #LT_GREEN
   jsr CHROUT
   rmb7 CODE
   lda CODE
   jsr print_hex
   lda #SPACE
   jsr CHROUT
   lda CODE
   jsr CHROUT
   lda #WHITE
   jsr CHROUT
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
