
; initialization
ym_init_patch:
.byte YM_TEST, YM_LFO_RESET
.byte YM_LFRQ, 0
.byte YM_CT_W, YM_W_SAWTOOTH
.byte YM_PMD_AMD, YM_PMD | $7f
.byte YM_PMD_AMD, YM_AMD | $7f
.byte YM_KEY_ON, YM_CH_1
.byte YM_KEY_ON, YM_CH_2
.byte YM_KEY_ON, YM_CH_3
.byte YM_KEY_ON, YM_CH_4
.byte YM_KEY_ON, YM_CH_5
.byte YM_KEY_ON, YM_CH_6
.byte YM_KEY_ON, YM_CH_7
.byte YM_KEY_ON, YM_CH_8

; set patches
ym_channel_patches:
; Channels 1-4: Piano
; Channel 1:
.byte YM_DT1_MUL | YM_M1_SLOT | YM_CH_1, $31
.byte YM_TL | YM_M1_SLOT | YM_CH_1, $25
.byte YM_KS_AR | YM_M1_SLOT | YM_CH_1, $9c
.byte YM_AMS_EN_D1R | YM_M1_SLOT | YM_CH_1, $04
.byte YM_DT2_D2R | YM_M1_SLOT | YM_CH_1, $00
.byte YM_D1L_RR | YM_M1_SLOT | YM_CH_1, $15
.byte YM_DT1_MUL | YM_C1_SLOT | YM_CH_1, $03
.byte YM_TL | YM_C1_SLOT | YM_CH_1, $25
.byte YM_KS_AR | YM_C1_SLOT | YM_CH_1, $5d
.byte YM_AMS_EN_D1R | YM_C1_SLOT | YM_CH_1, $04
.byte YM_DT2_D2R | YM_C1_SLOT | YM_CH_1, $00
.byte YM_D1L_RR | YM_C1_SLOT | YM_CH_1, $16
.byte YM_DT1_MUL | YM_M2_SLOT | YM_CH_1, $7c
.byte YM_TL | YM_M2_SLOT | YM_CH_1, $2f
.byte YM_KS_AR | YM_M2_SLOT | YM_CH_1, $96
.byte YM_AMS_EN_D1R | YM_M2_SLOT | YM_CH_1, $09
.byte YM_DT2_D2R | YM_M2_SLOT | YM_CH_1, $00
.byte YM_D1L_RR | YM_M2_SLOT | YM_CH_1, $12
.byte YM_DT1_MUL | YM_C2_SLOT | YM_CH_1, $71
.byte YM_TL | YM_C2_SLOT | YM_CH_1, $10
.byte YM_KS_AR | YM_C2_SLOT | YM_CH_1, $8f
.byte YM_AMS_EN_D1R | YM_C2_SLOT | YM_CH_1, $07
.byte YM_DT2_D2R | YM_C2_SLOT | YM_CH_1, $00
.byte YM_D1L_RR | YM_C2_SLOT | YM_CH_1, $a5
.byte YM_OP_CTRL | YM_CH_1, YM_RL_ENABLE | YM_FB_4PI | YM_CON_M1_PL
.byte YM_PMS_AMS | YM_CH_1, $00
; Channel 2:
.byte YM_DT1_MUL | YM_M1_SLOT | YM_CH_2, $31
.byte YM_TL | YM_M1_SLOT | YM_CH_2, $25
.byte YM_KS_AR | YM_M1_SLOT | YM_CH_2, $9c
.byte YM_AMS_EN_D1R | YM_M1_SLOT | YM_CH_2, $04
.byte YM_DT2_D2R | YM_M1_SLOT | YM_CH_2, $00
.byte YM_D1L_RR | YM_M1_SLOT | YM_CH_2, $15
.byte YM_DT1_MUL | YM_C1_SLOT | YM_CH_2, $03
.byte YM_TL | YM_C1_SLOT | YM_CH_2, $25
.byte YM_KS_AR | YM_C1_SLOT | YM_CH_2, $5d
.byte YM_AMS_EN_D1R | YM_C1_SLOT | YM_CH_2, $04
.byte YM_DT2_D2R | YM_C1_SLOT | YM_CH_2, $00
.byte YM_D1L_RR | YM_C1_SLOT | YM_CH_2, $16
.byte YM_DT1_MUL | YM_M2_SLOT | YM_CH_2, $7c
.byte YM_TL | YM_M2_SLOT | YM_CH_2, $2f
.byte YM_KS_AR | YM_M2_SLOT | YM_CH_2, $96
.byte YM_AMS_EN_D1R | YM_M2_SLOT | YM_CH_2, $09
.byte YM_DT2_D2R | YM_M2_SLOT | YM_CH_2, $00
.byte YM_D1L_RR | YM_M2_SLOT | YM_CH_2, $12
.byte YM_DT1_MUL | YM_C2_SLOT | YM_CH_2, $71
.byte YM_TL | YM_C2_SLOT | YM_CH_2, $10
.byte YM_KS_AR | YM_C2_SLOT | YM_CH_2, $8f
.byte YM_AMS_EN_D1R | YM_C2_SLOT | YM_CH_2, $07
.byte YM_DT2_D2R | YM_C2_SLOT | YM_CH_2, $00
.byte YM_D1L_RR | YM_C2_SLOT | YM_CH_2, $a5
.byte YM_OP_CTRL | YM_CH_2, YM_RL_ENABLE | YM_FB_4PI | YM_CON_M1_PL
.byte YM_PMS_AMS | YM_CH_2, $00
; Channel 3:
.byte YM_DT1_MUL | YM_M1_SLOT | YM_CH_3, $31
.byte YM_TL | YM_M1_SLOT | YM_CH_3, $25
.byte YM_KS_AR | YM_M1_SLOT | YM_CH_3, $9c
.byte YM_AMS_EN_D1R | YM_M1_SLOT | YM_CH_3, $04
.byte YM_DT2_D2R | YM_M1_SLOT | YM_CH_3, $00
.byte YM_D1L_RR | YM_M1_SLOT | YM_CH_3, $15
.byte YM_DT1_MUL | YM_C1_SLOT | YM_CH_3, $03
.byte YM_TL | YM_C1_SLOT | YM_CH_3, $25
.byte YM_KS_AR | YM_C1_SLOT | YM_CH_3, $5d
.byte YM_AMS_EN_D1R | YM_C1_SLOT | YM_CH_3, $04
.byte YM_DT2_D2R | YM_C1_SLOT | YM_CH_3, $00
.byte YM_D1L_RR | YM_C1_SLOT | YM_CH_3, $16
.byte YM_DT1_MUL | YM_M2_SLOT | YM_CH_3, $7c
.byte YM_TL | YM_M2_SLOT | YM_CH_3, $2f
.byte YM_KS_AR | YM_M2_SLOT | YM_CH_3, $96
.byte YM_AMS_EN_D1R | YM_M2_SLOT | YM_CH_3, $09
.byte YM_DT2_D2R | YM_M2_SLOT | YM_CH_3, $00
.byte YM_D1L_RR | YM_M2_SLOT | YM_CH_3, $12
.byte YM_DT1_MUL | YM_C2_SLOT | YM_CH_3, $71
.byte YM_TL | YM_C2_SLOT | YM_CH_3, $10
.byte YM_KS_AR | YM_C2_SLOT | YM_CH_3, $8f
.byte YM_AMS_EN_D1R | YM_C2_SLOT | YM_CH_3, $07
.byte YM_DT2_D2R | YM_C2_SLOT | YM_CH_3, $00
.byte YM_D1L_RR | YM_C2_SLOT | YM_CH_3, $a5
.byte YM_OP_CTRL | YM_CH_3, YM_RL_ENABLE | YM_FB_4PI | YM_CON_M1_PL
.byte YM_PMS_AMS | YM_CH_3, $00
; Channel 4:
.byte YM_DT1_MUL | YM_M1_SLOT | YM_CH_4, $31
.byte YM_TL | YM_M1_SLOT | YM_CH_4, $25
.byte YM_KS_AR | YM_M1_SLOT | YM_CH_4, $9c
.byte YM_AMS_EN_D1R | YM_M1_SLOT | YM_CH_4, $04
.byte YM_DT2_D2R | YM_M1_SLOT | YM_CH_4, $00
.byte YM_D1L_RR | YM_M1_SLOT | YM_CH_4, $15
.byte YM_DT1_MUL | YM_C1_SLOT | YM_CH_4, $03
.byte YM_TL | YM_C1_SLOT | YM_CH_4, $25
.byte YM_KS_AR | YM_C1_SLOT | YM_CH_4, $5d
.byte YM_AMS_EN_D1R | YM_C1_SLOT | YM_CH_4, $04
.byte YM_DT2_D2R | YM_C1_SLOT | YM_CH_4, $00
.byte YM_D1L_RR | YM_C1_SLOT | YM_CH_4, $16
.byte YM_DT1_MUL | YM_M2_SLOT | YM_CH_4, $7c
.byte YM_TL | YM_M2_SLOT | YM_CH_4, $2f
.byte YM_KS_AR | YM_M2_SLOT | YM_CH_4, $96
.byte YM_AMS_EN_D1R | YM_M2_SLOT | YM_CH_4, $09
.byte YM_DT2_D2R | YM_M2_SLOT | YM_CH_4, $00
.byte YM_D1L_RR | YM_M2_SLOT | YM_CH_4, $12
.byte YM_DT1_MUL | YM_C2_SLOT | YM_CH_4, $71
.byte YM_TL | YM_C2_SLOT | YM_CH_4, $10
.byte YM_KS_AR | YM_C2_SLOT | YM_CH_4, $8f
.byte YM_AMS_EN_D1R | YM_C2_SLOT | YM_CH_4, $07
.byte YM_DT2_D2R | YM_C2_SLOT | YM_CH_4, $00
.byte YM_D1L_RR | YM_C2_SLOT | YM_CH_4, $a5
.byte YM_OP_CTRL | YM_CH_4, YM_RL_ENABLE | YM_FB_4PI | YM_CON_M1_PL
.byte YM_PMS_AMS | YM_CH_4, $00

