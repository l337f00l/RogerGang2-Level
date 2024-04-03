;  Powerup selector with L/R, by Darolac
; This code allows to gain a configurable powerup after pressing L, R or both. 

!powerup1 = $02 ; powerup status that is gained upon pressing R: #$00 = small; #$01 = big; #$02 = cape; #$03 = fire.

!powerup2 = $03 ; powerup status that is gained upon pressing L. 

!powerup3 = $00 ; powerup status that is gained upon pressing L+R. 

!R = 1  ; set this to 0 if you don't want to gain a powerup after pressing R.
!L = 1 ; set this to 0 if you don't want to gain a powerup after pressing L.
!LR = 1 ; set this to 0 if you don't want to gain a powerup after pressing L+R.

main:

lda $9D
ora  $13D4|!addr
bne .ret
lda $18
if !R
bit #$10
beq +
ldy #!powerup1
sty $19
+
endif
if !L
bit #$20
beq +
ldy #!powerup2
sty $19
+
endif
if !LR
lda $17
and #$30
cmp #$30
bne +
lda #!powerup3
sta $19
+
endif
.ret
rtl