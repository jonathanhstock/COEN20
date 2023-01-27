		.syntax		unified
		.cpu 		cortex-m4
		.text
		// void PutNibble(void *nibbles, uint32_t which, uint32_t value) ;
		// uint32_t GetNibble(void *nibbles, uint32_t which) ;

		.global 	PutNibble
		.thumb_func
		.align
		
		// R0: *nibbles
		// R1: which
		// R2: value
PutNibble:
		PUSH 	{R4}	
		LSR 	R4,R1,1 			//which >> 1
		LDRB 	R3,[R0,R4] 			//nibbles + R4
		// R3: pbyte
		AND 	R1,R1,1				//which & 1
		CMP		R1,1				//compare if R1 == 1
		ITTE	EQ
		ANDEQ	R3,R3,0b00001111 	//then R3 & 0b00001111
		LSLEQ	R2,R2,4				//then R2 <<4
		ANDNE 	R3,R3,0b11110000	//else R3 & 0b11110000
		ORR		R3,R3,R2			//R3 | R2
		STRB 	R3, [R0,R4]			//store R3 ->[R0,R4]
		POP 	{R4}
		BX 		LR

		.global 	GetNibble
		.thumb_func
		.align
		
		// R0: *nibbles
		// R1: which
GetNibble:	
		LSR 	R3,R1,1				//which >> 1
		LDRB	R2,[R0,R3]			//nibbles[R0+R3]
		// R2: 	byte		 
		AND		R1,R1,1				//R1 & 1
		CMP 	R1,1				//compare if R1 == 1
		IT		EQ
		LSREQ	R2,R2,4				//then R2 >> 4
		AND 	R2,R2,0b00001111	//R2 & 0b00001111
		MOV 	R0,R2				//move R2 -> R0
		BX 		LR
		
		.end
