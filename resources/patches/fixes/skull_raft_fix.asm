incsrc "../../../shared/freeram.asm"

if read1($00FFD5) == $23
	sa1rom
	!sa1 = 1
	!addr = $6000
	!bank = $000000
else
	lorom
	!sa1 = 0
	!addr = $0000
	!bank = $800000
endif

!Freeram = !skull_raft_fix_freeram	;This address may be cleared whenever you want,
				;except when the sprite codes are running. When all sprite codes are done
				;(or if Mario isn't on a skull raft), feel free to use it for anything. The default is cleared on level load.

org $02EE96
	autoclean JML Main

freedata		; No changes in DB register, might as well toss this into the banks 40+
Main:
	LDA $14
	CMP !Freeram
	BEQ DontMove
	STA !Freeram

	LDY #$00
	LDA $1491|!addr
	JML $02EE9B|!bank

DontMove:
	JML $02EEA8|!bank