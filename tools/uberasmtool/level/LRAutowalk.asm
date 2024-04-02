macro call_library(i)
	PHB
	LDA.b #<i>>>16
	PHA
	PLB
	JSL <i>
	PLB
endmacro


init:
	%call_library(autowalking_init)
	RTL

main:
	%call_library(LRpowerupselector_main)
	%call_library(autowalking_main)
	RTL