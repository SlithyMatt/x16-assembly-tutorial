.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

.include "x16.inc"

; Zero Page
MOUSE_X        = $30
MOUSE_Y        = MOUSE_X + 2

; VERA
; IEN/ISR:
VSYNC_BIT      = $01
SPRCOL_BIT     = $04
; ISR/Sprite Attributes:
COLLISION      = $10
; DC_VIDEO:
SPRITE_LAYER   = $40
LAYER1         = $20
VGA            = $01
; Sprite Attributes:
SPRITE_Z3      = $0C
SPRITE_VFLIP   = $02
SPRITE_HFLIP   = $01
SPRITE_32H     = $80
SPRITE_32W     = $20
; VRAM addresses:
VRAM_sprite_frames = $04000
VRAM_shadow_sprite = VRAM_sprattr + 8
SPRITE_SIZE = 32 * 32 / 2 ; 32x32 4bpp
NUM_FRAMES = 10
END_SPRITES = VRAM_sprite_frames + (SPRITE_SIZE * NUM_FRAMES)

; PETSCII
CHAR_C   = $43
CHAR_Q   = $51

; globals
default_irq_vector: .addr 0
done: .byte 0
frame: .word (VRAM_sprite_frames >> 5)

sprites_fn:    .byte "sprites.bin"
end_sprites_fn:

start:
   ; initialize globals
   stz done
   lda #<(VRAM_sprite_frames >> 5)
   sta frame
   lda #>(VRAM_sprite_frames >> 5)
   sta frame+1

   ; load sprite frames
   lda #1 ; logical number
   ldx #8 ; device number (SD Card / emulator host FS)
   ldy #0 ; secondary address (0 = ignore file header)
   jsr SETLFS
   lda #(end_sprites_fn-sprites_fn)
   ldx #<sprites_fn
   ldy #>sprites_fn
   jsr SETNAM
   lda #(^VRAM_sprite_frames + 2) ; VRAM bank + 2
   ldx #<VRAM_sprite_frames
   ldy #>VRAM_sprite_frames
   jsr LOAD

   ; enable custom mouse
   lda #$FF ; custom cursor
   ldx #1 ; 640x480 scale
   jsr MOUSE_CONFIG

   ; set initial mouse cursor sprite frame
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_sprattr, 1
   ; set sprite frame address
   lda frame
   sta VERA_data0
   lda frame+1 ; leave high bit clear for 4bpp
   sta VERA_data0
   ; leave position
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   ; set to Z-level 3, no flipping
   lda #(COLLISION | SPRITE_Z3)
   sta VERA_data0
   ; set to 32x32, palette offset 0
   lda #(SPRITE_32H | SPRITE_32W)
   sta VERA_data0

   ; setup shadow sprite (address already set)
   ; set sprite frame address
   lda frame
   sta VERA_data0
   lda frame+1 ; leave high bit clear for 4bpp
   sta VERA_data0
   ; set initial position to 0,0
   stz VERA_data0
   stz VERA_data0
   stz VERA_data0
   stz VERA_data0
   ; set to Z-level 3, flipped vertically and horizontally
   lda #(COLLISION | SPRITE_Z3 | SPRITE_VFLIP | SPRITE_HFLIP)
   sta VERA_data0
   ; set to 32x32, palette offset 1
   lda #(SPRITE_32H | SPRITE_32W | 1)
   sta VERA_data0

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
   lda #(SPRCOL_BIT | VSYNC_BIT) ; make VERA only generate SPRCOL and VSYNC IRQs
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
   ; disable mouse
   lda #0
   jsr MOUSE_CONFIG
   ; clear shadow sprite
   VERA_SET_ADDR (VRAM_shadow_sprite + 6), 0
   stz VERA_data0
   rts

custom_irq_handler:
   lda VERA_isr
   bit #VSYNC_BIT
   beq @check_sprcol ; not VSYNC
   ; go to next frame
   lda frame
   clc
   adc #<(SPRITE_SIZE << 5)
   sta frame
   lda frame+1
   adc #>(SPRITE_SIZE << 5)
   sta frame+1
   cmp #>(END_SPRITES << 5)
   bne @set_frame
   lda frame
   cmp #<(END_SPRITES << 5)
   bne @set_frame
   lda #<(VRAM_sprite_frames << 5)
   sta frame
   lda #>(VRAM_sprite_frames << 5)
   sta frame
   bra @sprcol
@set_frame:
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_sprattr, 1
   ; set mouse cursor frame
   lda frame
   sta VERA_data0
   lda frame+1
   sta VERA_data0
   ; skip ahead to shadow sprite
   VERA_SET_ADDR VRAM_shadow_sprite, 1
   ; set shadow sprite frame
   lda frame
   sta VERA_data0
   lda frame+1
   sta VERA_data0
   ; get mouse position
   ldx #MOUSE_X
   jsr MOUSE_GET
   ; update shadow position (640-x,480-y)
   lda #<640
   sec
   sbc MOUSE_X
   sta VERA_data0
   lda #>640
   sbc MOUSE_X+1
   sta VERA_data0
   lda #<480
   sec
   sbc MOUSE_Y
   sta VERA_data0
   lda #>480
   sbc MOUSE_Y+1
   sta VERA_data0
@check_sprcol:
   bit #SPRCOL_BIT
   beq @continue
   lda #CHAR_C
   jsr CHROUT
@continue:
   lda #(SPRCOL_BIT | VSYNC_BIT)
   sta VERA_isr ; reset latches
   jmp (default_irq_vector)
