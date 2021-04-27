.ifndef YM2151_INC
YM2151_INC = 1

.include "x16.inc"

.macro YM_SET_REG reg, val
:  bit YM_data
   bmi :-
   lda #reg
   sta YM_reg
   lda #val
   sta YM_data
.endmacro

YM_TEST        = $01
YM_LFO_RESET   = $02

YM_KEY_ON      = $08
YM_SN_M1       = $08
YM_SN_C1       = $10
YM_SN_M2       = $20
YM_SN_C2       = $40
YM_SN_ALL      = YM_SN_M1 | YM_SN_C1 | YM_SN_M2 | YM_SN_C2
YM_CH_1        = $00
YM_CH_2        = $01
YM_CH_3        = $02
YM_CH_4        = $03
YM_CH_5        = $04
YM_CH_6        = $05
YM_CH_7        = $06
YM_CH_8        = $07
YM_NOISE_ON    = YM_SN_C2 | YM_CH_8
YM_NOISE_OFF   = YM_CH_8

YM_NE_NFRQ     = $0F
YM_NE          = $80
YM_NFRQ_111_9k = $01
YM_NFRQ_7k     = $10
YM_NFRQ_3_5k   = $1F

YM_CLKA1       = $10
YM_CLKA2       = $11

YM_CLKB        = $12

YM_TIMER_CTRL  = $14
YM_CSM         = $80
YM_F_RESET_A   = $10
YM_F_RESET_B   = $20
YM_IRQEN_A     = $04
YM_IRQEN_B     = $08
YM_LOAD_A      = $01
YM_LOAD_B      = $02

YM_LFRQ        = $18

YM_PMD_AMD     = $19

YM_CT_W        = $1B
YM_CT1         = $40
YM_CT2         = $80
YM_W_SAWTOOTH  = $00
YM_W_SQUARE    = $01
YM_W_TRIANGLE  = $02
YM_W_NOISE     = $03

YM_OP_CTRL     = $20
YM_R_ENABLE    = $80
YM_L_ENABLE    = $40
YM_RL_ENABLE   = $C0
YM_FB_OFF      = $00
YM_FB_PI_16    = $08
YM_FB_PI_8     = $10
YM_FB_PI_4     = $18
YM_FB_PI_2     = $20
YM_FB_PI       = $28
YM_FB_2PI      = $30
YM_FB_4PI      = $38
YM_CON_SERIAL  = $00
YM_CON_C1_PL   = $01
YM_CON_M1_PL   = $02
YM_CON_M2_PL   = $03
YM_CON_12_PL   = $04
YM_CON_M2CX_PL = $05
YM_CON_M2C2_PL = $06
YM_CON_ALL_PL  = $07

YM_KC          = $28
YM_KC_OCT0     = $00
YM_KC_OCT1     = $10
YM_KC_OCT2     = $20
YM_KC_OCT3     = $30
YM_KC_OCT4     = $40
YM_KC_OCT5     = $50
YM_KC_OCT6     = $60
YM_KC_OCT7     = $70
YM_KC_C_SH     = $00
YM_KC_D_FL     = YM_KC_C_SH
YM_KC_D        = $01
YM_KC_D_SH     = $02
YM_KC_E_FL     = YM_KC_D_SH
YM_KC_E        = $04
YM_KC_F        = $05
YM_KC_F_SH     = $06
YM_KC_G_FL     = YM_KC_F_SH
YM_KC_G        = $08
YM_KC_G_SH     = $09
YM_KC_A_FL     = YM_KC_G_SH
YM_KC_A        = $0A
YM_KC_A_SH     = $0C
YM_KC_B_FL     = YM_KC_A_SH
YM_KC_B        = $0D
YM_KC_C        = $0E
YM_KC_LOW_C    = YM_KC_OCT1 | YM_KC_C
YM_KC_MIDDLE_C = YM_KC_OCT3 | YM_KC_C
YM_KC_HIGH_C   = YM_KC_OCT5 | YM_KC_C

YM_KF          = $30

YM_PMS_AMS     = $38

YM_DT1_MUL     = $40
YM_M1_SLOT     = $00
YM_C1_SLOT     = $08
YM_M2_SLOT     = $10
YM_C2_SLOT     = $18

YM_TL          = $60

YM_KS_AR       = $80

YM_AMS_EN_D1R  = $A0

YM_DT2_D2R     = $C0

YM_D1L_RR      = $E0

.endif
