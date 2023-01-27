#include <stdio.h>

int32_t Bits2Signed(int8_t bits[8]); //Convert array of bits to signed int
uint32_t Bits2Unsigned(int8_t bits[8]); //Convert array of bits to unsigned int
void	Increment(int8_t bits[8]); //Add 1 to value represented by bit pattern
void	Unsigned2Bits(uint32_t n, int8_t bits[8]); //Opposite of Bits2Unsigned

//Converts a binary number into a signed decimal number using the Bits2Unsigned function created
int32_t Bits2Signed(int8_t bits[8]){

	int32_t n = Bits2Unsigned(bits);
	if(n>127){
		n = n-256;
	}

	return n;
}

//Converts a binary number into an unsigned decimal number using the hint from the lab sheet
uint32_t Bits2Unsigned(int8_t bits[8]){
	
	uint32_t n = 0;

	for(int i=7; i>=0; i--){
		n = 2*n+bits[i];
	}

	return n;
}

//Increments the binary number by 1 but once it reaches the first 0 it breaks since the other digits are the same
void	Increment(int8_t bits[8]){

	for(int i = 0; i<=7; i++){
		if(bits[i] == 0){
			bits[i]=1;
			return;
		}
		if(bits[i] == 1){
			bits[i]=0;
		}
	}
}

//Converts unsigned decimal number to binary number by taking the remainder of each digit/2 and then dividing by 2 and looping until the end
void	Unsigned2Bits(uint32_t n, int8_t bits[8]){

	for(int i=0; i<=7; i++){
		bits[i]=n%2;
		n = n/2;
	}
}