.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

; VERA
VERA_addr_low     = $9F20
VERA_addr_high    = $9F21
VERA_addr_bank    = $9F22
VERA_data0        = $9F23
VERA_data1        = $9F24
VERA_ctrl         = $9F25
VERA_ien          = $9F26
VSYNC_BIT         = $01

; VRAM Addresses
VRAM_psg          = $1F9C0

; Frequency
MIDDLE_C = 702
FREQ_STEP = 20


start:
   ; Initialize PSG channel 0
   stz VERA_ctrl
   lda #($10 | ^VRAM_psg) ; stride = 1
   sta VERA_addr_bank
   lda #>VRAM_psg
   sta VERA_addr_high
   lda #<VRAM_psg
   sta VERA_addr_low
   lda #<MIDDLE_C ; Frequency = 261.5 ~ Middle C
   sta VERA_data0
   lda #>MIDDLE_C
   sta VERA_data0
   lda #$FF ; L&R full volume
   sta VERA_data0
   lda #$3F ; Pulse, 50% width
   sta VERA_data0

   ; Enable only VSYNC IRQs
   lda #VSYNC_BIT
   sta VERA_ien

   ; slide pulse freq @ 50% PW
   jsr slide_freq

   ; slide PW @ Middle C
   stz VERA_ctrl
   lda #^VRAM_psg ; stride = 0
   sta VERA_addr_bank
   lda #>VRAM_psg
   sta VERA_addr_high
   lda #<(VRAM_psg + 3)
   sta VERA_addr_low
@pw_down_loop:
   wai
   wai
   dec VERA_data0
   bne @pw_down_loop
@pw_up_loop:
   wai
   wai
   inc VERA_data0
   lda VERA_data0
   cmp #$3F ; PW 50%
   bne @pw_up_loop

   ; switch to sawtooth
   lda #$40 ; Sawtooth
   sta VERA_data0

   ; slide sawtooth
   jsr slide_freq

   ; slide triangle
   stz VERA_ctrl
   lda #^VRAM_psg ; stride = 0
   sta VERA_addr_bank
   lda #>VRAM_psg
   sta VERA_addr_high
   lda #<(VRAM_psg + 3)
   sta VERA_addr_low
   lda #$80 ; Triangle
   sta VERA_data0
   jsr slide_freq

   ; slide noise
   stz VERA_ctrl
   lda #^VRAM_psg ; stride = 0
   sta VERA_addr_bank
   lda #>VRAM_psg
   sta VERA_addr_high
   lda #<(VRAM_psg + 3)
   sta VERA_addr_low
   lda #$C0 ; Noise
   sta VERA_data0
   jsr slide_freq

   ; shut off sound
   stz VERA_ctrl
   lda #^VRAM_psg ; stride = 0
   sta VERA_addr_bank
   lda #>VRAM_psg
   sta VERA_addr_high
   lda #<(VRAM_psg + 2) ; RL_Volume
   sta VERA_addr_low
   stz VERA_data0

   ; return to BASIC
   rts

slide_freq:
   stz VERA_ctrl ; data port 0 = freq lower byte
   lda #^VRAM_psg ; stride = 0
   sta VERA_addr_bank
   lda #>VRAM_psg
   sta VERA_addr_high
   lda #<VRAM_psg
   sta VERA_addr_low
   inc VERA_ctrl ; data port 1 = freq upper byte
   lda #^VRAM_psg ; stride = 0
   sta VERA_addr_bank
   lda #>VRAM_psg
   sta VERA_addr_high
   lda #<(VRAM_psg + 1)
   sta VERA_addr_low
   ldx #120 ; 120 ticks
@up_loop:
   wai
   lda VERA_data0
   clc
   adc #<FREQ_STEP
   sta VERA_data0
   lda VERA_data1
   adc #>FREQ_STEP
   sta VERA_data1
   dex
   bne @up_loop
   ; go back down
   ldx #120 ; 120 ticks
@down_loop:
   wai
   lda VERA_data0
   sec
   sbc #<FREQ_STEP
   sta VERA_data0
   lda VERA_data1
   sbc #>FREQ_STEP
   sta VERA_data1
   dex
   bne @down_loop
   rts
