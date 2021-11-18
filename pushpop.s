// ARM hardware requires that the stack pointer is always 16-byte aligned.
// We're wasting 8 bytes here because \register is only 8 bytes in size.

.macro	PUSH  	register			// push register on data stack
	STR   	\register, [SP, #-16]!
.endm

.macro	POP   	register			// pop register from data stack
	LDR   	\register, [SP], #16
.endm	
