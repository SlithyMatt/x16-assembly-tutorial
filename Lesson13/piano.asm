.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

; Zero Page
ZP_PTR            = $30

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
VERA_dc_hscale    = $9F2A
VERA_dc_vscale    = $9F2B
DISPLAY_SCALE     = 64 ; 2X zoom

; Kernal
CHROUT                        := $FFD2
GETIN             = $FFE4


; VRAM Addresses
VRAM_psg          = $1F9C0

; --- PSG Values ---
; Frequencies:
C4                = 702
Db4               = 744
D4                = 788
Eb4               = 835
E4                = 885
F4                = 937
Gb4               = 993
G4                = 1052
Ab4               = 1115
A4                = 1181
Bb4               = 1251
B4                = 1326
C5                = 1405
; LR-Volume:
LR_VOLUME         = $FF ; L&R, max volume
; Waveform:
PULSE             = $3F
SAWTOOTH          = $7F
TRIANGLE          = $BF
NOISE             = $FF

; PETSCII
LEFT_CURSOR       = $9D


.macro RAM2VRAM ram_addr, vram_addr, num_bytes
   .scope
      ; set data port 0 to start writing to VRAM address
      stz VERA_ctrl
      lda #($10 | ^vram_addr) ; stride = 1
      sta VERA_addr_bank
      lda #>vram_addr
      sta VERA_addr_high
      lda #<vram_addr
      sta VERA_addr_low
       ; ZP pointer = start of video data in CPU RAM
      lda #<ram_addr
      sta ZP_PTR
      lda #>ram_addr
      sta ZP_PTR+1
      ; use index pointers to compare with number of bytes to copy
      ldx #0
      ldy #0
   vram_loop:
      lda (ZP_PTR),y
      sta VERA_data0
      iny
      cpx #>num_bytes ; last page yet?
      beq check_end
      cpy #0
      bne vram_loop ; not on last page, Y non-zero
      inx ; next page
      inc ZP_PTR+1
      bra vram_loop
   check_end:
      cpy #<num_bytes ; last byte of last page?
      bne vram_loop ; last page, before last byte
   .endscope
.endmacro

default_irq_vector: .addr 0
current_key: .byte 0
delay: .byte 0

start:
   ; scale display to 2x zoom (40x30 characters)
   lda #DISPLAY_SCALE
   sta VERA_dc_hscale
   sta VERA_dc_vscale

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

   lda #$20
   jsr CHROUT

@main_loop:
   wai
   lda #LEFT_CURSOR
   jsr CHROUT
   lda current_key
   jsr CHROUT
   bra @main_loop
   ; never return, just wait for reset

custom_irq_handler:
   lda VERA_isr
   and #VSYNC_BIT
   beq @continue ; non-VSYNC IRQ, no tick update

   jsr GETIN
   cmp #0
   bne @set_key
   lda delay
   beq @space
   dec delay
   bne @continue
@space:
   lda #$20
   sta current_key
   bra @continue
@set_key:
   sta current_key
   lda #10
   sta delay

@continue:
   ; continue to default IRQ handler
   jmp (default_irq_vector)
   ; RTI will happen after jump
