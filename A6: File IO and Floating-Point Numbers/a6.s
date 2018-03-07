/*
Name: Muzhou, Zhai	
Course: CPSC 355	
Tutorial Section: T01
Assignment 6
*/

! local registers macros





! constant macros



! floating point registers macros

















		.section 		".data"
headerString:	
		.asciz 			"Input\t\tSine\t\tCosine\n-----------------------------------------------\n"
dataString:
		.asciz			"%f\t"
newLineString:
		.asciz 			"\n"
		
		.align 			8
		.global 		input
input:	.double			0r0.0
limit:	.double			0r1.0e-10 
zero: 	.double 			0r0.0 
one:		.double			0r1.0
negOne: 	.double 			-1.0
twopi:	.double 			0r180.0 					
pi:		.double 			0r3.141592654
	
		.section		".text"

		.global 		main				
main:
		save			%sp, -(92 + 8) & -8, %sp
		cmp 			%i0, 2					! opening the input file 
		bne 			done						! if branch not equal 
		nop 										! delay slot
		
printHeader:
		set 			headerString, %o0		! set the headString into the register %o0
		call 			printf					! call printf
		nop 										! delay slot
		
		mov				1, %l1	! moving the value 1 into the register %argCounter
		sll				%l1, 2, %l2 ! shifting the counter left by 2 for the address
		ld		   		[%i1 + %l2], %l0	! loading the address into the register %l0
		
		mov 			%l0, %o0				! moving %l0 into the register %o0 
		clr				%o1					! clear the register %o1
		clr				%o2					! clear the register %o2
		mov 			5, %g1				! move 5 to the register %g1
		ta				0							! exit the program
		bcc 			open_ok					! if equal to 0, branch jump to open_ok
		nop 										! delay slot
		ba 				done					! branch always goto done
		nop 										! delay slot

open_ok:
		mov 			%o0, %l0				! moving the input value in the register %o0 intov the %l0


readFile:
		mov				%l0, %o0			! moving the value in the register %l0 into the register %o0				
		mov 			3, %g1				! moving the value of variable RAED to %g1
		set 			input, %o1				! moving the value of variable input to %o1		
		mov 			8, %o2 		! moving the value of variable 8 into the  register %o2
		ta 				0						! exit the file

		cmp 			%o0, 0					! comparing the value in teh register %o0 with 0
		ble 			done						! if the value in the register %o0 is less or equal than 0
		nop 										! delay slot			
			
		set 			input, %l3		! setting the value of input into the register %l3


printData:		
		! print input data
		set 			dataString, %o0		! setting the dataString into the register %o0
		ld 				[%l3], %o1	! loading the input value into the register %o1		
		ld 				[%l3 - 4], %o2	! loading the address of the input into the register %o2		
		call 			printf						! call printf
		nop 										! delay slot
		
		! call sine function
		! print sine result
		ldd 			[%l3], %o0				! load input to o0
		mov 			0, %o1 							! move 0 to o1 (sine)
		call			trig								! calling trig
		nop 												! delay slot
		std 			%f0, [%fp - 8] 				! store result to stack memory
		set 			dataString, %o0				! set dataString to o0
		ld 				[%fp - 8], %o1				! load first half of stack memory to o1
		ld 				[%fp - 4], %o2				! load second half of stack memory to o1
		call			printf 							! calling printf
		nop 												! delay slot 

		! call cosine function
		! print cosine result
		ldd 			[%l3], %o0				! load input to o0
		mov 			1, %o1 							! move 1 to o1 (cosine)
		call			trig								! calling trig
		nop 												! delay slot
		std 			%f0, [%fp - 8] 				! store result to stack memory
		set 			dataString, %o0				! set dataString to o0
		ld 				[%fp - 8], %o1				! load first half of stack memory to o1
		ld 				[%fp - 4], %o2				! load second half of stack memory to o1
		call			printf 							! calling printf
		nop 												! delay slot  									

		! print new line
		set 			newLineString, %o0 			! set newLineString to o0
		call 			printf 							! calling printf
		nop 												! delay slot		 									! delay slot
		fba 			readFile
		nop 												! delay slot

done:
		mov 			1, %g1 							! exit request
		ta 				0 								! trap to system


		.align 			4	 							! set alignment
		.global 		trig 								! declare global variable
