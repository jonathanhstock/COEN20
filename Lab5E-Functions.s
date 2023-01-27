		.syntax		unified
		.cpu 		cortex-m4
		.text
//	typedef struct {uint16_t cylinder; uint8_t head; uint8_t sector;}	CHS;
//	Function prototype: void Log2Phys(uint32_t lba, uint32_t heads, uint32_t sectors, CHS *phy);
		.global 	Log2Phys
		.thumb_func
		.align
Log2Phys:
		//	R0 = lba
		//	R1 = heads
		//	R2 = sectors
		//	R3 = *phy

		//	cylinder
		PUSH		{R4,R5}		// PUSH R4 and R5
		MUL			R4,R1,R2	// R4 <-- heads*sectors
		UDIV		R4,R0,R4	// R4 <-- lba/(heads*sectors)
		STRH 		R4,[R3]		// R4 --> phy
		

		//	head
		UDIV		R4,R0,R2	// R4 <-- lba/sectors
		UDIV		R5,R4,R1	// R5 <-- (lba/sectors)/heads
		MLS			R4,R1,R5,R4	// R4 <-- (lba/sectors) - (heads*((lba/sectors)/heads)
		STRB 		R4,[R3,2]	// R4 --> phy+2

		//	sector
		UDIV 		R4,R0,R2	// R4 <-- lba/sectors
		MLS			R5,R2,R4,R0	// R5 <-- lba - sectors*(lba/sectors)
		ADDS		R5,R5,1		// R5 <-- R5 + 1
		STRB 		R5,[R3,3]	// R5 --> phy+3
		POP			{R4, R5}	// POP R4 and R5

		BX			LR			// return

		.end
