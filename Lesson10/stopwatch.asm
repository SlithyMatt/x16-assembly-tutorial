.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

; Zero Page
ZP_PTR            = $30

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
DISPLAY_SCALE     = 32 ; 4X zoom

; ROM
CHROUT            = $FFD2
GETIN             = $FFE4
PLOT              = $FFF0
IRQ_VECTOR        = $FFFE ; Fixed for 65C02

; PETSCII
CHAR_0            = $30
COLON             = $3A
CHAR_Q            = $51
CHAR_R            = $52
CHAR_S            = $53
CLR               = $93

; constants
DISPLAY_X         = 6
DISPLAY_Y         = 14

; globals
default_irq_vector: .addr 0
ticks: .byte 0
seconds: .byte 0
minutes: .byte 0

; macros
.macro PRINT_DECIMAL num
   lda num
   lsr
   lsr
   lsr
   lsr
   ora #CHAR_0
   sta VERA_data0
   lda num
   and #$0F
   ora #CHAR_0
   sta VERA_data0
.endmacro

.macro PRINT_DISPLAY
   stz VERA_ctrl
   lda #$20 ; stride = 2
   sta VERA_addr_bank
   lda #DISPLAY_Y
   sta VERA_addr_high
   lda #(DISPLAY_X * 2)
   sta VERA_addr_low
   PRINT_DECIMAL minutes
   lda #COLON
   sta VERA_data0
   PRINT_DECIMAL seconds
   lda #COLON
   sta VERA_data0
   PRINT_DECIMAL ticks
.endmacro

start:
   ; backup ROM IRQ vector to ZP pointer
   lda IRQ_VECTOR
   sta ZP_PTR
   lda IRQ_VECTOR+1
   sta ZP_PTR+1

   ; backup default RAM IRQ vector to call from custom handler
   lda (ZP_PTR)
   sta default_irq_vector
   ldy #1
   lda (ZP_PTR),y
   sta default_irq_vector+1

   ; disable IRQ while vector is changing
   sei

   ; overwrite RAM IRQ vector with custom handler address
   lda #<custom_irq_handler
   sta (ZP_PTR)
   lda #>custom_irq_handler
   sta (ZP_PTR),y

   ; disable VERA VSYNC interrupts
   lda VERA_ien
   and #(VSYNC_BIT ^ $FF) ; clear VSYNC bit
   sta VERA_ien

   ; enable IRQ now that vector is properly set
   cli

   ; Initialize counters and display
   lda #CLR
   jsr CHROUT ; clear display
   lda #DISPLAY_SCALE
   sta VERA_dc_hscale
   sta VERA_dc_vscale ; zoom level set
   stz minutes
   stz seconds
   stz ticks   ; time reset to 00:00:00
   PRINT_DISPLAY

@loop:
   jsr GETIN
   cmp #0
   beq @loop ; no input
   cmp #CHAR_R
   beq @reset ; R = reset
   cmp #CHAR_S
   beq @start_stop ; S = start/stop
   cmp #CHAR_Q
   beq @return ; Q = quit
   bra @loop ; unexpected code, ignore
@reset:
   cli ; disable interrupts, in case clock is running
   stz minutes
   stz seconds
   stz ticks   ; time reset to 00:00:00
   PRINT_DISPLAY ; update display immediately in case clock is stopped
   sei ; enable interrupts
   bra @loop
@start_stop:
   lda VERA_ien
   eor #VSYNC_BIT ; flip the VSYNC interrupt enable bit
   sta VERA_ien
   bra @loop
@return:
   rts

custom_irq_handler:
   ; custom IRQ handling
   sed ; enter decimal mode
   lda ticks
   clc
   adc #1 ; add 1 in decimal mode (e.g. $09 -> $10)
   cmp #$60
   bne @next_tick ; ticks not rolling over
   stz ticks ; reset ticks, update seconds counter
   bra @update_seconds
@next_tick:
   sta ticks ; ticks incremented
   bra @print
@update_seconds:
   lda seconds
   adc #1
   cmp #$60
   bne @next_second ; seconds not rolling over
   stz seconds ; reset seconds
   lda minutes
   adc #1 ; just increment minutes (will roll over after $99)
   sta minutes
   bra @print
@next_second:
   sta seconds
@print:
   cld ; exit decimal mode
   PRINT_DISPLAY ; update display during interrupt to prevent tearing

   ; continue to default IRQ handler
   jmp (default_irq_vector)
   ; RTI will happen after jump
