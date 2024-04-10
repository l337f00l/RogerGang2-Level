;<  Defines  >;

!CrouchGliding = 1	;>	Enable (set to 1) and you'll be able to glide while crouched at the same time.
!SpinGliding = 1	;>	Enable (set to 1) and you'll be able to glide while spin jumping at the same time.
!YoshiGliding = 1	;>	Enable (set to 1) and you'll be able to glide while riding Yoshi at the same time.
!CarryGliding = 1	;>	Enable (set to 1) and you'll be able to glide while carrying an object at the same time.

;<  Code  >;

db $42
rep 3 : JMP Mario		;>	Sides.
rep 4 : JMP NotMario	;>	Sprites, fireball and cape.
rep 3 : JMP Mario		;>	Corners and inside.

Mario:
	lda #$02
	sta $19
	lda	$72				;\
	beq	NotMario		;/	Skip if not touching floor.
	lda	$15				;\
	ora	$16				; |
	and	#$40			; |	Skip if not holding Y/X.
	beq	NotMario		;/
	lda $1407|!addr		;>	Load flying """flag""".
	if !CrouchGliding == 0
		ora	$73				;>	Check for crouch flag if !CrouchGliding is set to 0.
	endif
	if !SpinGliding == 0
		ora	$140D|!addr		;>	Check for spin jump flag if !SpinGliding is set to 0.
	endif
	if !YoshiGliding == 0
		ora	$187A|!addr		;>	Check for riding Yoshi flag if !YoshiGliding is set to 0.
	endif
	if !CarryGliding == 0
		ora	$1470|!addr		;\
		ora	$148F|!addr		;/	Check for carrying object flags if !CarryGliding is set to 0.
	endif
	bne NotMario		;>	Skip if we're flying already or any condition above is met.
	ldx $19				;\
	cpx #$02			; |	No cape no flight.
	bne NotMario		;/
	
	dex					;>	X = 1
	stx $1407|!addr		;\		 >	Store 1 there.
	lda #$03			; |	Enable flight.
	sta $1408|!addr		;/
	lda #$70			;\
	sta $13E0|!addr		;/	Put run status to maximum.

NotMario:
	rtl					;>	Return.

print "Puts the player in gliding state if it has cape."