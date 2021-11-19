        #include "kload.s"
        #include "kprint.s"
        #include "pushpop.s"
        #include "printhex.s"
        #include "sysexit.s"
	#include "rnd64.s"
        
	.text
        .align 4
        .global _main
_main:
        MOV    X1, #65535	; print 65535 random numbers
        KLOAD  X0, RND
        LDR    X0, [X0]		; load initial seed
L1:
        BL     RND64B		; get next random number in X0 
        BL     printhex		; print X0 as 8 byte hex string
        KPRINT "\n"
        SUBS   X1, X1, #1
        B.GT   L1
        B      sysexit		; exit
