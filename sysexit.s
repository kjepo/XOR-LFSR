	.text
	.align 4
sysexit:			// exit(0)
	MOV   X0, #0 
	MOV   X16, #1
	SVC   0      			

