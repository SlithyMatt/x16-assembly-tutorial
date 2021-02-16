.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

; Zero Page
ZP_PTR            = $30

; VERA
VERA_addr_low     = $9F20
VERA_addr_high    = $9F21
VERA_addr_bank    = $9F22
VERA_data0        = $9F23
VERA_data1        = $9F24
VERA_ctrl         = $9F25
VERA_dc_video     = $9F29
VERA_dc_hscale    = $9F2A
VERA_dc_vscale    = $9F2B
VERA_L0_config    = $9F2D
VERA_L0_mapbase   = $9F2E
VERA_L0_tilebase  = $9F2F
VERA_L1_config    = $9F34
VERA_L1_mapbase   = $9F35
VERA_L1_tilebase  = $9F36

; VRAM Addresses
VRAM_layer1_map   = $00000
VRAM_layer0_map   = $04000
VRAM_lowerchars   = $0F000
VRAM_lower_rev    = VRAM_lowerchars + 128*8
VRAM_petscii      = $0F800
VRAM_palette      = $1FA00

; ROM Banks
ROM_BANK          = $9F60
BASIC_BANK        = 4
CHARSET_BANK      = 6

; Character Set ROM
LOWER_UPPER       = $C400

; Kernal
CHROUT            = $FFD2

; PETSCII Codes
WHITE             = $05
RETURN            = $0D
SPACE             = $20
ZERO_CHAR         = $30
SIX_CHAR          = $36
NINE_CHAR         = $39
C_CHAR            = $43
I_CHAR            = $49
O_CHAR            = $4F
P_CHAR            = $50
Q_CHAR            = $51
R_CHAR
S_CHAR            = $53
T_CHAR            = $54
CLR               = $93

; Screen Codes
REVERSE           = $80

; globals:
text_colors: .byte $61

   jmp start

smile:
.byte %00111100
.byte %01000010
.byte %10100101
.byte %10000001
.byte %10100101
.byte %10011001
.byte %01000010
.byte %00111100

email: .asciiz "matt@slithygames.com"
hidden: .asciiz "SECRET MESSAGE!"

start:
   ; clear screen, set text to white
   lda #CLR
   jsr CHROUT
   lda #WHITE
   jsr CHROUT

   ; print text lines
   ldx #0
@email_loop:
   lda email,x
   beq @done_email
   jsr CHROUT
   inx
   bra @email_loop
@done_email:
   lda #RETURN
   jsr CHROUT
   ldx #0
@hidden_loop:
   lda hidden,x
   beq @done_hidden
   jsr CHROUT
   inx
   bra @hidden_loop
@done_hidden:
   lda #RETURN
   jsr CHROUT

   ; Copy Lower/Upper character set from ROM (1kB) to VRAM
   lda #CHARSET_BANK
   sta ROM_BANK
   lda #<LOWER_UPPER
   sta ZP_PTR
   lda #>LOWER_UPPER
   sta ZP_PTR+1
   stz VERA_ctrl  ; Port 0: Standard glyphs copied from ROM
   lda #($10 | ^VRAM_lowerchars) ; Stride = 1
   sta VERA_addr_bank
   lda #>VRAM_lowerchars
   sta VERA_addr_high
   stz VERA_addr_low
   lda #1
   sta VERA_ctrl ; Port 1: Reverse glyphs inverted from ROM
   lda #($10 | ^VRAM_lower_rev) ; Stride = 1
   sta VERA_addr_bank
   lda #>VRAM_lower_rev
   sta VERA_addr_high
   lda #<VRAM_lower_rev
   sta VERA_addr_low
   ldx #4
   ldy #0
@copy_char_loop:
   lda (ZP_PTR),y
   sta VERA_data0 ; original pixel row
   eor #$FF
   sta VERA_data1 ; inverted pixel row
   iny
   bne @copy_char_loop
   dex
   bne @copy_char_loop

   ; Configure Layer 0: 256-color text, Upper/Graphics PETSCII
   lda #$68 ; 128x64, 256-color text
   sta VERA_L0_config
   lda #(VRAM_layer0_map >> 9)
   sta VERA_L0_mapbase
   lda #(VRAM_petscii >> 9)
   sta VERA_L0_tilebase

   ; Populate Layer 0: Palette as reverse spaces
   stz VERA_ctrl
   lda #($10 | ^VRAM_layer0_map)
   sta VERA_addr_bank
   lda #>VRAM_layer0_map
   sta VERA_addr_high
   stz VERA_addr_low
   ldx #0
   ldy #16
