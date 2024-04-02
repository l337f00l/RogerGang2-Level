; act as 25

; Smoke sprite number from puff_of_smoke.asm patch
!smoke_num = $12

db $42

jmp Return : jmp Return : jmp Return
jmp Sprite : jmp Sprite : jmp Return : jmp Return
jmp Return : jmp Return : jmp Return

Sprite:
    ; Spawn the smoke sprite
    lda.b #!smoke_num
    clc
    phx
    %spawn_sprite()
    plx

    ; Kill the original sprite
    stz !14C8,x

    ; Move the new sprite where the old one was
    bcs Return
    sta $04
    %move_spawn_to_sprite()

    ; If the block is on Layer 2, fix the sprite position
    lda $185E|!addr : beq Return
    phx
    ldx $04
    lda !sprite_x_low,x : sec : sbc $26 : sta !sprite_x_low,x
    lda !sprite_x_high,x : sbc $27 : sta !sprite_x_high,x
    lda !sprite_y_low,x : sec : sbc $28 : sta !sprite_y_low,x
    lda !sprite_y_high,x : sbc $29 : sta !sprite_y_high,x
    plx
Return:
    rtl

print "A block that kills sprites. Does not work for sprites that do not have object interaction."
