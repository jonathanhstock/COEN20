	.syntax		unified
	.cpu		cortex-m4
	.text

/* uint32_t Decr(uint32_t x); */
	.global		Less1
	.thumb_func
	.align
Less1:
	SUB			R0,R0,1     	//x-1
	BX			LR

	.global		Add
	.thumb_func
	.align
Add:
	ADD 		R0, R0, R1		//a+b
	BX			LR

	.global		Square2x
	.thumb_func
	.align
Square2x:
	ADD 		R0, R0, R0		//x+x
	PUSH		{LR}
	BL			Square 			//Calls Square
	POP			{PC}
	

	.global 	Last
	.thumb_func
	.align
Last:
	PUSH		{R4, LR}
	MOV			R4, R0			//Moves R0 into temp R4
	BL			SquareRoot		//Calls SquareRoot Function
	ADD 		R0, R4, R0		//Adds x+answer of SquareRoot
	POP			{R4, PC}

	/* End of file */
	.end
