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
CHROUT            = $FFD2
GETIN             = $FFE4

; VRAM Addresses
CONTROLS_VRAM     = $00200
NUM_LABELS_VRAM   = CONTROLS_VRAM + $0207
KEYS_VRAM         = $00C00
VRAM_psg          = $1F9C0

; --- PSG Values ---
; Frequencies:
C4                = 702    ; 261.5 Hz
Db4               = 744    ; 277.2 Hz
D4                = 788    ; 293.6 Hz
Eb4               = 835    ; 311.1 Hz
E4                = 885    ; 329.7 Hz
F4                = 937    ; 349.1 Hz
Gb4               = 993    ; 369.9 Hz
G4                = 1052   ; 391.9 Hz
Ab4               = 1115   ; 415.4 Hz
A4                = 1181   ; 440.0 Hz
Bb4               = 1251   ; 466.0 Hz
B4                = 1326   ; 494.0 Hz
C5                = 1405   ; 523.4 Hz
; RL-Volume:
CHANNEL_ON        = $FF ; L&R, max volume
CHANNEL_OFF       = $00
; Waveform:
PULSE             = $3F    ; Pulse Width = 50%
SAWTOOTH          = $40
TRIANGLE          = $80
NOISE             = $C0

; PETSCII
COMMA             = $2C
CHAR_1            = $31
CHAR_Z            = $5A
CLR               = $93
LEFT_CURSOR       = $9D

; VRAM staging on RAM

.macro RAM2VRAM ram_addr, vram_addr, num_bytes, color
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
      lda #color  ; fill in second byte with specified color
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

controls:
.byte $20,$55,$43,$43,$43,$49,$20,$20,$20,$55,$43,$43,$43,$49,$20,$20,$20,$55,$43,$43,$43,$49,$20,$20,$20,$55,$43,$43,$43,$49,$20,$20,$20,$20,$55,$43,$43,$43,$49,$20
.res 88
.byte $20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$20,$42,$20,$20,$20,$42,$20
.res 88
.byte $20,$42,$20,$31,$20,$42,$20,$20,$20,$42,$20,$32,$20,$42,$20,$20,$20,$42,$20,$33,$20,$42,$20,$20,$20,$42,$20,$34,$20,$42,$20,$20,$20,$20,$42,$20,$11,$20,$42,$20
.res 88
.byte $20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$20,$42,$20,$20,$20,$42,$20
.res 88
.byte $20,$4A,$43,$43,$43,$4B,$20,$20,$20,$4A,$43,$43,$43,$4B,$20,$20,$20,$4A,$43,$43,$43,$4B,$20,$20,$20,$4A,$43,$43,$43,$4B,$20,$20,$20,$20,$4A,$43,$43,$43,$4B,$20
.res 88
.byte $20,$10,$15,$0C,$13,$05,$20,$20,$20,$13,$01,$17,$14,$2E,$20,$20,$20,$14,$12,$09,$01,$2E,$20,$20,$20,$0E,$0F,$09,$13,$05,$20,$20,$20,$20,$11,$15,$09,$14,$20,$20
end_controls:
CONTROLS_SIZE = end_controls-controls
CONTROLS_COLOR = $61 ; white on blue
HIGHLIGHT_COLOR = $21 ; white on red

keys:
.byte $20,$20,$20,$20,$70,$43,$43,$F8,$F8,$F8,$43,$F8,$F8,$F8,$43,$43,$72,$43,$43,$F8,$F8,$F8,$43,$F8,$F8,$F8,$43,$F8,$F8,$F8,$43,$43,$72,$43,$43,$43,$6E,$20,$20,$20
.res 88
.byte $20,$20,$20,$20,$42,$20,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$20,$42,$20,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20
.res 88
.byte $20,$20,$20,$20,$42,$20,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$20,$42,$20,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20
.res 88
.byte $20,$20,$20,$20,$42,$20,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$20,$42,$20,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20
.res 88
.byte $20,$20,$20,$20,$42,$20,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$20,$42,$20,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20
.res 88
.byte $20,$20,$20,$20,$42,$20,$20,$A0,$93,$A0,$20,$A0,$84,$A0,$20,$20,$42,$20,$20,$A0,$87,$A0,$20,$A0,$88,$A0,$20,$A0,$8A,$A0,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20
.res 88
.byte $20,$20,$20,$20,$42,$20,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$20,$42,$20,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$A0,$A0,$A0,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20
.res 88
.byte $20,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20
.res 88
.byte $20,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20
.res 88
.byte $20,$20,$20,$20,$42,$20,$1A,$20,$42,$20,$18,$20,$42,$20,$03,$20,$42,$20,$16,$20,$42,$20,$02,$20,$42,$20,$0E,$20,$42,$20,$0D,$20,$42,$20,$2C,$20,$42,$20,$20,$20
.res 88
.byte $20,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20,$42,$20,$20,$20
.res 88
.byte $20,$20,$20,$20,$6D,$43,$43,$43,$71,$43,$43,$43,$71,$43,$43,$43,$71,$43,$43,$43,$71,$43,$43,$43,$71,$43,$43,$43,$71,$43,$43,$43,$71,$43,$43,$43,$7D,$20,$20,$20
end_keys:
KEYS_SIZE = end_keys-keys
KEYS_COLOR = $10 ; black on white

