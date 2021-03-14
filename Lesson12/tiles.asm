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
VERA_dc_video     = $9F29
VERA_dc_hscale    = $9F2A
VERA_dc_vscale    = $9F2B
VERA_L0_config    = $9F2D
VERA_L0_mapbase   = $9F2E
VERA_L0_tilebase  = $9F2F
VERA_L1_config    = $9F34
VERA_L1_mapbase   = $9F35
VERA_L1_tilebase  = $9F36

; VRAM Addresses
VRAM_layer0_map   = $00000
VRAM_layer1_map   = $00200
VRAM_tiles        = $00600

; globals:
start_vram:
sky: ; 32 x 16 (only populating first 8 rows)
.byte $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00
.byte $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00
.byte $01,$00, $01,$00, $01,$00, $02,$00, $03,$00, $04,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $02,$00, $03,$00, $04,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $02,$00, $03,$00, $04,$00, $01,$00, $01,$00
.byte $01,$00, $01,$00, $01,$00, $04,$0c, $05,$08, $04,$08, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $04,$0c, $05,$08, $04,$08, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $04,$0c, $05,$08, $04,$08, $01,$00, $01,$00
.byte $04,$04, $04,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $02,$00, $03,$00, $04,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $02,$00, $03,$00, $04,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00
.byte $04,$0c, $04,$08, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $04,$0c, $05,$08, $04,$08, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $04,$0c, $05,$08, $04,$08, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00
.byte $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00
.byte $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00, $01,$00

ground: ; 32 x 16
.byte $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
.byte $08,$00, $08,$04, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $08,$00, $08,$04, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $08,$00, $08,$04, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $08,$00, $08,$04, $00,$00, $00,$00, $00,$00
.byte $09,$00, $09,$04, $07,$00, $07,$00, $07,$00, $07,$00, $07,$00, $07,$00, $07,$00, $09,$00, $09,$04, $07,$00, $07,$00, $07,$00, $07,$00, $07,$00, $07,$00, $07,$00, $09,$00, $09,$04, $07,$00, $07,$00, $07,$00, $07,$00, $07,$00, $07,$00, $07,$00, $09,$00, $09,$04, $07,$00, $07,$00, $07,$00
.byte $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00
.byte $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00
.byte $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00
.byte $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00
.byte $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00
.byte $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00
.byte $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00
.byte $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00, $06,$00

tiles:
      ; Tile 0
.byte $00,$00,$00,$00
.byte $00,$00,$00,$00
.byte $00,$00,$00,$00
.byte $00,$00,$00,$00
.byte $00,$00,$00,$00
.byte $00,$00,$00,$00
.byte $00,$00,$00,$00
.byte $00,$00,$00,$00

      ; Tile 1
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33

      ; Tile 2
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$3f
.byte $33,$33,$3f,$f1
.byte $33,$3f,$f1,$11
.byte $33,$f1,$11,$11
.byte $3f,$11,$11,$1f

      ; Tile 3
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $ff,$f3,$33,$33
.byte $11,$1f,$f3,$33
.byte $11,$11,$1f,$ff
.byte $1f,$11,$11,$11
.byte $f1,$11,$11,$11

      ; Tile 4
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $ff,$ff,$f3,$33
.byte $11,$11,$1f,$33
.byte $11,$11,$11,$f3

      ; Tile 5
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $33,$33,$33,$33
.byte $ff,$ff,$ff,$ff
.byte $11,$11,$11,$11
.byte $11,$11,$11,$f1

      ; Tile 6
.byte $55,$55,$d5,$55
.byte $55,$55,$d5,$55
.byte $5d,$55,$5d,$55
.byte $5d,$55,$5d,$55
.byte $d5,$55,$55,$55
.byte $d5,$55,$55,$55
.byte $5d,$55,$5d,$55
.byte $5d,$55,$5d,$55

      ; Tile 7
.byte $00,$00,$00,$00
.byte $00,$00,$00,$00
.byte $00,$00,$00,$00
.byte $00,$00,$00,$00
.byte $00,$00,$00,$00
.byte $0d,$00,$d0,$0d
.byte $55,$55,$55,$55
.byte $55,$55,$55,$55

      ; Tile 8
.byte $00,$00,$00,$00
.byte $00,$00,$00,$00
.byte $00,$00,$00,$00
.byte $00,$00,$00,$55
.byte $00,$00,$55,$55
.byte $00,$00,$55,$55
.byte $00,$05,$55,$55
.byte $00,$05,$55,$55

      ; Tile 9
.byte $00,$05,$55,$55
.byte $00,$00,$55,$55
.byte $00,$00,$05,$95
.byte $00,$00,$00,$09
.byte $00,$00,$00,$09
.byte $0d,$00,$d0,$09
.byte $55,$55,$55,$99
.byte $55,$55,$59,$95

end_vram: .word end_vram-start_vram

sky_move: .byte 0

start:


   rts