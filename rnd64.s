        ;; ------------------------------------------------------
        ;; RND64 -- return new 64 bit random number in RND and X0
        ;; -------------------------------------------------------
        
        .text
        .align 4
RND64:  
        PUSH   LR
        KLOAD  X9, RND
        LDR    X0, [X9]
        BL     RND64B
        STR    X0, [X9]
        POP    LR
        RET

        ;; --------------------------------------------------------
        ;; RND64B -- (faster) return new 64 bit random number in W0
        ;; IMPORTANT W0 must contain previous random number, and be
        ;; initialized to a random seed, e.g., ACE1 before 1st call
        ;; --------------------------------------------------------

RND64B:
	EOR   X0, X0, X0, LSL #13 ; X0 ^= X0 << 13
	EOR   X0, X0, X0, LSR #7  ; X0 ^= X0 >> 7
	EOR   X0, X0, X0, LSL #17 ; X0 ^= X0 << 17
        RET

        .data
RND:    
        .word 0xACE1            	; any non-zero start state will work
