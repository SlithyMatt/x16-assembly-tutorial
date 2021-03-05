.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

; Kernal
CHROUT            = $FFD2

; PETSCII
RETURN            = $0D
CHAR_0            = $30

; globals
op1: .word 1234
op2: .word 5678
result: .dword 0
offset: .dword 0
bcd: .res 5
temp_word: .word 0
temp_byte: .byte 0

start:
   jsr multiply
   jsr print_result
   rts

multiply:
   lda op2
   sta result
   lda op2+1
   sta result+1
   stz result+2
   stz result+3
   stz offset
   stz offset+1
   stz offset+2
   stz offset+3
   lda op1
   sta temp_word
   lda op1+1
   sta temp_word+1
   beq @op1_byte
   ldy #16
@op1_word_exp_loop:
   dey
   asl temp_word+1
   bcc @op1_word_exp_loop
   sty temp_byte
   lda #16
   sec
   sbc temp_byte
   tax
@op1_word_remainder_loop:
   lsr temp_word+1
   dex
   bne @op1_word_remainder_loop
   bra @shift
@op1_byte:
   lda temp_word
   bne @set_op1_byte_exp
   stz result
   stz result+1
   jmp @return ; op1 = 0, result = zero
@set_op1_byte_exp:
   ldy #8
@op1_byte_exp_loop:
   dey
   asl temp_word
   bcc @op1_byte_exp_loop
   sty temp_byte
   lda #8
   sec
   sbc temp_byte
   tax
@op1_byte_remainder_loop:
   lsr temp_word
   dex
   bne @op1_byte_remainder_loop
@shift: ; Y = op1 exponent, temp_word = remainder
   cpy #0
   beq @remainder
   dey
   lsr temp_word+1
   ror temp_word
   bcc @shift_result
   ldx #0
   clc
   php
@add_offset:
   plp
   lda offset,x
   adc result,x
   sta offset,x
   php
   inx
   cpx #4
   bne @add_offset
   plp
@shift_result:
   asl result
   rol result+1
   rol result+2
   rol result+3
   bra @shift
@remainder:
   ldx #0
   clc
   php
@add_result:
   plp
   lda result,x
   adc offset,x
   sta result,x
   php
   inx
   cpx #4
   bne @add_result
   plp
@return:
   lda #RETURN
   jsr CHROUT
   rts

print_result:
   ; intialize BCD number to zero
   stz bcd
   stz bcd+1
   stz bcd+2
   stz bcd+3
   stz bcd+4
   ; convert 32-bit result to 10-digit BCD
   sed
   ldx #32
@main_loop:
   ; shift highest bit to C
   asl result
   rol result+1
   rol result+2
   rol result+3
   ldy #0
   ; BCD = BCD*2 + C
   php
@add_loop:
   plp
   lda bcd,y
   adc bcd,y
   sta bcd,y
   php
   iny
   cpy #5
   bne @add_loop
   plp
   dex
   bne @main_loop
   cld
   ; print BCD as PETSCII string
   ldy #4
@trim_lead:
   lda bcd,y
   bne @check_upper
   dey
   bne @trim_lead
   lda bcd,y
@check_upper:
   bit #$F0
   beq @print_lower
@print_upper:
   pha
   lsr
   lsr
   lsr
   lsr
   ora #CHAR_0
   jsr CHROUT
   pla
@print_lower:
   and #$0F
   ora #CHAR_0
   jsr CHROUT
@print_rest:
   dey
   bmi @return
   lda bcd,y
   bra @print_upper
@return:
   rts