trig:
		save 			%sp, -(92 + 8) & -8, %sp	! allocate stack memory
		std 			%i0, [%fp - 8]					! store first argument to stack memory
		ldd				[%fp - 8], %f2			! load stack memory to x

		set 			limit, %o0						! set limit to o0
		ldd 			[%o0], %f24					! limit = 1.0e-10 

		set 			one, %o0 						! set one to o0
		ldd 			[%o0], %f4 					! n = 1
		ldd 			[%o0], %f6						! i = 1
		ldd 			[%o0], %f14					! term = 1
		ldd 			[%o0], %f10					! num = 1
		ldd 			[%o0], %f12					! den = 1
		ldd 			[%o0], %f16				! absTerm = 1
		ldd 			[%o0], %f20					! one = 1

		set 			zero, %o0 						! set zero to o0
		ldd 			[%o0], %f0 					! y = 0
		ldd 			[%o0], %f18 				! zero = 0

		set 			negOne, %o0 					! set negative one to o0
		ldd 			[%o0], %f22 				! negOne = -1

		set 			pi, %o0 							! set pi to o0
		ldd 			[%o0], %f8 					! pi = 3.141592654

		set 			twopi, %o0 						! set twopi to o0
		ldd 			[%o0], %f26 				! twopi = 180

		mov 			1, %l4 		! whileLoopCount = 1

convertToRadian:
		fmuld 			%f2, %f8, %f2 		! x *= pi
		fdivd 			%f2, %f26, %f2 	! x /= 180

whileTest:
		fabss			%f14, %f16	 		! absTerm = |term|
		fcmpd 			%f16, %f24 		! compare 
		nop 												! delay slot

		fbl 			returnTrig
		nop 												! delay slot

		set 			one, %o0 						! set one to o0
		ldd 			[%o0], %f10 					! numerator = 1
		ldd 			[%o0], %f12 					! denominator = 1
		ldd 			[%o0], %f6 					! i = 1

forTest:
		fcmpd 			%f6, %f4 					! compare i with n
		nop 												! delay slot

		fbg 			forNext 							! branch to forNext if greater than
		nop 												! delay slot

forLoop:		
		fmuld 			%f10, %f2, %f10 	! numerator *= x
		fmuld 			%f12, %f6, %f12 	! denominator *= i

forInc:
		faddd 			%f6, %f20, %f6 		! i++
		nop 												! delay slot

		fba 			forTest 							! branch always to forTest
		nop 												! delay slot

forNext:
		fdivd 			%f10, %f12, %f14 ! term = numerator / denominator

		mov 			%l4, %o0		! moving the value in the register %l4 into the register %o0
		mov 			2, %o1							! moving 2 into the register %o1
		call 			.rem								! call rem
		nop 												! delay slot

		cmp 			%o0, 0							! comparing the value in the register %o0 with 0
		bne 			forCont							! if the value in the register %o0 is not equal to 0, branch goto forCount
		nop 												! delay slot

		fmuld 			%f14, %f22, %f14 ! term *= -1

forCont:
		faddd 			%f0, %f14, %f0 		! y += term

		cmp 			%i1, 0							! comparing the value in the register %i1 with 0
		bne 			modeElse							! if it is not equal, branch goto modeElse
		nop 												! delay slot

		faddd 			%f4, %f20, %f4 			! n++
		faddd 			%f4, %f20, %f4 			! n++
		nop 													! delay slot
		fba 			modeNext
		nop 													! delay slot

modeElse:
		cmp 			%l4, 1				! comparing the value stored in the register %l4 with 1 
		nop 													! delay slot
		bne 			modeInnerElse						! if not equal, branch goto modeInnerElse
		nop 													! delay slot

		set 			one, %o0 							! set one to o0
		ldd 			[%o0], %f0 						! y = 1
		faddd 			%f4, %f20, %f4 			! n++
		nop 													! delay slot

		fba 			modeNext
		nop 													! delay slot

modeInnerElse:
		faddd 			%f4, %f20, %f4 			! n++
		faddd 			%f4, %f20, %f4 			! n++

modeNext:
		inc 			%l4 			! whileLoopCount++
		ba 				whileTest					! branch always goto whileTest
		nop 												! delay slot

returnTrig:
		ret  												!return to main function
		restore											!restore

!The above assembly code is based on the Java code I wrote below
/*

	public static double trig(Double input, int mode) {
		double y, x, n, i, pi, count, term, numerator, denominator;
		y = 0;
		n = i = term = numerator = denominator = count = 1;
		x = input;
		pi = 3.141592654;

		//convert degrees to radian
		x *= pi;
		x /= 180;
		
		while (Math.abs(term) >= 0.0000000001) {
			numerator = 1;
			denominator = 1;

			for (i = 1; i <= n; i++) {
				numerator = numerator * x;
				denominator = denominator * i;
			}
			term = numerator / denominator;

			if (count % 2 == 0) {
				term *= -1;
			}
			y += term;

			if (mode == 0) { //sine
				n++;
				n++;
			}else{ //cosine
				if (count == 1) {
					y = 1;
					n++;
				}else{
					n++;
					n++;
				}
			}			
			count++;
		}
		return y;
	}
*/
