.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

; Zero Page
ZP_PTR   = $30

; Kernal
SETLFS   = $FFBA
SETNAM   = $FFBD
CHRIN    = $FFCF
CHROUT   = $FFD2
LOAD     = $FFD5
SAVE     = $FFD8
GETIN    = $FFE4
SCREEN   = $FFED
PLOT     = $FFF0

; VERA
DC_HSCALE   = $9F2A
DC_VSCALE   = $9F2B

; PETSCII
RETURN      = $0D
SPACE       = $20
COLON       = $3A
CLR         = $93

; Constants
SCALE_2X    = 64
STR_MAX     = 10

.macro PRINT_LINE row, letter, str_addr
   clc ; Set cursor position
   ldx #row ; row
   ldy #5   ; column
   jsr PLOT
   lda #letter
   jsr CHROUT
   lda #COLON
   jsr CHROUT
   lda #SPACE
   jsr CHROUT
   ldx #0
:  lda str_addr,x
   jsr CHROUT
   inx
   cpx #STR_MAX
   bne :-
.endmacro

   jmp start

filename: .byte "abc"
end_filename:

a_str: .res STR_MAX, SPACE
b_str: .res STR_MAX, SPACE
c_str: .res STR_MAX, SPACE
end_strings:

start:
   jsr SCREEN
   cpx #40
   beq @check_height
   lda #SCALE_2X
   sta DC_HSCALE ; set horizontal scale to 2x (40 columns)
@check_height:
   cpy #30
   beq @load_file
   lda #SCALE_2X
   sta DC_VSCALE ; set vertical scale to 2x (30 rows)
@load_file:
   lda #1   ; Logical Number = 1
   ldx #8   ; Device = "SD card" (emulation host FS)
   ldy #0   ; Secondary Address = 0
   jsr SETLFS
   lda #(end_filename-filename) ; filename length
   ldx #<filename
   ldy #>filename
   jsr SETNAM
   lda #0   ; load
   ldx #<a_str
   ldy #>a_str
   jsr LOAD
   jsr draw_screen
@main_loop:
   jsr GETIN
   cmp #0
   beq @main_loop
   cmp #$51 ; Q
   beq @quit
   cmp #$41 ; A
   beq @enter_a
   cmp #$42 ; B
   beq @enter_b
   cmp #$43 ; C
   bne @main_loop
   ldx #15
   lda #<c_str
   sta ZP_PTR
   lda #>c_str
   sta ZP_PTR+1
   bra @input
@enter_a:
   ldx #5
   lda #<a_str
   sta ZP_PTR
   lda #>a_str
   sta ZP_PTR+1
   bra @input
@enter_b:
   ldx #10
   lda #<b_str
   sta ZP_PTR
   lda #>b_str
   sta ZP_PTR+1
@input:
   clc
   ldy #8
   jsr PLOT
   ldy #0
@input_loop:
   jsr CHRIN
   cmp #RETURN
   beq @redraw
   sta (ZP_PTR),y
   iny
   cpy #STR_MAX
   bne @input_loop
@redraw:
   jsr draw_screen
   jmp @main_loop
@quit:
   ; save bytes between a_str and end_strings to file
   lda #<a_str
   sta ZP_PTR
   lda #>a_str
   sta ZP_PTR+1
   lda #ZP_PTR
   ldx #<end_strings
   ldy #>end_strings
   jsr SAVE
   rts

draw_screen:
   lda #CLR
   jsr CHROUT
   PRINT_LINE 5, $41, a_str
   PRINT_LINE 10, $42, b_str
   PRINT_LINE 15, $43, c_str
   rts
