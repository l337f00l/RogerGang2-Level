; insert act as 25
db $42
JMP Mario : JMP Mario : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return
JMP Mario : JMP Mario : JMP Mario

Mario:
    STZ $1407|!addr
Return:
    RTL

print "Stops Mario from flying."