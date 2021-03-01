.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

; Zero Page
STR_PTR           = $30
NUM_PTR           = $32

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

.

; globals
op1: .word 0
op2: .word 0
op_string: .res 5
op_string_null: .byte 0 ; make sure op_string is null-terminated
op_binary: .word 0
bcd: .res 5
operator: .byte 0
result: .dword 0

; prompts
op1_prompt:       .asciiz "enter 1st operand: "
op2_prompt:       .asciiz "enter 2nd operand: "
operator_prompt:  .asciiz "enter operator:    "
result_prompt:    .asciiz "result is:         "
num_error_prompt: .asciiz "must be a number:  "
sym_error_prompt: .asciiz "must be +,-,/,*:   "

start:
   PRINT_STRING op1_prompt
   jsr get_operand


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

get_operand:
   pha
   phy
   lda #<op_string
   sta STR_PTR
   lda #>op_string
   sta STR_PTR+1
   ldy #0
@input_loop:
   phy
   jsr CHRIN
   ply
   cmp #0
   beq @input_done
   sta (STR_PTR),y
   iny
   cpy #5
   bne @input_loop
@flush:
   jsr CHRIN
   cmp #0
   bne @flush
@input_done: ; A = 0, y <= 5
   sta (STR_PTR),y ; null termination
   ; check for number
   ldy #0
@check_loop:
   lda (STR_PTR),y
   cmp #0
   beq @check_empty
   cmp #CHAR_0
   bmi @error
   cmp #(CHAR_9 + 1)
   bpl @error
   iny
   bra @check_loop
@check_empty
   cpy #0
   bne @convert
@error:
   PRINT_STRING num_error_prompt
   jmp @input_loop
@convert:
   ; find end of string
   ldy #1
@end_loop:
   lda (STR_PTR),y
   iny
   cmp #0
   bne @end_loop
   dey
   dey ; y = last number character index
   ldx #0
   lda #<op_binary
   sta NUM_PTR
   lda #>op_binary
   sta NUM_PTR+1
@conv_loop:
   lda (STR_PTR),y
   and #$0F
   sta NUM_PTR,x
   cpy #0
   beq @fill
   dey
   lda (STR_PTR),y
   asl
   asl
   asl
   asl
   ora NUM_PTR,x
   sta NUM_PTR,x
   cpy #0
   beq @fill
   dey
   inx
   bra @conv_loop
@fill:

@done:
   ply
   pla
   rts