; Global Variables
default_irq_vector: .addr 0
current_key: .byte 0
previous_key: .byte 0
delay: .byte 0
pulse_on: .byte 0
sawtooth_on: .byte 0
triangle_on: .byte 0
noise_on: .byte 0
frequency: .word 0


; key table: value, target address
key_table:
.word C5, set_freq         ; ,
.word 0, stop              ; -
.word 0, stop              ; .
.word 0, stop              ; /
.word 0, stop              ; 0
.word pulse_on, set_wf     ; 1
.word sawtooth_on, set_wf  ; 2
.word triangle_on, set_wf  ; 3
.word noise_on, set_wf     ; 4
.word 0, stop              ; 5
.word 0, stop              ; 6
.word 0, stop              ; 7
.word 0, stop              ; 8
.word 0, stop              ; 9
.word 0, stop              ; :
.word 0, stop              ; ;
.word 0, stop              ; <
.word 0, stop              ; =
.word 0, stop              ; >
.word 0, stop              ; ?
.word 0, stop              ; @
.word 0, stop              ; A
.word G4, set_freq         ; B
.word E4, set_freq         ; C
.word Eb4, set_freq        ; D
.word 0, stop              ; E
.word 0, stop              ; F
.word Gb4, set_freq        ; G
.word Ab4, set_freq        ; H
.word 0, stop              ; I
.word Bb4, set_freq        ; J
.word 0, stop              ; K
.word 0, stop              ; L
.word B4, set_freq         ; M
.word A4, set_freq         ; N
.word 0, stop              ; O
.word 0, stop              ; P
.word quit, 0              ; Q
.word 0, stop              ; R
.word Db4, set_freq        ; S
.word 0, stop              ; T
.word 0, stop              ; U
.word F4, set_freq         ; V
.word 0, stop              ; W
.word D4, set_freq         ; X
.word 0, stop              ; Y
.word C4, set_freq         ; Z


start:
   ; scale display to 2x zoom (40x30 characters)
   lda #DISPLAY_SCALE
   sta VERA_dc_hscale
   sta VERA_dc_vscale

   ; clear screen
   lda #CLR
   jsr CHROUT

   ; Initial display
   RAM2VRAM controls, CONTROLS_VRAM, CONTROLS_SIZE, CONTROLS_COLOR
   RAM2VRAM keys, KEYS_VRAM, KEYS_SIZE, KEYS_COLOR

   ; Initialize PSG channels
   stz VERA_ctrl
   lda #($10 | ^VRAM_psg) ; stride = 1
   sta VERA_addr_bank
   lda #>VRAM_psg
   sta VERA_addr_high
   lda #<VRAM_psg
   sta VERA_addr_low
   ; Channel 0: Pulse
   stz VERA_data0 ; freq = 0
   stz VERA_data0
   lda #CHANNEL_OFF ; turn off
   sta VERA_data0
   lda #PULSE ; set waveform
   sta VERA_data0
   ; Channel 1: Sawtooth
   stz VERA_data0 ; freq = 0
   stz VERA_data0
   lda #CHANNEL_OFF ; turn off
   sta VERA_data0
   lda #SAWTOOTH ; set waveform
   sta VERA_data0
   ; Channel 2: Triangle
   stz VERA_data0 ; freq = 0
   stz VERA_data0
   lda #CHANNEL_OFF ; turn off
   sta VERA_data0
   lda #TRIANGLE ; set waveform
   sta VERA_data0
   ; Channel 3: Noise
   stz VERA_data0 ; freq = 0
   stz VERA_data0
   lda #CHANNEL_OFF ; turn off
   sta VERA_data0
   lda #NOISE ; set waveform
   sta VERA_data0

   ; set default waveform to Pulse only
   lda #$80
   sta pulse_on
   stz sawtooth_on
   stz triangle_on
   stz noise_on
   jsr highlight_wfs

   ; clear key values
   stz current_key

   ; Initialize IRQ handling
   jsr init_irq

   ; clear screen
   lda #$20
   jsr CHROUT

