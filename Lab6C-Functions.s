		.syntax		unified
		.cpu 		cortex-m4
		.text
		// void CopyCell(uint32_t *dst, uint32_t *src) ;
		// void FillCell(uint32_t *dst, uint32_t pixel) ;

		.global 	CopyCell
		.thumb_func
		.align
		
		// R0: *dst
		// R1: *src
CopyCell:	
			PUSH 	{R4}
			LDR 	R2,=0				// row		
		L0:
			LDR 	R3,=0				// col
			CMP		R2,60				// compares row with 60
			BLO		L1					// go to L1 if row < 60
			POP		{R4}
			BX 		LR 					// return
		L1:
			CMP		R3,60				// compares col with 60
			BLO		L2					// go to L2 if col < 60
			ADD		R2,R2,1				// increment row
			ADD		R0,R0,960			// dst += 960
			ADD		R1,R1,960			// src += 960
			B 		L0
		L2:
			LDR		R4,[R1,R3,LSL 2]	// sets src[col] into dst[col]
			STR 	R4,[R0,R3,LSL 2]
			ADD		R3,R3,1				// increment col
			B 		L1					// go to L1

		.global 	FillCell
		.thumb_func
		.align
		
		// R0: *dst
		// R1: pixel
FillCell:	
			LDR 	R2,=0				// row
		L3:
			LDR 	R3,=0				// col
			CMP		R2,60				// compares row and 60
			BLO		L4					// go to L4 if row < 60
			BX 		LR 					// return
		L4:
			CMP		R3,60				// compares col with 60
			BLO		L5					// go to L5 if col < 60
			ADD		R2,R2,1				// increments row
			ADD		R0,R0,960			// dst += 960
			B 		L3					// go to L3
		L5:
			STR 	R1,[R0,R3,LSL 2]	// sets pixel into dst[col]
			ADD		R3,R3,1				// increments col
			B 		L4					// go to L4
		
		.end
