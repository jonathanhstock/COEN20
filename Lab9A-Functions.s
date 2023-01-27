		.syntax		unified
		.cpu 		cortex-m4
		.text
		// float   DeltaX(void) ;
		// void    UpdateDisplay(unsigned n, float r, float v, float a) ;
		// void __attribute__((weak)) Integrate(void) ;		

		

		.global 	Integrate
		.thumb_func
		.align

Integrate:
		PUSH 		{LR, R4}
		VPUSH 		{S16,S17,S18,S19,S20,S21}

		BL 			DeltaX			// dx = S0
		VMOV 		S21,S0			// S21: dx

		VSUB.F32 	S16,S0,S0 		//v = 0.0
		VSUB.F32 	S17,S0,S0 		//a = 0.0 		
		VMOV 		S18,1.0 		//x = 1.0 	
		VMOV 		S19,1.0 		//r = 1.0
		MOV 		R4,0 			//n = 0		

loop:	
		MOV 		R0,R4 			//R0: n 
		VMOV 		S0,S19 			//S0: r
		VMOV 		S1,S16			//S1: v
		VMOV 		S2,S17			//S2: a
		BL 			UpdateDisplay

		VMOV 		S20,S16 		// S20: prev = v

		VMOV        S12,1.0 	   	// S14: 1.0
        

        VDIV.F32    S8,S12,S18    	// 1/x
        VADD.F32    S11,S18,S21    	// x+dx
        VDIV.F32    S11,S12,S11    	// 1/(x+dx) 
        VADD.F32    S8,S11,S8    	// S19 = S11 + S8
        VMOV        S15,2.0 	   	// moves 2 into S15
        VDIV.F32    S19,S8,S15    	// S19 / 2

        VMUL.F32    S9,S19,S19     	// r*r
        VADD.F32    S16,S16,S9     	// v += r*r

        VADD.F32    S17,S17,S19    	// a += r

        ADD         R4,R4,1			// n++
        VADD.F32    S18,S18,S21    	// x+= dx    
		

		VCMP.F32 	S16,S20
		VMRS 	 	APSR_nzcv,FPSCR
		BNE 		loop	
	
		VPOP 		{S16,S17,S18,S19,S20,S21}
		POP 		{PC, R4}
		BX 			LR
		.end	
