!AAmmo  = $18C5|!addr      ; must be the same as the one in buttonAmmo.asm
!BAmmo  = !AAmmo+1
!XYAmmo = !AAmmo+2
db $42 ; or db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
; JMP WallFeet : JMP WallBody ; when using db $37

MarioBelow:
MarioAbove:
MarioSide:

TopCorner:
BodyInside:
HeadInside:
;WallFeet:	; when using db $37
;WallBody:
INC !XYAmmo
%create_smoke()
%erase_block()
SpriteV:
SpriteH:

MarioCape:
MarioFireball:
RTL

print "Will increase the A button ammo."