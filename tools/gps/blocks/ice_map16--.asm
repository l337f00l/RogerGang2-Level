db $42
JMP Return : JMP Return : JMP Return : JMP Return : JMP Return : JMP Return : JMP FIAR
JMP Return : JMP Return : JMP Return

FIAR:
	%fireball_smoke()

	REP #$10
	LDX $03
	DEX
	%change_map16()
	SEP #$10

Return:
	RTL

print "A frozen block that thaws into the previous map16 tile."
