.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

.include "x16.inc"
.include "ym2151.inc"

; VERA
VSYNC_BIT = $01

start_patches:
.include "patches.asm"
end_patches:

MUSIC_PTR = $30
HALF_BEAT = 15 ; 120 bpm

WAIT_REG = $02
.macro WAIT_HALF_BEAT
.byte WAIT_REG,0
.endmacro

END_REG = $04
.macro END_MUSIC
.byte END_REG,0
.endmacro

.macro NOTE channel, key, octave
.byte YM_KEY_ON, channel
.byte YM_KC | channel, key | octave
.byte YM_KEY_ON, channel | YM_SN_ALL
.endmacro

.macro REST channel
.byte YM_KEY_ON, channel
.endmacro

start_music:
.include "eknm.asm"
end_music:

; globals
default_irq_vector: .addr 0
counter: .byte HALF_BEAT
done: .byte 0

start:
   ; write patches
   stz MUSIC_PTR
   ldy #<start_patches
   lda #>start_patches
   sta MUSIC_PTR+1
@patch_loop:
   bit YM_data
   bmi @patch_loop ; wait for YM2151 to be ready
   lda (MUSIC_PTR),y
   sta YM_reg
   iny
   bne @write_data
   inc MUSIC_PTR+1
@write_data:
   lda (MUSIC_PTR),y
   sta YM_data
   iny
   bne @check_end
   inc MUSIC_PTR+1
@check_end:
   lda MUSIC_PTR+1
   cmp #>end_patches
   bne @patch_loop
   cpy #<end_patches
   bne @patch_loop

   ; initialize music pointer
   lda #<start_music
   sta MUSIC_PTR
   lda #>start_music
   sta MUSIC_PTR+1

   ; initialize globals
   stz done
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
   lda #VSYNC_BIT ; make VERA only generate VSYNC IRQs
   sta VERA_ien
   cli ; enable IRQ now that vector is properly set

@loop:
   wai
   bit done
   bpl @loop
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
   beq @continue ; not VSYNC
   sta VERA_isr ; reset VSYNC latch
   dec counter
   bne @continue
@music_loop:
   bit YM_data
   bmi @music_loop
   lda (MUSIC_PTR)
   cmp #WAIT_REG
   beq @wait
   cmp #END_REG
   beq @end_music
   sta YM_reg
   ldy #1
   lda (MUSIC_PTR),y
   sta YM_data
   bra @next
@wait:
   ldy #0 ; write didn't happen
@next:
   lda MUSIC_PTR
   clc
   adc #2
   sta MUSIC_PTR
   lda MUSIC_PTR+1
   adc #0
   sta MUSIC_PTR+1
   cpy #0
   bne @music_loop
   lda #HALF_BEAT
   sta counter
   bra @continue
@end_music:
   jsr stop_all
   lda #$80
   sta done
@continue:
   jmp (default_irq_vector)

stop_all:
   YM_SET_REG YM_KEY_ON, YM_CH_1
   YM_SET_REG YM_KEY_ON, YM_CH_2
   YM_SET_REG YM_KEY_ON, YM_CH_3
   YM_SET_REG YM_KEY_ON, YM_CH_4
   YM_SET_REG YM_KEY_ON, YM_CH_5
   YM_SET_REG YM_KEY_ON, YM_CH_6
   YM_SET_REG YM_KEY_ON, YM_CH_7
   YM_SET_REG YM_KEY_ON, YM_CH_8
   rts
