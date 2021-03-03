.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

; Zero Page
STR_PTR           = $30

; Kernal
CHRIN             = $FFCF
CHROUT            = $FFD2

; PETSCII
RETURN            = $0D
ASTERIX           = $2A
PLUS              = $2B
HYPHEN            = $2D
SLASH             = $2F
CHAR_0            = $30
CHAR_9            = $39

.macro PRINT_STRING string
   pha
   lda #<string
   sta STR_PTR
   lda #>string
   sta STR_PTR+1
   jsr print_str
   pla
.endmacro


; globals
op1: .word 0
op2: .word 0
op_string: .res 5
op_string_null: .byte 0 ; make sure op_string is null-terminated
op_binary: .word 0
bcd: .res 5
operator: .byte 0
result: .dword 0
offset: .dword 0
temp_word: .word 0
temp_byte: .byte 0

; prompts
op1_prompt:       .asciiz "enter 1st operand: "
op2_prompt:       .asciiz "enter 2nd operand: "
operator_prompt:  .asciiz "enter operator:    "
result_prompt:    .asciiz "result is:         "
num_error_prompt: .asciiz "must be a number:  "
sym_error_prompt: .asciiz "must be +,-,/,*:   "
div0_error:       .asciiz "error: divide by zero"

start:
   PRINT_STRING op1_prompt
   jsr get_operand
   lda op_binary
   sta op1
   lda op_binary+1
   sta op1+1
   PRINT_STRING op2_prompt
   jsr get_operand
   lda op_binary
   sta op2
   lda op_binary+1
   sta op2+1
   PRINT_STRING operator_prompt
@get_operator:
   jsr CHRIN
   cmp #PLUS
   beq @add
   cmp #HYPHEN
   beq @subtract
   cmp #ASTERIX
   beq @multiply
   cmp #SLASH
   beq @divide
   jsr flush_chrin
   PRINT_STRING sym_error_prompt
   bra @get_operator
@add:
   jsr add
   bra @done
@subtract:
   jsr subtract
   bra @done
@multiply:
   jsr multiply
   bra @done
@divide:
   jsr divide
@done:
   jsr print_result
   rts

print_str: ; STR_PTR = address of null-terminated string
   phy
   ldy #0
@loop:
   lda (STR_PTR),y
   beq @done
   jsr CHROUT
   iny
   bra @loop
@done:
   ply
   rts

flush_chrin:
   jsr CHRIN
   cmp #RETURN
   bne flush_chrin
   rts

get_operand:
   pha
   phx
   phy
   ldx #0
@input_loop:
   jsr CHRIN
   cmp #RETURN
   beq @input_done
   sta op_string,x
   inx
   cpx #5
   bne @input_loop
   jsr flush_chrin
@input_done: ; A = RETURN
   jsr CHROUT
   stz op_string,x ; null termination
   ; check for number
   ldx #0
@check_loop:
   lda op_string,x
   cmp #0
   beq @check_empty
   cmp #CHAR_0
   bmi @error
   cmp #(CHAR_9 + 1)
   bpl @error
   inx
   bra @check_loop
@check_empty:
   cpx #0
   bne @convert
@error:
   PRINT_STRING num_error_prompt
   jmp @input_loop
@convert:
   ldx #0
   stz op_binary
   stz op_binary+1
@conv_loop:
   lda op_string,x
   beq @done
   ; new digit, multiply op_binary by 10
   asl op_binary
   rol op_binary+1
   lda op_binary
   ; multiplied by 2 - save value in temp variable
   sta temp_word
   lda op_binary+1
   sta temp_word+1
   ; continue shifting two more bits to multiply by 8
   asl op_binary
   rol op_binary+1
   asl op_binary
   rol op_binary+1
   ; now add x2 value to x8 value to get x10 value
   lda op_binary
   clc
   adc temp_word
   sta op_binary
   lda op_binary+1
   adc temp_word+1
   sta op_binary+1
   ; now add digit from string
   lda op_string,x
   and #$0F ; zero out upper nybble to get digit numerical value
   clc
   adc op_binary
   sta op_binary
   lda op_binary+1
   adc #0 ; let carry happen, if necessary
   sta op_binary+1
   inx
   bra @conv_loop
@done:
   ply
   plx
   pla
   rts

add:
   jsr flush_chrin
   stz result+2
   stz result+3
   lda op1
   clc
   adc op2
   sta result
   lda op1+1
   adc op2+1
   sta result+1
   rol result+2
   rts

subtract:
   jsr flush_chrin
   lda op1
   sec
   sbc op2
   sta result
   lda op1+1
   sbc op2+1
   sta result+1
   bmi @negative
   stz result+2
   stz result+3
   bra @return
@negative:
   lda #$FF
   sta result+2
   sta result+3
@return:
   rts

print_result:
   lda #RETURN
   jsr CHROUT
   PRINT_STRING result_prompt
   ; intialize BCD number to zero
   stz bcd
   stz bcd+1
   stz bcd+2
   stz bcd+3
   stz bcd+4
   ; check for negative
   bit result+3
   bpl @convert
   ; subtract from zero to get negated value
   lda #0
   sec
   sbc result
   sta result
   lda #0
   sbc result+1
   sta result+1
   lda #0
   sbc result+2
   sta result+2
   lda #0
   sbc result+3
   sta result+3
   lda #HYPHEN
   jsr CHROUT
@convert:
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
   lda #RETURN
   jsr CHROUT
   rts

multiply:
   jsr flush_chrin
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
@set_op1_word_exp:
   ldy #15
   asl temp_word+1
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

divide: ; output: result = quotient, offset = remainder
   jsr flush_chrin
   stz result+2
   stz result+3
   stz offset
   stz offset+1
   lda op2
   bne @valid
   lda op2+1
   bne @valid
   ; divide by zero: set result to 0 and print error
   stz result
   stz result+1
   lda #RETURN
   jsr CHROUT
   PRINT_STRING div0_error
   jmp @return
@valid:
   ; copy op1 (dividend) to result
   lda op1
   sta result
   lda op1+1
   sta result+1
   ; copy op2 (divisor) to temp_word
   lda op2
   sta temp_word
   lda op2+1
   sta temp_word+1
   ; shift dividend out of result, replacing with quotient
   ldx #16
@shift:
   ; shift result left into offset
   asl result     ; make room for quotient
   rol result+1   ; top bit of result (dividend) shifted to C
   rol offset     ; C shifted into bottom bit of offset (remainder)
   rol offset+1
   lda offset
   sec            ; try subtracting temp_word (divisor) from offset (remainder)
   sbc temp_word
   tay            ; y = low byte difference
   lda offset+1
   sbc temp_word+1
   bcc @next_shift ; if C cleared, subtraction failed, do next shift
   sta offset+1    ; C still set, save difference in offset (remainder)
   sty offset
   inc result     ; finally, set a bit in result (quotient)
@next_shift:
   dex
   bne @shift
@return:
   rts
