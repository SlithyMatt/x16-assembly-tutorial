.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

; RAM Interrupt Vectors
IRQVec            = $0314

; VERA
VERA_addr_low     = $9F20
VERA_addr_high    = $9F21
VERA_addr_bank    = $9F22
VERA_data0        = $9F23
VERA_ctrl         = $9F25
VERA_ien          = $9F26
VERA_isr          = $9F27
VSYNC_BIT         = $01
VERA_dc_video     = $9F29
VERA_dc_hscale    = $9F2A
VERA_dc_vscale    = $9F2B
DISPLAY_SCALE     = 64 ; 2X zoom
VERA_L0_config    = $9F2D
VERA_L0_tilebase  = $9F2F
VERA_L0_hscroll_h = $9F31
BITMAP_PAL_OFFSET = VERA_L0_hscroll_h

; Kernal
IOINIT            = $FF81
SETLFS            = $FFBA
SETNAM            = $FFBD
LOAD              = $FFD5
GETIN             = $FFE4

; PETSCII
CHAR_Q            = $51

; VRAM Addresses
VRAM_bitmap       = $04000
VRAM_palette      = $1FA00

; global data
default_irq_vector:  .addr 0
offset:              .byte 0
INIT_COUNTER = 15
counter:             .byte INIT_COUNTER
reverse:             .byte 0

bitmap_fn:           .byte "bitmap.bin"
end_bitmap_fn:

pal_fn:              .byte "pal.bin"
end_pal_fn:

palette_offset:      .res 32

start:
   stz VERA_dc_video ; disable display

   ; scale display to 2x zoom (320x240)
   lda #DISPLAY_SCALE
   sta VERA_dc_hscale
   sta VERA_dc_vscale

   ; configure layer 0
   lda #$06 ; 4bpp bitmap
   sta VERA_L0_config
   lda #(VRAM_bitmap >> 9) ; 320 pixel wide bitmap
   sta VERA_L0_tilebase
   stz BITMAP_PAL_OFFSET ; palette offset 0

   ; load bitmap to VRAM
   lda #1 ; logical number
   ldx #8 ; device number (SD Card / emulator host FS)
   ldy #0 ; secondary address (0 = ignore file header)
   jsr SETLFS
   lda #(end_bitmap_fn-bitmap_fn)
   ldx #<bitmap_fn
   ldy #>bitmap_fn
   jsr SETNAM
   lda #(^VRAM_bitmap + 2) ; VRAM bank + 2
   ldx #<VRAM_bitmap
   ldy #>VRAM_bitmap
   jsr LOAD

   ; load palette to VRAM
   lda #1 ; logical number
   ldx #8 ; device number (SD Card / emulator host FS)
   ldy #0 ; secondary address (0 = ignore file header)
   jsr SETLFS
   lda #(end_pal_fn-pal_fn)
   ldx #<pal_fn
   ldy #>pal_fn
   jsr SETNAM
   lda #(^VRAM_palette + 2) ; VRAM bank + 2
   ldx #<VRAM_palette
   ldy #>VRAM_palette
   jsr LOAD

   ; expand palette
   stz VERA_ctrl
   lda #($10 | ^VRAM_palette)
   sta VERA_addr_bank
   lda #>VRAM_palette
   sta VERA_addr_high
   lda #<VRAM_palette
   sta VERA_addr_low
   ; copy first 16 colors to RAM
   ldx #0
@copy_loop:
   lda VERA_data0
   sta palette_offset,x
   inx
   cpx #32
   bne @copy_loop
   ; fade each color
   ldy #4
@offset_loop:
   ldx #0
@fade_loop:
   lda palette_offset,x
   lsr
   and #$F7 ; divide each channel by 2
   sta palette_offset,x ; save for next offset
   sta VERA_data0 ; set in palette
   inx
   cpx #32
   bne @fade_loop
   dey
   bne @offset_loop

   ; enable layer 0
   lda #$11
   sta VERA_dc_video

   ; initialize globals
   stz offset
   lda #INIT_COUNTER
   sta counter
   stz reverse

   ; backup default RAM IRQ vector
   lda IRQVec
   sta default_irq_vector
   lda IRQVec+1
   sta default_irq_vector+1

   ; overwrite RAM IRQ vector with custom handler address
   sei ; disable IRQ while vector is changing
   lda #<custom_irq_handler
   sta IRQVec
   lda #>custom_irq_handler
   sta IRQVec+1
   lda #VSYNC_BIT ; make VERA only generate VSYNC IRQs
   sta VERA_ien
   cli ; enable IRQ now that vector is properly set

@main_loop:
   wai
   jsr GETIN
   cmp #CHAR_Q
   bne @main_loop
   ; Q pressed - restore IRQ vector
   sei
   lda default_irq_vector
   sta IRQVec
   lda default_irq_vector+1
   sta IRQVec+1
   cli
   ; reset VERA
   lda #$80
   sta VERA_ctrl
   jsr IOINIT
   ; return to BASIC
   rts


custom_irq_handler:
   lda VERA_isr
   and #VSYNC_BIT
   beq @continue ; non-VSYNC IRQ, no tick update

   dec counter
   bne @continue
   lda #INIT_COUNTER
   sta counter

   bit reverse
   bmi @decrement
   inc offset
   lda offset
   cmp #4
   bne @set_offset
   lda #$80
   sta reverse
   bra @set_offset
@decrement:
   dec offset
   bpl @set_offset
   stz offset
   stz reverse
@set_offset:
   lda offset
   sta BITMAP_PAL_OFFSET
@continue:
   ; continue to default IRQ handler
   jmp (default_irq_vector)
   ; RTI will happen after jump
