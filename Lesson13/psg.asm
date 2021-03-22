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
VSYNC_BIT         = $01

; Kernal
CHROUT            = $FFD2

; VRAM Addresses
VRAM_psg          = $1F9C0

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
   lda #<START_FREQ
   stz VERA_data0
   lda #>START_FREQ
   stz VERA_data0
   lda #$FF ; L&R full volume
   sta VERA_data0
   lda #$3F ; Pulse, 50% width
   sta VERA_data0

   ; Enable only VSYNC IRQs
   lda #VSYNC_BIT
   sta VERA_ien

   ; slide Pulse @ 50% PW


   rts ; return to BASIC
