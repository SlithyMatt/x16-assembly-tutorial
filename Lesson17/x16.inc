.ifndef X16_INC
X16_INC  = 1

.ifndef __CX16__
__CX16__ = 1
.endif

; X16 addresses, values, and macros
; Accurate for ROM release R38

SD_DEVICE   = 8 ; also host file system on emulator if no SD image mounted
DISK_DEVICE = SD_DEVICE ; change if to be loaded off IEC device


; RAM Addresses

; Kernal Registers
r0                = $02
r0L               = r0
r0H               = r0+1
r1                = $04
r1L               = r1
r1H               = r1+1
r2                = $06
r2L               = r2
r2H               = r2+1
r3                = $08
r3L               = r3
r3H               = r3+1
r4                = $0A
r4L               = r4
r4H               = r4+1
r5                = $0C
r5L               = r5
r5H               = r5+1
r6                = $0E
r6L               = r6
r6H               = r6+1
r7                = $10
r7L               = r7
r7H               = r7+1
r8                = $12
r8L               = r8
r8H               = r8+1
r9                = $14
r9L               = r9
r9H               = r9+1
r10               = $16
r10L              = r10
r10H              = r10+1
r11               = $18
r11L              = r11
r11H              = r11+1
r12               = $1A
r12L              = r12
r12H              = r12+1
r13               = $1C
r13L              = r13
r13H              = r13+1
r14               = $1E
r14L              = r14
r14H              = r14+1
r15               = $20
r15L              = r15
r15H              = r15+1

; Zero-Page userspace
ZP_PTR_1          = $7E   ; four pointers for temporary use only
ZP_PTR_2          = $22
ZP_PTR_3          = $24
ZP_PTR_4          = $26

; I/O Registers
VERA_addr_low     = $9F20
VERA_addr_high    = $9F21
VERA_addr_bank    = $9F22
VERA_data0        = $9F23
VERA_data1        = $9F24
VERA_ctrl         = $9F25
VERA_ien          = $9F26
VERA_isr          = $9F27
VERA_irqline_l    = $9F28
VERA_dc_video     = $9F29 ; VERA_ctrl(1) (DCSEL) = 0
VERA_dc_hscale    = $9F2A ; VERA_ctrl(1) (DCSEL) = 0
VERA_dc_vscale    = $9F2B ; VERA_ctrl(1) (DCSEL) = 0
VERA_dc_border    = $9F2C ; VERA_ctrl(1) (DCSEL) = 0
VERA_dc_hstart    = $9F29 ; VERA_ctrl(1) (DCSEL) = 1
VERA_dc_hstop     = $9F2A ; VERA_ctrl(1) (DCSEL) = 1
VERA_dc_vsstart   = $9F2B ; VERA_ctrl(1) (DCSEL) = 1
VERA_dc_vstop     = $9F2C ; VERA_ctrl(1) (DCSEL) = 1
VERA_L0_config    = $9F2D
VERA_L0_mapbase   = $9F2E
VERA_L0_tilebase  = $9F2F
VERA_L0_hscroll_l = $9F30
VERA_L0_hscroll_h = $9F31
VERA_L0_vscroll_l = $9F32
VERA_L0_vscroll_h = $9F33
VERA_L1_config    = $9F34
VERA_L1_mapbase   = $9F35
VERA_L1_tilebase  = $9F36
VERA_L1_hscroll_l = $9F37
VERA_L1_hscroll_h = $9F38
VERA_L1_vscroll_l = $9F39
VERA_L1_vscroll_h = $9F3A
VERA_audio_ctrl   = $9F3B
VERA_audio_rate   = $9F3C
VERA_audio_data   = $9F3D
VERA_spi_data     = $9F3E
VERA_spi_ctrl     = $9F3F

ROM_BANK          = $9F60
RAM_BANK          = $9F61

YM_reg            = $9FE0
YM_data           = $9FE1

; Emulator Registers
GIF_ctrl          = $9FB5

; ROM Banks
KERNAL_ROM_BANK   = 0
KEYBOARD_ROM_BANK = 1
CBDOS_ROM_BANK    = 2
GEOS_ROM_BANK     = 3
BASIC_ROM_BANK    = 4
MONITOR_ROM_BANK  = 5
CHARSET_ROM_BANK  = 6

; Banked Addresses
RAM_WIN           = $A000
RAM_WIN_SIZE      = $2000
ROM_WIN           = $C000

