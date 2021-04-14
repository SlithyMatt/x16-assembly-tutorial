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
VERA_irqline_l       = $9F28
VERA_dc_hscale       = $9F2A
VERA_dc_vscale       = $9F2B
DISPLAY_SCALE        = 16 ; 8X zoom
VERA_L1_hscroll_l    = $9F37
VERA_L1_hscroll_h    = $9F38

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
top_scroll: .byte 0
scroll_wave: .byte 0,0,1,2,3,3,2,1,0,0,1,2,3,3,2
DELAY = 60

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
   stz VERA_L1_hscroll_l ; H-scroll = 0
   stz VERA_L1_hscroll_h

   ; set colors of right end of text map
   stz VERA_ctrl
   lda #$90 ; stride = 256
   sta VERA_addr_high
   lda #(127*2 + 1) ; column 127 colors
   sta VERA_addr_low
   ldx #8 ; only worry about visible rows (0-7)
   lda #$61 ; white on blue
@color_loop:
   sta VERA_data0
   dex
   bne @color_loop

   ; print clock
   jsr print_display

   ; initialize globals
   lda #DELAY
   sta counter
   stz top_scroll

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
   lda #(LINE_BIT | VSYNC_BIT) ; make VERA only generate VSYNC IRQs
   sta VERA_ien
   lda #(DISPLAY_Y * 8) ; set LINE interrupt to start at top of number display
   sta VERA_irqline_l
   cli ; enable IRQ now that vector is properly set

@loop:
   wai
   jsr print_display
   jsr GETIN
   cmp #CHAR_Q
   bne @loop
   ; restore default IRQ vector
   sei
   lda default_irq_vector
   sta IRQVec
   lda default_irq_vector+1
   sta IRQVec+1
   cli
   rts

custom_irq_handler:
   lda VERA_isr
   bit #VSYNC_BIT
   beq @check_line
   dec counter
   bne @continue
   lda #DELAY
   sta counter
   inc top_scroll
   lda top_scroll
   cmp #8
   bne @continue
   stz top_scroll
   bra @continue
@check_line:
   bit #LINE_BIT
   beq @continue ; non-LINE IRQ, no change to scroll
   lda VERA_irqline_l
   sec
   sbc #(DISPLAY_Y * 8) ; get offset from top
   clc
   adc top_scroll
   tax
   lda scroll_wave,x
   sta VERA_L1_hscroll_l
   inc VERA_irqline_l
   cmp #((DISPLAY_Y + 1) * 8)
   bne @continue
   lda #(DISPLAY_Y * 8) ; back to top of number display
   sta VERA_irqline_l
@continue:
   ; reset IRQs
   lda #(LINE_BIT | VSYNC_BIT)
   sta VERA_isr
   ; continue to default IRQ handler
   jmp (default_irq_vector)
   ; RTI will happen after jump

print_display:
   jsr CLOCK_GET_DATE_TIME
   ; TODO: convert RTC values to BCD

   stz VERA_ctrl
   lda #$20 ; stride = 2
   sta VERA_addr_bank
   lda #DISPLAY_Y
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
