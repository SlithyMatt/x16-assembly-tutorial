.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

; Zero Page


; Kernal
SETLFS   = $FFBA
SETNAM   = $FFBD
CHRIN    = $FFCF
CHROUT   = $FFD2
LOAD     = $FFD5
SAVE     = $FFD8
GETIN    = $FFE4
SCREEN   = $FFED
PLOT     = $FFF0

; VERA
DC_HSCALE   = $9F2A
DC_VSCALE   = $9F2B
2X_SCALE    = 64

; PETSCII
CLR      = $93

   jmp start



start:
   jsr SCREEN
   cpx #40
   beq @check_height
   lda #2X_SCALE
   sta DC_HSCALE ; set horizontal scale to 2x (40 columns)
@check_height:
   cpy #30
   beq @clear_screen
   lda #2X_SCALE
   sta DC_VSCALE ; set vertical scale to 2x (30 rows)
@clear_screen:
   lda #CLR
   jsr CHROUT
   

   rts
