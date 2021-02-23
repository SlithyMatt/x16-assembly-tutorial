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

; constants
DISPLAY_Y         =

; globals
default_irq_vector: .addr 0
ticks: .byte 0
seconds: .byte 0
minutes: .byte 0

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


   ; enable IRQ now that vector is properly set
   cli








   rts

custom_irq_handler:
   ; custom IRQ handling


   ; continue to default IRQ handler
   jmp (default_irq_vector)
   ; RTI will happen after jump
