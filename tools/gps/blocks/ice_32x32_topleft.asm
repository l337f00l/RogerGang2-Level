db $42
JMP Return : JMP Return : JMP Return : JMP Return : JMP Return : JMP Return : JMP FIAR
JMP Return : JMP Return : JMP Return

; Which map16 tile the block turns into.
!BlankTile = $0025

; ======================================================================
; ======================================================================

FIAR:
	PHY
	PHB
	PHK
	PLB
	
	%fireball_smoke()

	REP #$30
	LDY #$0006

MakingLoop1:
	LDX.w #!BlankTile
	%change_map16()
	%swap_XY()

	LDA $98
	CLC
	ADC TilePositionY1-$02,y
	STA $98
	LDA $9A
	CLC
	ADC TilePositionX1-$02,y
	STA $9A

	DEY
	DEY
	BPL MakingLoop1
	SEP #$30

	PLB
	PLY
Return:
	RTL

TilePositionX1:
	dw $0010,$FFF0,$0010
TilePositionY1:
	dw $0000,$0010,$0000

print "The top left of a 32x32 ice block that disappears when thawed."
