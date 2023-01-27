		.syntax		unified
		.cpu 		cortex-m4
		.text
		// uint32_t Zeller1(uint32_t k, uint32_t m, uint32_t D, uint32_t C) ;
		// uint32_t Zeller2(uint32_t k, uint32_t m, uint32_t D, uint32_t C) ;
		// uint32_t Zeller3(uint32_t k, uint32_t m, uint32_t D, uint32_t C) ;		

		// R0: k
		// R1: m
		// R2: D
		// R3: C

		.global 	Zeller1
		.thumb_func
		.align
		
Zeller1:
		PUSH 	{R4,R5,R6,R7}
		LDR 	R4,=13
		LDR 	R5,=1
		MUL 	R4,R4,R1 	// 13*m
		SUB 	R4,R4,R5	// 13*m - 1
		LDR 	R5,=5		
		UDIV	R4,R4,R5	// ((13*m)-1)/5
		LDR 	R5,=4
		UDIV 	R5,R2,R5 	// D/4
		LDR 	R6,=4
		UDIV 	R6,R3,R6 	// C/4
		LDR 	R7,=2
		MUL 	R7,R7,R3 	// 2*C

		ADD 	R0,R0,R4	// k + (13*m-1)/5
		ADD 	R0,R0,R2 	// k + (13*m-1)/5 + D
		ADD 	R0,R0,R5	// k + (13*m-1)/5 + D + D/4
		ADD 	R0,R0,R6 	// k + (13*m-1)/5 + D + D/4 + C/4
		SUB 	R0,R0,R7 	// k + (13*m-1)/5 + D + D/4 + C/4 - 2*C 

		// f%7 taken from textbook
		LDR 	R4,=7 
		SDIV 	R5,R0,R4
		MLS 	R6,R4,R5,R0
		AND 	R5,R4,R6,ASR 31
		ADDS.N 	R0,R6,R5

		// if R0 < 0 then R0 += 7
		CMP 	R0,0
		IT 		LO
		ADDLO	R0,R0,R4

		POP 	{R4,R5,R6,R7}
		BX 		LR


		.global 	Zeller2
		.thumb_func
		.align
		
Zeller2:	
		PUSH 	{R4,R5,R6,R7,R8,R9}
		LDR 	R4,=13
		LDR 	R5,=1
		MUL 	R4,R4,R1 	// 13*m
		SUB 	R4,R4,R5	// 13*m - 1
		LDR 	R5,=3435973837		
		UMULL	R9,R8,R5,R4	// ((13*m)-1)/5 
		LSR 	R4,R8,2 	// ((13*m)-1)/5
		LSR 	R5,R2,2		// D/4
		LSR 	R6,R3,2		// D/4
		LDR 	R7,=2
		MUL 	R7,R7,R3 	// 2*C

		ADD 	R0,R0,R4	// k + (13*m-1)/5
		ADD 	R0,R0,R2 	// k + (13*m-1)/5 + D
		ADD 	R0,R0,R5	// k + (13*m-1)/5 + D + D/4
		ADD 	R0,R0,R6 	// k + (13*m-1)/5 + D + D/4 + C/4
		SUB 	R0,R0,R7 	// k + (13*m-1)/5 + D + D/4 + C/4 - 2*C 
		
		// f%7
		LDR 	R4,=2454267027 	//R5 = k/7
		SMMLA 	R9,R4,R0,R0		//R5 = k/7
		LSR 	R5,R0,31		//R5 = k/7
		ADD 	R5,R5,R9,ASR 2 	//R5 = k/7
		LDR 	R4,=7
		MLS 	R6,R4,R5,R0
		AND 	R5,R4,R6,ASR 31
		ADDS.N 	R0,R6,R5

		// if R0 < 0 then R0 += 7
		CMP 	R0,0
		IT 		LO
		ADDLO	R0,R0,R4

		POP 	{R4,R5,R6,R7,R8,R9}
		BX 		LR

		.global 	Zeller3
		.thumb_func
		.align
		
Zeller3:	
		PUSH 	{R4,R5,R6,R7}
		LDR 	R5,=1
		ADD 	R4,R1,R1,LSL 4 	//16*m + m
		SUB 	R4,R4,R1,LSL 2 	//17*m - 4*m 
		SUB 	R4,R4,R5		// 13*m - 1
		LDR 	R5,=5		
		UDIV	R4,R4,R5		// ((13*m)-1)/5
		LDR 	R5,=4
		UDIV 	R5,R2,R5 		// D/4
		LDR 	R6,=4
		UDIV 	R6,R3,R6 		// C/4
		LSL 	R7,R3,1			// 2*C

		ADD 	R0,R0,R4		// k + (13*m-1)/5
		ADD 	R0,R0,R2 		// k + (13*m-1)/5 + D
		ADD 	R0,R0,R5		// k + (13*m-1)/5 + D + D/4
		ADD 	R0,R0,R6 		// k + (13*m-1)/5 + D + D/4 + C/4
		SUB 	R0,R0,R7 		// k + (13*m-1)/5 + D + D/4 + C/4 - 2*C 

		// f%7
		LDR 	R4,=7 			
		SDIV 	R5,R0,R4		// R5 = k/7
		LSL 	R6,R5,3			// R6 = 8*R5
		SUB 	R6,R6,R5		// R6 = 8*R5 - R5
		SUB 	R6,R0,R6 		// R6 = R0 - R6
		AND 	R5,R4,R6,ASR 31
		ADDS.N 	R0,R6,R5

		// if R0 < 0 then R0 += 7
		CMP 	R0,0
		IT 		LO
		ADDLO	R0,R0,R4

		POP 	{R4,R5,R6,R7}
		BX 		LR
		
		.end	
