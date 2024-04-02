;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; SMW Wall Springboards (sprites 6B & 6C), by imamelia
;;
;; This is a disassembly of sprites 6B and 6C in SMW, the wall springboards (or
;; Pea Bouncers, as they have come to be known).
;;
;; Uses first extra bit: YES
;;
;; If the extra bit is clear, the springboard will be attached to the left wall like sprite 6B.
;; If the extra bit is set, the springboard will be attached to the right wall like sprite 6C.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; defines and tables
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BounceSpeed:
db $B6,$B4,$B0,$A8,$A0,$98,$90,$88

BouncePhysics:
db $01,$01,$03,$05,$07

YSpeedSet:
db $00,$00,$E8,$E0,$D0,$C8,$C0,$B8

XDisp:
db $00,$08,$10,$18,$20,$00,$08,$10,$18,$20
db $00,$08,$10,$18,$20,$00,$08,$10,$18,$1F
db $00,$08,$10,$17,$1E,$00,$08,$0F,$16,$1D
db $00,$07,$0F,$16,$1C,$00,$07,$0E,$15,$1B

YDisp:
db $00,$00,$00,$00,$00,$00,$01,$01,$01,$02
db $00,$00,$01,$02,$04,$00,$01,$02,$04,$06
db $00,$01,$03,$06,$08,$00,$02,$04,$08,$0A
db $00,$02,$05,$07,$0C,$00,$02,$05,$09,$0E

!Tilemap = $3D	; the tile used by the wall springboards

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; init routine
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print "INIT ",pc

LDA !7FAB10,x	;
AND #$04	;
LSR		;
LSR		;
STA !1510,x	;
BEQ EndInit	;

LDA !E4,x	;
SEC		;
SBC #$08		;
STA !E4,x		;
LDA !14E0,x	;
SBC #$00		;
STA !14E0,x	;

EndInit:		;
RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; main routine wrapper
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print "MAIN ",pc
PHB
PHK
PLB
JSR WallSpringboardMain
PLB
RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; main routine
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WallSpringboardMain:

LDA #$00
%SubOffScreen()		;
JSR WallSpringboardGFX	;

LDA $9D			;
BNE Return00		; return if sprites are locked

LDA !1534,x		; $1534,x = timer to set the player's Y speed?
BEQ NoSetYSpeed		;
DEC !1534,x		;
BIT $15			; if the player isn't jumping...
BPL NoSetYSpeed		; don't set his/her Y speed
STZ !1534,x		;
LDY !151C,x		;
LDA BounceSpeed,y	; set the player's Y speed
STA $7D			;
LDA #$08		;
STA $1DFC|!Base2	; play a "boing" sound effect
NoSetYSpeed:		;

LDA !1528,x		;
JSL $0086DF|!BankB	;

dw Return00		;
dw State01		;
dw State02		;

Return00:		;
RTS			;

State01:

LDA !1540,x		;
BEQ Continue00		;
DEC			;
BNE Return00		;
INC !1528,x		;
LDA #$01			;
STA !157C,x		;
RTS			;

Continue00:		;

LDA !C2,x		;
BMI Label00		;
CMP !151C,x		;
BCS Continue01		;
Label00:			;
CLC			;
ADC #$01		;
STA !C2,x		;
RTS			;

Continue01:		;

LDA !151C,x		;
STA !C2,x		;
LDA #$08			;
STA !1540,x		;
RTS			;

State02:

INC !1570,x	;
LDA !1570,x	;
AND #$03	;
BNE Label01	;
DEC !151C,x	;
BEQ ZeroSpriteState	;
Label01:		;
LDA !151C,x	;
EOR #$FF		;
INC		;
STA $00		;
LDA !157C,x	;
AND #$01	;
BNE DecState4	;

LDA !C2,x	;
CLC		;
ADC #$04	;
STA !C2,x	;
BMI Return01	;
CMP !151C,x	;
BCS Continue02	;
RTS		;

Continue02:	;