@pal_loop:
   lda #(REVERSE | SPACE)
   sta VERA_data0 ; screen code: reversed space (all foreground)
   stx VERA_data0 ; color index
   inx
   beq @check_keyboard
   dey
   bne @pal_loop
   inc VERA_addr_high
   stz VERA_addr_low
   bra @pal_loop

@check_keyboard:
   ; poll keyboard for input
   jsr GETIN
   cmp #0
   beq @check_keyboard
   cmp #ZERO_CHAR
   bmi @check_keyboard
   cmp #(NINE_CHAR+1)
   bpl @check_c
   jsr set_color
   bra @check_keyboard
@check_c:
   cmp #CHAR_C
   bne @check_i
   jsr toggle_color1
   bra @check_keyboard
@check_i:
   cmp #CHAR_I
   bne @check_jump
   jsr zoom_in
   bra @check_keyboard
@check_jump:
   cmp #(CHAR_T+1)
   bpl @check_keyboard
   sec
   sbc #CHAR_O
   asl ; A = (character code - 'O')*2
   tax
   jmp (@jump_table,x)
@jump_table:
.addr @zoom_out        ; O
.addr @toggle_layer0   ; P
.addr @return          ; Q
.addr @toggle_charset  ; R
.addr @make_smile      ; S
.addr @toggle_layer1   ; T
@zoom_out:
   jsr zoom_out
   bra @check_keyboard
@toggle_layer0:
   jsr toggle_layer0
   bra @check_keyboard
@toggle_layer1:
   jsr toggle_layer1
   bra @check_keyboard
@toggle_charset:
   jsr toggle_charset
   bra @check_keyboard
@make_smile:
   jsr make_smile
   bra @check_keyboard
@return:
   rts

; '0'-'9' in A
set_color:
   cmp #ZERO_CHAR
   beq @set_background
   cmp #SIX_CHAR
   bpl @set_background
   bra @set_foreground
@set_background:
   asl
   asl
   asl
   asl
   tay
   lda text_colors
   and #$0F
@set_colors:
   sta text_colors
   tya
   ora text_colors
   sta text_colors
   tay ; Y = text colors
   bra @start
@set_foreground:
   and #$0F
   tya
   lda text_colors
   and #$F0
   bra @set_colors
@start:
   stz VERA_ctrl
   lda #($20 | ^VRAM_layer1_map) ; stride = 1
   sta VERA_addr_bank
   lda #>VRAM_layer1_map
   sta VERA_addr_high
   lda #(<VRAM_layer1_map + 1) ; starting with second byte of map
   sta VERA_addr_low
   ldx #0
@loop:
   sty VERA_data0
   inx
   bne @loop ; do 256 iterations (2 rows)
   rts

zoom_in:
   lda VERA_dc_hscale
   cmp #1 ; maximum zoom level
   bmi @return
   lsr VERA_dc_hscale
   lsr VERA_dc_vscale
@return:
   rts

zoom_out:
   lda VERA_dc_hscale
   cmp #128 ; zoom level = 100%
   bpl @return
   asl VERA_dc_hscale
   asl VERA_dc_vscale
@return:
   rts

toggle_color1:
   stz VERA_ctrl
   lda #^(VRAM_palette) ;  no stride
   sta VERA_addr_bank
   lda #>(VRAM_palette)
   sta VERA_addr_high
   lda #<(VRAM_palette+2) ; third byte of palette
   sta VERA_addr_low
   lda VERA_data0 ; low byte (green, blue)
   eor #$FF
   sta VERA_data0 ; invert blue, green
   inc VERA_addr_low ; fourth byte of palette
   lda VERA_data0 ; high byte (-, red)
   eor #$0F
   sta VERA_data0 ; invert red
   rts

toggle_layer0:
   lda VERA_dc_video
   eor #$10
   sta VERA_dc_video ; toggle "Layer 0 Enable" bit
   rts

toggle_layer1:
   lda VERA_dc_video
   eor #$20
   sta VERA_dc_video ; toggle "Layer 1 Enable" bit
   rts

toggle_charset:

   rts

make_smile:

   rts