; Channels 5-8: Strings
; Channel 5:
.byte YM_DT1_MUL | YM_M1_SLOT | YM_CH_5, $62
.byte YM_TL | YM_M1_SLOT | YM_CH_5, $1e
.byte YM_KS_AR | YM_M1_SLOT | YM_CH_5, $8f
.byte YM_AMS_EN_D1R | YM_M1_SLOT | YM_CH_5, $00
.byte YM_DT2_D2R | YM_M1_SLOT | YM_CH_5, $00
.byte YM_D1L_RR | YM_M1_SLOT | YM_CH_5, $02
.byte YM_DT1_MUL | YM_C1_SLOT | YM_CH_5, $34
.byte YM_TL | YM_C1_SLOT | YM_CH_5, $26
.byte YM_KS_AR | YM_C1_SLOT | YM_CH_5, $0d
.byte YM_AMS_EN_D1R | YM_C1_SLOT | YM_CH_5, $08
.byte YM_DT2_D2R | YM_C1_SLOT | YM_CH_5, $01
.byte YM_D1L_RR | YM_C1_SLOT | YM_CH_5, $27
.byte YM_DT1_MUL | YM_M2_SLOT | YM_CH_5, $34
.byte YM_TL | YM_M2_SLOT | YM_CH_5, $26
.byte YM_KS_AR | YM_M2_SLOT | YM_CH_5, $0d
.byte YM_AMS_EN_D1R | YM_M2_SLOT | YM_CH_5, $05
.byte YM_DT2_D2R | YM_M2_SLOT | YM_CH_5, $01
.byte YM_D1L_RR | YM_M2_SLOT | YM_CH_5, $26
.byte YM_DT1_MUL | YM_C2_SLOT | YM_CH_5, $34
.byte YM_TL | YM_C2_SLOT | YM_CH_5, $26
.byte YM_KS_AR | YM_C2_SLOT | YM_CH_5, $0d
.byte YM_AMS_EN_D1R | YM_C2_SLOT | YM_CH_5, $05
.byte YM_DT2_D2R | YM_C2_SLOT | YM_CH_5, $01
.byte YM_D1L_RR | YM_C2_SLOT | YM_CH_5, $27
.byte YM_OP_CTRL | YM_CH_5, YM_RL_ENABLE | YM_FB_4PI | YM_CON_M2CX_PL
.byte YM_PMS_AMS | YM_CH_5, $00
; Channel 6:
.byte YM_DT1_MUL | YM_M1_SLOT | YM_CH_6, $62
.byte YM_TL | YM_M1_SLOT | YM_CH_6, $1e
.byte YM_KS_AR | YM_M1_SLOT | YM_CH_6, $8f
.byte YM_AMS_EN_D1R | YM_M1_SLOT | YM_CH_6, $00
.byte YM_DT2_D2R | YM_M1_SLOT | YM_CH_6, $00
.byte YM_D1L_RR | YM_M1_SLOT | YM_CH_6, $02
.byte YM_DT1_MUL | YM_C1_SLOT | YM_CH_6, $34
.byte YM_TL | YM_C1_SLOT | YM_CH_6, $26
.byte YM_KS_AR | YM_C1_SLOT | YM_CH_6, $0d
.byte YM_AMS_EN_D1R | YM_C1_SLOT | YM_CH_6, $08
.byte YM_DT2_D2R | YM_C1_SLOT | YM_CH_6, $01
.byte YM_D1L_RR | YM_C1_SLOT | YM_CH_6, $27
.byte YM_DT1_MUL | YM_M2_SLOT | YM_CH_6, $34
.byte YM_TL | YM_M2_SLOT | YM_CH_6, $26
.byte YM_KS_AR | YM_M2_SLOT | YM_CH_6, $0d
.byte YM_AMS_EN_D1R | YM_M2_SLOT | YM_CH_6, $05
.byte YM_DT2_D2R | YM_M2_SLOT | YM_CH_6, $01
.byte YM_D1L_RR | YM_M2_SLOT | YM_CH_6, $26
.byte YM_DT1_MUL | YM_C2_SLOT | YM_CH_6, $34
.byte YM_TL | YM_C2_SLOT | YM_CH_6, $26
.byte YM_KS_AR | YM_C2_SLOT | YM_CH_6, $0d
.byte YM_AMS_EN_D1R | YM_C2_SLOT | YM_CH_6, $05
.byte YM_DT2_D2R | YM_C2_SLOT | YM_CH_6, $01
.byte YM_D1L_RR | YM_C2_SLOT | YM_CH_6, $27
.byte YM_OP_CTRL | YM_CH_6, YM_RL_ENABLE | YM_FB_4PI | YM_CON_M2CX_PL
.byte YM_PMS_AMS | YM_CH_6, $00
; Channel 7:
.byte YM_DT1_MUL | YM_M1_SLOT | YM_CH_7, $62
.byte YM_TL | YM_M1_SLOT | YM_CH_7, $1e
.byte YM_KS_AR | YM_M1_SLOT | YM_CH_7, $8f
.byte YM_AMS_EN_D1R | YM_M1_SLOT | YM_CH_7, $00
.byte YM_DT2_D2R | YM_M1_SLOT | YM_CH_7, $00
.byte YM_D1L_RR | YM_M1_SLOT | YM_CH_7, $02
.byte YM_DT1_MUL | YM_C1_SLOT | YM_CH_7, $34
.byte YM_TL | YM_C1_SLOT | YM_CH_7, $26
.byte YM_KS_AR | YM_C1_SLOT | YM_CH_7, $0d
.byte YM_AMS_EN_D1R | YM_C1_SLOT | YM_CH_7, $08
.byte YM_DT2_D2R | YM_C1_SLOT | YM_CH_7, $01
.byte YM_D1L_RR | YM_C1_SLOT | YM_CH_7, $27
.byte YM_DT1_MUL | YM_M2_SLOT | YM_CH_7, $34
.byte YM_TL | YM_M2_SLOT | YM_CH_7, $26
.byte YM_KS_AR | YM_M2_SLOT | YM_CH_7, $0d
.byte YM_AMS_EN_D1R | YM_M2_SLOT | YM_CH_7, $05
.byte YM_DT2_D2R | YM_M2_SLOT | YM_CH_7, $01
.byte YM_D1L_RR | YM_M2_SLOT | YM_CH_7, $26
.byte YM_DT1_MUL | YM_C2_SLOT | YM_CH_7, $34
.byte YM_TL | YM_C2_SLOT | YM_CH_7, $26
.byte YM_KS_AR | YM_C2_SLOT | YM_CH_7, $0d
.byte YM_AMS_EN_D1R | YM_C2_SLOT | YM_CH_7, $05
.byte YM_DT2_D2R | YM_C2_SLOT | YM_CH_7, $01
.byte YM_D1L_RR | YM_C2_SLOT | YM_CH_7, $27
.byte YM_OP_CTRL | YM_CH_7, YM_RL_ENABLE | YM_FB_4PI | YM_CON_M2CX_PL
.byte YM_PMS_AMS | YM_CH_7, $00
; Channel 8:
.byte YM_DT1_MUL | YM_M1_SLOT | YM_CH_8, $62
.byte YM_TL | YM_M1_SLOT | YM_CH_8, $1e
.byte YM_KS_AR | YM_M1_SLOT | YM_CH_8, $8f
.byte YM_AMS_EN_D1R | YM_M1_SLOT | YM_CH_8, $00
.byte YM_DT2_D2R | YM_M1_SLOT | YM_CH_8, $00
.byte YM_D1L_RR | YM_M1_SLOT | YM_CH_8, $02
.byte YM_DT1_MUL | YM_C1_SLOT | YM_CH_8, $34
.byte YM_TL | YM_C1_SLOT | YM_CH_8, $26
.byte YM_KS_AR | YM_C1_SLOT | YM_CH_8, $0d
.byte YM_AMS_EN_D1R | YM_C1_SLOT | YM_CH_8, $08
.byte YM_DT2_D2R | YM_C1_SLOT | YM_CH_8, $01
.byte YM_D1L_RR | YM_C1_SLOT | YM_CH_8, $27
.byte YM_DT1_MUL | YM_M2_SLOT | YM_CH_8, $34
.byte YM_TL | YM_M2_SLOT | YM_CH_8, $26
.byte YM_KS_AR | YM_M2_SLOT | YM_CH_8, $0d
.byte YM_AMS_EN_D1R | YM_M2_SLOT | YM_CH_8, $05
.byte YM_DT2_D2R | YM_M2_SLOT | YM_CH_8, $01
.byte YM_D1L_RR | YM_M2_SLOT | YM_CH_8, $26
.byte YM_DT1_MUL | YM_C2_SLOT | YM_CH_8, $34
.byte YM_TL | YM_C2_SLOT | YM_CH_8, $26
.byte YM_KS_AR | YM_C2_SLOT | YM_CH_8, $0d
.byte YM_AMS_EN_D1R | YM_C2_SLOT | YM_CH_8, $05
.byte YM_DT2_D2R | YM_C2_SLOT | YM_CH_8, $01
.byte YM_D1L_RR | YM_C2_SLOT | YM_CH_8, $27
.byte YM_OP_CTRL | YM_CH_8, YM_RL_ENABLE | YM_FB_4PI | YM_CON_M2CX_PL
.byte YM_PMS_AMS | YM_CH_8, $00
