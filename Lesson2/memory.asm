.org $080D
.segment "ONCE"

ZP_PTR_1 = $30
ZP_PTR_2 = $32
ZP_DATA  = $34

   jmp start         ; absolute

data:
.byte $01,$23,$45,$67,$89,$AB,$CD,$EF

results:
.byte 0,0,0

start:
   ; copy first three bytes of data to ZP_DATA
   lda data          ; absolute                    : a = (data)      : Value = $01
   sta ZP_DATA       ; zero page                   : (ZP_DATA) = a   : Value = $01
   ldx #1            ; immediate                   : x = 1           : Value = 1
   lda data,x        ; absolute indexed with X     : a = (data+x)    : Value = $23
   sta ZP_DATA,x     ; zero page indexed with X    : (ZP_DATA+x) = a : Value = $23
   txa               ; implied (transfer X to A)   : a = x           : Value = 1
   tay               ; implied (transfer A to Y)   : y = a           : Value = 1
   iny               ; implied (increment Y)       : y = y + 1       : Value = 2
   lda data,y        ; absolute indexed with Y     : a = (data+y)    : Value = $45
   sta ZP_DATA,y     ; zero page indexed with Y    : (ZP_DATA+y) = a : Value = $45

   ; point ZP_PTR_1 to beginning of data
   lda #<data        ; immediate address low byte
   sta ZP_PTR_1      ; zero page
   lda #>data        ; immediate address high byte
   sta ZP_PTR_1+1    ; zero page calculated        : (ZP_PTR_1) = data

   ; point ZP_PTR_2 to midpoint of data
   lda #<(data+4)    ; immediate calculated address low byte
   sta ZP_PTR_2      ; zero page
   lda #>(data+4)    ; immediate calculated address high byte
   sta ZP_PTR_2+1    ; zero page calculated        : (ZP_PTR_2) = data+4

   ; Copy data to results via ZP pointers
   lda (ZP_PTR_1)    ; zero page indirect                : a = ((ZP_PTR_1))   : Value = $01
   sta results       ; absolute                          : (results) = a      : Value = $01
   inx               ; implied                           : x = x + 1          : Value = 2
   lda (ZP_PTR_1,x)  ; zero page indexed indirect        : a = ((ZP_PTR_1+x)) : Value = $89
   sta results+1     ; absolute calculated               : (results+1) = a    : Value = $89
   lda (ZP_PTR_1),y  ; zero page indirect indexed with Y : a = ((ZP_PTR_1)+y) : Value = $45
   sta results,y     ; absolute indexed with Y           : (results+y) = a    : Value = $45

   jmp (lookup_ptr)  ; absolute indirect                 : goto (lookup_ptr)  : Value = lookup

lookup_ptr:
.addr lookup

lookup:
   jmp (jmp_table,x) ; abolute indexed indirect          : goto (jmp_table+x) : Value = return

jmp_table:
.addr start,return

return:
   rts
