        ;; ------------------------------------------------------
        ;; RND16 -- return new 16 bit random number in RND and W0
        ;; -------------------------------------------------------
        
        .text
        .align 4
RND16:  
        PUSH   LR
        KLOAD  X9, RND
        LDR    X0, [X9]
        BL     RND16B
        STR    X0, [X9]
        POP    LR
        RET

        ;; --------------------------------------------------------
        ;; RND16B -- (faster) return new 16 bit random number in W0
        ;; IMPORTANT W0 must contain previous random number, and be
        ;; initialized to a random seed, e.g., ACE1 before 1st call
        ;; --------------------------------------------------------

RND16B:
        EOR   W0, W0, W0, ASR #7        ; W0 ^= W0 >> 7
        EOR   W0, W0, W0, LSL #9        ; W0 ^= W0 << 9;
        AND   X0, X0, #0xffff           ; clear upper 32 bits
        EOR   W0, W0, W0, ASR #13       ; W0 ^= W0 >> 13
        RET

        .data
RND:    
        .word 0xACE1            	; any non-zero start state will work
