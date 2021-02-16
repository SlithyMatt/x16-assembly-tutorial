.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

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
VERA_L1_config    = $9F34
VERA_L1_mapbase   = $9F35
VERA_L1_tilebase  = $9F36

; VRAM Addresses
VRAM_layer1_map   = $00000
VRAM_layer0_map   = $04000
VRAM_lowerchars   = $0F000
VRAM_petscii      = $0F800
VRAM_palette      = $1FA00

; Kernal
CHROUT            = $FFD2

; PETSCII Codes
RETURN            = $0D
CLR               = $93

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
   ; clear screen
   lda #CLR
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

   ; Copy Lower/Upper character set from ROM to VRAM
   



   rts
