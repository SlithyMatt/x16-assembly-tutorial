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
JOYSTICK_GET      = $FF56
CHROUT            = $FFD2
GETIN             = $FFE4

; PETSCII
SPACE             = $20
SPADE             = $41
CHAR_Q            = $51
CLR               = $93

; Colors
WHITE             = 1
BLUE              = 6

; Global Variables
paint_color:   .byte WHITE
brush_x:       .byte 0
brush_y:       .byte 0
painting:      .byte 0

start:
   ; clear screen
   lda #CLR
   jsr CHROUT

   ; enable VSYNC IRQ
   lda #VSYNC_BIT
   sta VERA_ien

   ; intiialize brush coordinates to 0,0
   stz brush_x
   stz brush_y

   ; not painting at first
   stz painting

main_loop:
   wai
   jsr GETIN
   cmp #CHAR_Q
   beq @exit ; exit on any key
   lda #SPACE
   jsr plot_char
   jsr handle_joystick
   lda #SPADE
   jsr plot_char
   bra main_loop
@exit:
   lda #CLR
   jsr CHROUT
   rts

plot_char:
   pha ; push PETSCII code to stack
   stz VERA_ctrl
   stz VERA_addr_bank ; stride = 0
   lda brush_y
   sta VERA_addr_high ; Y
   lda brush_x
   asl
   sta VERA_addr_low ; 2*X
   pla
   sta VERA_data0 ; PETSCII code
   inc VERA_addr_low ; move to colors
   lda VERA_data0
   bit painting
   bpl @set_fg
   lda paint_color
   asl
   asl
   asl
   asl
@set_fg:
   and #$F0
   ora paint_color
   sta VERA_data0
   rts

handle_joystick:
   lda #0
   jsr JOYSTICK_GET
   bit #$08
   beq @up
@check_down:
   bit #$04
   beq @down
@check_left:
   bit #$02
   beq @left
@check_right:
   bit #$01
   beq @right
   bra @check_start
@up:
   dec brush_y
   bpl @check_left
   stz brush_y
   bra @check_left
@down:
   inc brush_y
   ldy brush_y
   cpy #60
   bmi @check_left
   ldy #59
   sty brush_y
   bra @check_left
@left:
   dec brush_x
   bpl @check_start
   stz brush_x
   bra @check_start
@right:
   inc brush_x
   ldy brush_x
   cpy #80
   bmi @check_start
   ldy #79
   sty brush_x
@check_start:
   txa
   bit #$10
   bne @check_select
   lda painting
   eor #$80
   sta painting
@check_select:
   txa
   bit #$20
   bne @return
   lda paint_color
   inc
   and #$0F
   sta paint_color
@return:
   rts
