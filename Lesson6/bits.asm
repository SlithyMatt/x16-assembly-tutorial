.org $080D
.segment "STARTUP"
.segment "INIT"
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

   ldx #0
print:
   lda input,x
   sta CODE
   bbs6 CODE,@check5
   lda #LT_RED
   bra @print_code
@check5:
   bbs5 CODE,@gray
   lda #LT_GREEN
   bra @print_code
@gray:
   lda #LT_GRAY
@print_code:
   jsr CHROUT
   lda CODE
   jsr CHROUT
   lda #NEWLINE
   jsr CHROUT

   lda #WHITE
   jsr CHROUT
   lda input
   sta CODE
   jsr print_hex
   lda #NEWLINE
   jsr CHROUT
   lda #$80
   tsb CODE
   beq @red
   lda #LT_GRAY
   bra @print_mod
   lda #LT_RED
@print_mod
   jsr CHROUT
   lda CODE
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
