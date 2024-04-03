db $42
JMP Return : JMP Return : JMP Return : JMP Return : JMP Return : JMP Return : JMP FIAR
JMP Return : JMP Return : JMP Return

FIAR:
	%fireball_smoke()

	PHB					;\
	LDA #$02			;|
	PHA					;| Show coin and stuff
	PLB					;|
	JSL $02889D|!bank	;|
	PLB					;/

	%erase_block()

Return:
	RTL

print "A frozen block that gives a coin."
