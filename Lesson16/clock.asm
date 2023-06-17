.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

; Zero Page
r0                   = $02
r0L                  = r0
r0H                  = r0+1
r1                   = $04
r1L                  = r1
r1H                  = r1+1
r2                   = $06
r2L                  = r2
r2H                  = r2+1

; RAM Interrupt Vectors
IRQVec               = $0314

; VERA
VERA_addr_low        = $9F20
VERA_addr_high       = $9F21
VERA_addr_bank       = $9F22
VERA_data0           = $9F23
VERA_ctrl            = $9F25
VERA_ien             = $9F26
VERA_isr             = $9F27
VSYNC_BIT            = $01
LINE_BIT             = $02
SCAN_LINE_8          = $40
IRQ_LINE_8           = $80
VERA_irqline_l       = $9F28
VERA_dc_hscale       = $9F2A
VERA_dc_vscale       = $9F2B
DISPLAY_SCALE        = 16 ; 8X zoom

; Kernal
CLOCK_GET_DATE_TIME  = $FF50
CHROUT               = $FFD2
GETIN                = $FFE4

; PETSCII
CHAR_0               = $30
COLON                = $3A
CHAR_Q               = $51
CLR                  = $93

; constants
DISPLAY_X         = 1
DISPLAY_Y         = 3

; globals
default_irq_vector: .addr 0
hours: .byte 0
minutes: .byte 0
seconds: .byte 0
counter: .byte 0
color_wave: .byte $6B,$6C,$6F,$61,$61,$6F,$6C,$6B
irq_line: .byte 0

LINES_PER_PIXEL   = 128/DISPLAY_SCALE
START_LINE        = DISPLAY_Y * 8 * LINES_PER_PIXEL - LINES_PER_PIXEL/2 - 2
STOP_LINE         = START_LINE + LINES_PER_PIXEL * 8

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

start:
   ; Initialize display
   lda #CLR
   jsr CHROUT ; clear display
   lda #DISPLAY_SCALE
   sta VERA_dc_hscale
   sta VERA_dc_vscale ; zoom level set

   ; print clock
   jsr print_display

   ; initialize globals
   stz counter

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
   ; set LINE interrupt to start half-pixel above number display
   lda #START_LINE
   sta VERA_irqline_l
   sta irq_line
   lda #(LINE_BIT | VSYNC_BIT) ; make VERA only generate LINE and VSYNC IRQs
   sta VERA_ien
   cli ; enable IRQ now that vector is properly set

@loop:
   wai
   jsr GETIN
   cmp #CHAR_Q
   bne @loop
   ; restore default IRQ vector
   sei
   lda default_irq_vector
   sta IRQVec
   lda default_irq_vector+1
   sta IRQVec+1
   lda #VSYNC_BIT
   sta VERA_ien
   cli
   lda #128
   sta VERA_dc_hscale
   sta VERA_dc_vscale ; zoom level reset
   lda #CLR
   jsr CHROUT
   rts

custom_irq_handler:
   lda VERA_isr
   bit #VSYNC_BIT
   beq @change_line
   jsr print_display
   stz counter
   bra @continue
@change_line:
   stz VERA_ctrl
   lda #$21 ; stride = 2
   sta VERA_addr_bank
   lda #(DISPLAY_Y + $B0)
   sta VERA_addr_high
   lda #(DISPLAY_X * 2 + 1)
   sta VERA_addr_low
   ldx counter
   lda color_wave,x
   ldy #8
@color_loop:
   sta VERA_data0
   dey
   bne @color_loop
   inc counter
   lda #8
   cmp counter
   beq @reset
   lda irq_line
   clc
   adc #LINES_PER_PIXEL
   sta VERA_irqline_l
   sta irq_line
   bcs @high_enable
   lda #(LINE_BIT | VSYNC_BIT)
   sta VERA_ien
   bra @quick_return
@reset:
   lda #START_LINE
   sta VERA_irqline_l
   sta irq_line
   stz counter
   lda #(LINE_BIT | VSYNC_BIT)
   sta VERA_ien
   bra @quick_return
@high_enable:
   lda #(IRQ_LINE_8 | LINE_BIT | VSYNC_BIT)
   sta VERA_ien
@quick_return:
   ; reset IRQs
   lda #(LINE_BIT | VSYNC_BIT)
   sta VERA_isr
   ply
   plx
   pla
   rti
@continue:
   ; reset IRQs
   lda #(LINE_BIT | VSYNC_BIT)
   sta VERA_isr
   ; continue to default IRQ handler
   jmp (default_irq_vector)
   ; RTI will happen after jump

print_display:
   jsr CLOCK_GET_DATE_TIME
   lda r1H
   jsr bin2dec
   sta hours
   lda r2L
   jsr bin2dec
   sta minutes
   lda r2H
   jsr bin2dec
   sta seconds
   stz VERA_ctrl
   lda #$21 ; stride = 2
   sta VERA_addr_bank
   lda #(DISPLAY_Y + $B0)
   sta VERA_addr_high
   lda #(DISPLAY_X * 2)
   sta VERA_addr_low
   PRINT_DECIMAL hours
   lda #COLON
   sta VERA_data0
   PRINT_DECIMAL minutes
   lda #COLON
   sta VERA_data0
   PRINT_DECIMAL seconds
   rts

bin2dec:
   bra @start
@bin: .byte 0
@bcd: .byte 0
@start:
   sta @bin
   stz @bcd
   ldx #8
   sed
@loop:
   asl @bin
   lda @bcd
   adc @bcd
   sta @bcd
   dex
   bne @loop
   cld
   rts
