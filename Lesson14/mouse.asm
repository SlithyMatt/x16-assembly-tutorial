.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

; Zero Page
ZP_PTR            = $30
MOUSE_X           = $32
MOUSE_Y           = $34

; VERA
VERA_addr_low     = $9F20
VERA_addr_high    = $9F21
VERA_addr_bank    = $9F22
VERA_data0        = $9F23
VERA_ctrl         = $9F25
VERA_ien          = $9F26
VSYNC_BIT         = $01

; Kernal
MOUSE_CONFIG      = $FF68
MOUSE_GET         = $FF6B
CHROUT            = $FFD2
GETIN             = $FFE4

; PETSCII
SPACE             = $20
LO_HALF_BLOCK     = $62
CLR               = $93
RT_HALF_BLOCK     = $E1
HI_HALF_BLOCK     = $E2
UL_UR_LR_QUAD     = $FB
UR_LL_LR_QUAD     = $FE

; Colors
WHITE             = 1
PINK              = 10

; Screen geometry
COLORBAR_END      = 5
CANVAS_START      = COLORBAR_END+1

; Global Variables
paint_color: .byte WHITE << 4
row_counter: .byte 0

start:
   ; clear screen
   lda #CLR
   jsr CHROUT

   ; enable VSYNC IRQ
   lda #VSYNC_BIT
   sta VERA_ien

   ; render palette selector
   stz VERA_ctrl
   lda #$10 ; stride = 1
   sta VERA_addr_bank
   stz VERA_addr_high
   stz VERA_addr_low
   ; Row 0: top border
   ldx #0
@top_border_loop:
   txa
   asl
   asl
   asl
   asl
   tay ; Y = color
   lda #HI_HALF_BLOCK
   sta VERA_data0
   sty VERA_data0
   sta VERA_data0
   sty VERA_data0
   sta VERA_data0
   sty VERA_data0
   sta VERA_data0
   sty VERA_data0
   lda #UL_UR_LR_QUAD
   sta VERA_data0
   sty VERA_data0
   inx
   cpx #16
   bne @top_border_loop
   ; Rows 1-4
   ldx #0
@middle_color_bar_loop:
   stz row_counter
   txa
   asl
   asl
   asl
   asl
   pha
   txa
   and #$0F
   bne @start_middle_row
   ; skip ahead to next row
   ldy #96
@skip_middle_row:
   lda VERA_data0
   dey
   bne @skip_middle_row
@start_middle_row:
   ply ; Y = color
   lda #SPACE
   sta VERA_data0
   sty VERA_data0
   sta VERA_data0
   sty VERA_data0
   sta VERA_data0
   sty VERA_data0
   sta VERA_data0
   sty VERA_data0
   lda #RT_HALF_BLOCK
   sta VERA_data0
   sty VERA_data0
   inx
   cpx #64
   bne @middle_color_bar_loop
   ; skip to last row
   ldy #96
@skip_last_row:
   lda VERA_data0
   dey
   bne @skip_last_row
   ; render last row
   ldx #0
@bottom_border_loop:
   txa
   asl
   asl
   asl
   asl
   tay ; Y = color
   lda #LO_HALF_BLOCK
   sta VERA_data0
   sty VERA_data0
   sta VERA_data0
   sty VERA_data0
   sta VERA_data0
   sty VERA_data0
   sta VERA_data0
   sty VERA_data0
   lda #UR_LL_LR_QUAD
   sta VERA_data0
   sty VERA_data0
   inx
   cpx #16
   bne @bottom_border_loop
   ; render canvas - all white spaces
REMAINDER = 48 + (60-COLORBAR_END)*128
   ldx #<REMAINDER
   ldy #>REMAINDER
@canvas_loop:
   lda #SPACE
   sta VERA_data0
   lda #(WHITE << 4)
   sta VERA_data0
   dex
   bne @canvas_loop
   cpy #0
   beq @init_select
   dey
   bra @canvas_loop

@init_select:
   ; initialize color selection
   lda #WHITE
   jsr select_color

   ; enable default mouse cursor
   lda #1
   tax
   jsr MOUSE_CONFIG

main_loop:
   jsr GETIN
   bne @exit ; exit on any key
   jsr get_mouse_xy
   bit #$1
   beq main_loop ; not left button
   cpy #CANVAS_START
   bpl @paint
   txa
   jsr div5
   jsr select_color
   bra main_loop
@paint:
   jsr paint_canvas
   bra main_loop
@exit:
   lda #CLR
   jsr CHROUT
   rts


select_color: ; Input: A = color
   bra @start
@color:           .res 1
@pink_bar_color:  .res 1
@pink_start_x:    .res 1
@old_color:       .res 1
@old_start_x:     .res 1
@start:
   sta @color
   lda paint_color
   sta @old_color ; previous color BG, black FG
   lda @color
   asl
   asl
   asl
   asl
   sta paint_color ; color << 4
   ora #PINK
   sta @pink_bar_color ; color BG, pink FG
   lda @color
   asl
   asl
   clc
   adc @color
   sta @pink_start_x ; color * 5
   lda @old_color
   lsr
   lsr
   sta @old_start_x
   lsr
   lsr
   clc
   adc @old_start_x
   sta @old_start_x ; previous color * 5
   ; make old bar bottom black
   stz VERA_ctrl
   lda #$20 ; stride = 2
   sta VERA_addr_bank
   lda #COLORBAR_END ; Y
   sta VERA_addr_high
   lda @old_start_x
   asl
   inc ; X * 2 + 1
   sta VERA_addr_low
   lda @old_color
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   ; make new bar bottom pink
   lda @pink_start_x
   asl
   inc ; X * 2 + 1
   sta VERA_addr_low
   lda @pink_bar_color
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   rts

get_mouse_xy: ; Output: A = button ID; X/Y = text map coordinates
   ldx #MOUSE_X
   jsr MOUSE_GET
   ; divide coordinates by 8
   lsr MOUSE_X+1
   ror MOUSE_X
   lsr MOUSE_X+1
   ror MOUSE_X
   lsr MOUSE_X+1
   ror MOUSE_X
   ldx MOUSE_X
   lsr MOUSE_Y+1
   ror MOUSE_Y
   lsr MOUSE_Y+1
   ror MOUSE_Y
   lsr MOUSE_Y+1
   ror MOUSE_Y
   ldy MOUSE_Y
   rts

div5: ; A = A / 5
   bra @start
@quot: .res 1
@rem:  .res 1
@start:
   sta @quot
   stz @rem
   ldx #8
@shift:
   asl @quot
   rol @rem
   lda @rem
   sec
   sbc #5
   bcc @next_shift
   sta @rem
   inc @quot
@next_shift:
   dex
   bne @shift
   lda @quot
   rts

paint_canvas: ; Input: X/Y = text map coordinates
   stz VERA_ctrl
   stz VERA_addr_bank ; stride = 0
   sty VERA_addr_high ; Y
   txa
   asl
   inc
   sta VERA_addr_low ; 2*X + 1
   lda paint_color
   sta VERA_data0
   rts