main_loop:
   wai ; wait for next IRQ
   lda current_key
   beq stop ; current key is NULL
   cmp #(CHAR_Z + 1)
   bpl stop ; current key code > 'Z'
   sec
   sbc #COMMA ; key offset = code - ','
   bcc stop ; current key code < ','
   asl
   asl
   tax ; X = key offset * 4
   ; store value in ZP_PTR
   lda key_table,x
   sta ZP_PTR
   inx
   lda key_table,x
   sta ZP_PTR+1
   ; jump to target
   inx
   jmp (key_table,x)

stop:
   jsr stop_subroutine
   jmp main_loop

stop_subroutine:
   stz VERA_ctrl
   lda #($30 | ^VRAM_psg) ; stride = 4 (set one byte per channel)
   sta VERA_addr_bank
   lda #>VRAM_psg
   sta VERA_addr_high
   lda #<(VRAM_psg + 2) ; RL-Volume byte
   sta VERA_addr_low
   lda CHANNEL_OFF
   sta VERA_data0 ; turn off channel 0
   sta VERA_data0 ; turn off channel 1
   sta VERA_data0 ; turn off channel 2
   sta VERA_data0 ; turn off channel 3
   rts

.macro SET_FREQ_CHANNEL flag
   .scope
      bit flag
      bpl skip_channel
      lda ZP_PTR ; frequency, low byte
      sta VERA_data0
      lda ZP_PTR+1 ; frequency, high byte
      sta VERA_data0
      lda #CHANNEL_ON
      sta VERA_data0
      bra skip_waveform
   skip_channel:
      lda VERA_data0
      lda VERA_data0
      lda VERA_data0
   skip_waveform:
      lda VERA_data0
   .endscope
.endmacro

set_freq:
   stz VERA_ctrl
   lda #($10 | ^VRAM_psg) ; stride = 1
   sta VERA_addr_bank
   lda #>VRAM_psg
   sta VERA_addr_high
   lda #<VRAM_psg
   sta VERA_addr_low
   ; play frequency on each enabled channel based on flag
   SET_FREQ_CHANNEL pulse_on
   SET_FREQ_CHANNEL sawtooth_on
   SET_FREQ_CHANNEL triangle_on
   SET_FREQ_CHANNEL noise_on
   jmp main_loop

set_wf:
   jsr stop_subroutine
   lda current_key
   sec
   sbc #CHAR_1
   asl
   tax ; X = current_key offset * 2
   lda (ZP_PTR)
   eor #$80 ; toggle the high bit
   sta (ZP_PTR)
   stz current_key ; clear key state
   jsr highlight_wfs
   jmp main_loop

.macro HIGHLIGHT_WF flag
   .scope
      bit flag ; highlight if flag & $80
      bpl clear
      lda #HIGHLIGHT_COLOR
      bra set
   clear:
      lda #CONTROLS_COLOR
   set:
      sta VERA_data0
   .endscope
.endmacro

highlight_wfs:
   stz VERA_ctrl
   lda #($50 | ^NUM_LABELS_VRAM) ; stride = 16 (set every 8th color)
   sta VERA_addr_bank
   lda #>NUM_LABELS_VRAM
   sta VERA_addr_high
   lda #<NUM_LABELS_VRAM
   sta VERA_addr_low
   ; highlight each waveform based on its flag
   HIGHLIGHT_WF pulse_on
   HIGHLIGHT_WF sawtooth_on
   HIGHLIGHT_WF triangle_on
   HIGHLIGHT_WF noise_on
   rts

quit:
   jsr stop_subroutine
   rts ; return to BASIC

init_irq:
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
   rts

custom_irq_handler:
   lda VERA_isr
   and #VSYNC_BIT
   beq @continue ; non-VSYNC IRQ, no tick update
   ; Check keyboard buffer
   jsr GETIN
   cmp #0
   bne @set_key ; new PETSCII code available
   lda delay ; no new code, check if under delay
   beq @null ; delay already expired, set current key to NULL
   dec delay ; decrement delay counter
   bne @continue ; still under delay, keep current key code
@null: ; delay expired
   stz current_key ; current key = NULL
   bra @continue
@set_key:
   sta current_key ; set new key code
   lda #16 ; start delay counter
   sta delay
@continue:
   ; continue to default IRQ handler
   jmp (default_irq_vector)
   ; RTI will happen after jump