LDA !151C,x	;
STA !C2,x	;
INC !157C,x	;
Return01:		;
RTS		;

DecState4:

LDA !C2,x	;
SEC		;
SBC #$04		;
STA !C2,x	;
BPL Return01	;
CMP $00		;
BCC Continue03	;
RTS

Continue03:

LDA $00		;
STA !C2,x	;
INC !157C,x	;
RTS		;

ZeroSpriteState:

STZ !C2,x	;
STZ !1528,x	;
RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; graphics routine, plus some other stuff
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WallSpringboardGFX:

%GetDrawInfo()		;

LDA #$04		;
STA $02			;

LDA !1510,x		;
STA $05			;

LDA !C2,x		;
STA $03			;
BPL NoInvertState	;
EOR #$FF		;
INC			;
NoInvertState:		;
STA $04			;
LDY !15EA,x		;

GFXLoop:		;

LDA $04			;
ASL #2			;
ADC $04			;
ADC $02			;
TAX			;

LDA $05			;
LSR			;
LDA XDisp,x		;
BCC NoInvert00		;
EOR #$FF		;
INC			;
NoInvert00:		;
STA $08			;
CLC			;
ADC $00			;
STA $0300|!Base2,y		;

LDA $03			;
ASL			;
LDA YDisp,x	;
BCC NoInvert01	;
EOR #$FF		;
INC		;
NoInvert01:	;
STA $09		;
CLC		;
ADC $01		;
STA $0301|!Base2,y	;

LDA #!Tilemap	;
STA $0302|!Base2,y	;

LDA $64		;
ORA #$0A	;
STA $0303|!Base2,y	;

LDX $15E9|!Base2	;
PHY		;
JSR Interaction	;
PLY		;
INY #4		;
DEC $02		;
BMI EndGFX	;
JMP GFXLoop	;

EndGFX:		;

LDY #$00		;
LDA #$04		;
JSL $01B7B3|!BankB	;
Return02:		;
RTS

Interaction:

LDA $71			;
CMP #$01		;
BCS Return02		;
LDA $81			;
ORA $7F			;
ORA !15A0,x		;
ORA !186C,x		;
BNE Return02		;

LDA $7E			;
CLC			;
ADC #$02		;
STA $0A			;

LDA $187A|!Base2	;
CMP #$01		;
LDA #$10		;
BCC Label02		;
LDA #$20		;
Label02:		;
CLC			;
ADC $80			;
STA $0B			;

LDA $0300|!Base2,y		;
SEC			;
SBC $0A			;
CLC			;
ADC #$08		;
CMP #$14		;
BCS Return03		;

LDA $19			;
CMP #$01		;
LDA #$1A		;
BCS Label03		;
LDA #$1C		;
Label03:		;
STA $0F			;

LDA $0301|!Base2,y	;
SEC			;
SBC $0B			;
CLC			;
ADC #$08		;
CMP $0F			;
BCS Return03		;
LDA $7D			;
BMI Return03		;

LDA #$1F		;
PHX			;
LDX $187A|!Base2	;
BEQ Label04		;
LDA #$2F		;
Label04:		;
STA $0F			;
PLX			;

LDA $0301|!Base2,y	;
SEC			;
SBC $0F			;
PHP			;
CLC			;
ADC $1C			;
STA $96			;
LDA $1D			;
ADC #$00		;
PLP			;
SBC #$00		;
STA $97			;

STZ $72			;
LDA #$02		;
STA $1471|!Base2	;
LDA !1528,x		;
BEQ SetPhysics		;
CMP #$02		;
BEQ SetPhysics	;

LDA !1540,x	;
CMP #$01		;
BNE Return03	;
LDA #$08		;
STA !1534,x	;
LDY !C2,x	;
LDA YSpeedSet,y	;
STA $7D		;

Return03:
RTS

SetPhysics:

STZ $7B			;
LDY $02			;
LDA BouncePhysics,y	;
STA !151C,x		;
LDA #$01			;
STA !1528,x		;
STZ !1570,x		;
RTS			;