; Kernal Subroutines
ENTROPY_GET                   := $FECF
CONSOLE_set_paging_message    := $FED5
CONSOLE_put_image             := $FED8
CONSOLE_init                  := $FEDB
CONSOLE_put_char              := $FEDE
CONSOLE_get_char              := $FEE1
MEMORY_FILL                   := $FEE4
MEMORY_COPY                   := $FEE7
MEMORY_CRC                    := $FEEA
MEMORY_DECOMPRESS             := $FEED
SPRITE_set_image              := $FEF0
SPRITE_set_position           := $FEF3
FB_init                       := $FEF6
FB_get_info                   := $FEF9
FB_set_palette                := $FEFC
FB_cursor_position            := $FEFF
FB_cursor_next_line           := $FF02
FB_get_pixel                  := $FF05
FB_get_pixels                 := $FF08
FB_set_pixel                  := $FF0B
FB_set_pixels                 := $FF0E
FB_set_8_pixels               := $FF11
FB_set_8_pixels_opaque        := $FF14
FB_fill_pixels                := $FF17
FB_filter_pixels              := $FF1A
FB_move_pixels                := $FF1D
GRAPH_init                    := $FF20
GRAPH_clear                   := $FF23
GRAPH_set_window              := $FF26
GRAPH_set_colors              := $FF29
GRAPH_draw_line               := $FF2C
GRAPH_draw_rect               := $FF2F
GRAPH_move_rect               := $FF32
GRAPH_draw_oval               := $FF35
GRAPH_draw_image              := $FF38
GRAPH_set_font                := $FF3B
GRAPH_get_char_size           := $FF3E
GRAPH_put_char                := $FF41
MONITOR                       := $FF44
ENTER_BASIC                   := $FF47
CLOSE_ALL                     := $FF4A
CLOCK_SET_DATE_TIME           := $FF4D
CLOCK_GET_DATE_TIME           := $FF50
JOYSTICK_SCAN                 := $FF53
JOYSTICK_GET                  := $FF56
SCREEN_SET_MODE               := $FF5F
SCREEN_SET_CHARSET            := $FF62
PFKEY                         := $FF65
MOUSE_CONFIG                  := $FF68
MOUSE_GET                     := $FF6B
JSRFAR_kernal_addr            := $FF6E
MOUSE_SCAN                    := $FF71
FETCH                         := $FF74
STASH                         := $FF77
CMPARE                        := $FF7A
PRIMM                         := $FF7D

SCINIT                        := $FF81
IOINIT                        := $FF84
RAMTAS                        := $FF87
RESTOR                        := $FF8A
LKUPLA                        := $FF8D
SETMSG                        := $FF90
SECOND                        := $FF93
TKSA                          := $FF96
MEMTOP                        := $FF99
MEMBOT                        := $FF9C
SETTMO                        := $FFA2
IECIN                         := $FFA5
IECOUT                        := $FFA8
UNTALK                        := $FFAB
UNLISTEN                      := $FFAE
LISTEN                        := $FFB1
TALK                          := $FFB4
READST                        := $FFB7
SETLFS                        := $FFBA
SETNAM                        := $FFBD
OPEN                          := $FFC0
CLOSE                         := $FFC3
CHKIN                         := $FFC6
CHKOUT                        := $FFC9
CLRCHN                        := $FFCC
CHRIN                         := $FFCF
BASIN                         := CHRIN ; alias
CHROUT                        := $FFD2
BSOUT                         := CHROUT ; alias
LOAD                          := $FFD5
SAVE                          := $FFD8
SETTIM                        := $FFDB
RDTIM                         := $FFDE
STOP                          := $FFE1
GETIN                         := $FFE4
CLALL                         := $FFE7
UDTIM                         := $FFEA
SCREEN                        := $FFED
PLOT                          := $FFF0
IOBASE                        := $FFF3

; BASIC Vectors
BASIC_PANIC       := $C000
BASIC_INIT        := $C003


; VRAM Addresses
VRAM_petscii   = $0F800
VRAM_psg       = $1F9C0
VRAM_palette   = $1FA00
VRAM_sprattr   = $1FC00

; RAM Vectors
IRQVec         := $0314
BRKVec         := $0316
NMIVec         := $0318
FETVec         := $03AF
;STAVec         := TBD
;CMPVec         := TBD


;   Macros

.macro VERA_SET_ADDR addr, stride
   .ifnblank stride
      .if stride < 0
         lda #((^addr) | $08 | ((0-stride) << 4))
      .else
         lda #((^addr) | (stride << 4))
      .endif
   .else
      lda #(^addr) | $10
   .endif

   sta VERA_addr_bank
   lda #(>addr)
   sta VERA_addr_high
   lda #(<addr)
   sta VERA_addr_low
.endmacro

.macro JSRFAR far_sr_addr, bank
	jsr JSRFAR_kernal_addr
	.addr far_sr_addr
	.byte bank
.endmacro

.endif
