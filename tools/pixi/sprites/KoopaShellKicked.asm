;================================================
; Spawn Kicked Shell
; By Erik557
;
; Description: This will spawn a koopa shell in
; a kicked state. Requested by lolyoshi.
;
; Uses first extra property byte: YES
; 00 - Spawns a green shell.
; 01 - Spawns a red shell.
; 02 - Spawns a blue shell.
; 03 - Spawns a yellow shell.
;================================================

print "MAIN ",pc
       LDA !7FAB28,x
       TAX
       LDA.l colorToSpawn,x
       LDX $15E9|!Base2
       STA !9E,x
       JSL $07F7D2
       LDA #$0A
       STA !14C8,x
       LDY #$00
       LDA $94
       SEC
       SBC !E4,x
       STA $0F
       LDA $95
       SBC !14E0,x
       BMI $01
       INY
       TYA
       STA !157C,x
       TYX
       LDA.l $01A6D7,x
       LDX $15E9|!Base2
       STA !B6,x
       LDA #$03
       STA $1DF9|!Base2
print "INIT ",pc
       RTL

colorToSpawn:
       db $04,$05,$06,$07