.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

ZP_PTR_1 = $30
ZP_PTR_2 = $32
ZP_DATA  = $34

data:
.byte $01,$23,$45,$67,$89,$AB,$CD,$EF

results:
.byte 0,0,0

start:
   ; copy first three bytes of data to ZP_DATA
   lda data          ; absolute
   sta ZP_DATA       ; zero page
   ldx #1            ; immediate
   lda data,x        ; absolute indexed with X
   sta ZP_DATA,x     ; zero page indexed with X
   txa               ; implicit (transfer X to A)
   tay               ; implicit (transfer A to Y)
   iny               ; implicit (increment Y)
   lda data,y        ; absolute indexed with Y
   sta ZP_DATA,y     ; zero page indexed with Y

   ; point ZP_PTR_1 to beginning of data
   lda #<data        ; immediate address low byte
   sta ZP_PTR_1      ; zero page
   lda #>data        ; immediate address high byte
   sta ZP_PTR_1+1    ; zero page calculated

   ; point ZP_PTR_2 to midpoint of data
   lda #<(data+4)    ; immediate calculated address low byte
   sta ZP_PTR_2      ; zero page
   lda #>(data+4)    ; immediate calculated address high byte
   sta ZP_PTR_2+1    ; zero page calculated

   ; Copy data to results via ZP pointers
   lda (ZP_PTR_1)    ; zero page indirect
   sta results       ; absolute
   inx               ; implicit
   lda (ZP_PTR_1,x)  ; zero page indexed indirect
   sta results+1     ; absolute calculated
   lda (ZP_PTR_1),y  ; zero page indirect indexed with Y
   sta results,y     ; absolute indexed with Y

   jmp (lookup_ptr)  ; absolute indirect

lookup_ptr:
.addr lookup

lookup:
   jmp (jmp_table,x) ; abolute indexed indirect

jmp_table:
.addr start,return

return:
   rts
