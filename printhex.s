	.text
	.align 4
printhex:	
	PUSH  LR
	PUSH  X0
	PUSH  X1
	PUSH  X2
	PUSH  X3
	PUSH  X4
	PUSH  X5
	KLOAD X1, hexbuf
	ADD   X1, X1, #15
	MOV   W5, #16	
printhex1:
	AND   W2, W0, #0xf
	KLOAD X3, hexchars
	LDR   W4, [X3, X2]
	STRB  W4, [X1]	
	SUB   X1, X1, #1
	LSR   X0, X0, #4
	SUBS  W5, W5, #1
	B.NE  printhex1	

	MOV   X0, #1    
	KLOAD X1, hexbuf
	MOV   X2, #16	
	MOV   X16, #4   
	SVC   0     	
	
    	POP   X5
    	POP   X4
    	POP   X3
    	POP   X2
    	POP   X1
	POP   X0
	POP   LR
	
	RET

	BUFSIZ=4
printhexword:	
	PUSH  LR
	PUSH  X0
	PUSH  X1
	PUSH  X2
	PUSH  X3
	PUSH  X4
	PUSH  X5
	KLOAD X1, hexbuf+BUFSIZ-1
	MOV   W5, #BUFSIZ
1:
	AND   W2, W0, #0xf
	KLOAD X3, hexchars
	LDR   W4, [X3, X2]
	STRB  W4, [X1]	
	SUB   X1, X1, #1
	LSR   X0, X0, #4
	SUBS  W5, W5, #1
	B.NE  1b	
	MOV   X0, #1    	; stdout
	KLOAD X1, hexbuf	; start addr
	MOV   X2, #BUFSIZ	; nr of chars
	MOV   X16, #4   	; write
	SVC   0
    	POP   X5
    	POP   X4
    	POP   X3
    	POP   X2
    	POP   X1
	POP   X0
	POP   LR
	RET

hexchars:
	.ascii  "0123456789ABCDEF"
	.data
hexbuf:
	.ascii  "0000000000000000"

