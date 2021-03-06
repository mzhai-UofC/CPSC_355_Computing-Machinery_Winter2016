/*
Name: Muzhou, Zhai	
Course: CPSC 355	
Tutorial Section: T01
Assignment 6
*/

! local registers macros
define(FD_r, l0)
define(argCounter_r, l1)
define(argAddress_r, l2)
define(input_r, l3)
define(whileLoopCount_r, l4)
! constant macros
define(OPEN, 5)
define(READ, 3)
define(numOfBytes, 8)
! floating point registers macros
define(y_r, f0)
define(x_r, f2)
define(n_r, f4)
define(i_r, f6)
define(pi_r, f8)
define(num_r, f10)
define(den_r, f12)
define(term_r, f14)
define(absTerm_r, f16)
define(zero_r, f18)
define(one_r, f20)
define(negOne_r, f22)
define(lim_r, f24)
define(twopi_r, f26)
define(temp_r, f28)


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
		
		mov				1, %argCounter_r	! moving the value 1 into the register %argCounter
		sll				%argCounter_r, 2, %argAddress_r ! shifting the counter left by 2 for the address
		ld		   		[%i1 + %argAddress_r], %FD_r	! loading the address into the register %FD_r
		
		mov 			%FD_r, %o0				! moving %FD_r into the register %o0 
		clr				%o1					! clear the register %o1
		clr				%o2					! clear the register %o2
		mov 			OPEN, %g1				! move OPEN to the register %g1
		ta				0							! exit the program
		bcc 			open_ok					! if equal to 0, branch jump to open_ok
		nop 										! delay slot
		ba 				done					! branch always goto done
		nop 										! delay slot

open_ok:
		mov 			%o0, %FD_r				! moving the input value in the register %o0 intov the %FD_r


readFile:
		mov				%FD_r, %o0			! moving the value in the register %FD_r into the register %o0				
		mov 			READ, %g1				! moving the value of variable RAED to %g1
		set 			input, %o1				! moving the value of variable input to %o1		
		mov 			numOfBytes, %o2 		! moving the value of variable numOfBytes into the  register %o2
		ta 				0						! exit the file

		cmp 			%o0, 0					! comparing the value in teh register %o0 with 0
		ble 			done						! if the value in the register %o0 is less or equal than 0
		nop 										! delay slot			
			
		set 			input, %input_r		! setting the value of input into the register %input_r


printData:		
		! print input data
		set 			dataString, %o0		! setting the dataString into the register %o0
		ld 				[%input_r], %o1	! loading the input value into the register %o1		
		ld 				[%input_r - 4], %o2	! loading the address of the input into the register %o2		
		call 			printf						! call printf
		nop 										! delay slot
		
		! call sine function
		! print sine result
		ldd 			[%input_r], %o0				! load input to o0
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
		ldd 			[%input_r], %o0				! load input to o0
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
		ldd				[%fp - 8], %x_r			! load stack memory to x

		set 			limit, %o0						! set limit to o0
		ldd 			[%o0], %lim_r					! limit = 1.0e-10 

		set 			one, %o0 						! set one to o0
		ldd 			[%o0], %n_r 					! n = 1
		ldd 			[%o0], %i_r						! i = 1
		ldd 			[%o0], %term_r					! term = 1
		ldd 			[%o0], %num_r					! num = 1
		ldd 			[%o0], %den_r					! den = 1
		ldd 			[%o0], %absTerm_r				! absTerm = 1
		ldd 			[%o0], %one_r					! one = 1

		set 			zero, %o0 						! set zero to o0
		ldd 			[%o0], %y_r 					! y = 0
		ldd 			[%o0], %zero_r 				! zero = 0

		set 			negOne, %o0 					! set negative one to o0
		ldd 			[%o0], %negOne_r 				! negOne = -1

		set 			pi, %o0 							! set pi to o0
		ldd 			[%o0], %pi_r 					! pi = 3.141592654

		set 			twopi, %o0 						! set twopi to o0
		ldd 			[%o0], %twopi_r 				! twopi = 180

		mov 			1, %whileLoopCount_r 		! whileLoopCount = 1

convertToRadian:
		fmuld 			%x_r, %pi_r, %x_r 		! x *= pi
		fdivd 			%x_r, %twopi_r, %x_r 	! x /= 180

whileTest:
		fabss			%term_r, %absTerm_r	 		! absTerm = |term|
		fcmpd 			%absTerm_r, %lim_r 		! compare 
		nop 												! delay slot

		fbl 			returnTrig
		nop 												! delay slot

		set 			one, %o0 						! set one to o0
		ldd 			[%o0], %num_r 					! numerator = 1
		ldd 			[%o0], %den_r 					! denominator = 1
		ldd 			[%o0], %i_r 					! i = 1

forTest:
		fcmpd 			%i_r, %n_r 					! compare i with n
		nop 												! delay slot

		fbg 			forNext 							! branch to forNext if greater than
		nop 												! delay slot

forLoop:		
		fmuld 			%num_r, %x_r, %num_r 	! numerator *= x
		fmuld 			%den_r, %i_r, %den_r 	! denominator *= i

forInc:
		faddd 			%i_r, %one_r, %i_r 		! i++
		nop 												! delay slot

		fba 			forTest 							! branch always to forTest
		nop 												! delay slot

forNext:
		fdivd 			%num_r, %den_r, %term_r ! term = numerator / denominator

		mov 			%whileLoopCount_r, %o0		! moving the value in the register %whileLoopCount_r into the register %o0
		mov 			2, %o1							! moving 2 into the register %o1
		call 			.rem								! call rem
		nop 												! delay slot

		cmp 			%o0, 0							! comparing the value in the register %o0 with 0
		bne 			forCont							! if the value in the register %o0 is not equal to 0, branch goto forCount
		nop 												! delay slot

		fmuld 			%term_r, %negOne_r, %term_r ! term *= -1

forCont:
		faddd 			%y_r, %term_r, %y_r 		! y += term

		cmp 			%i1, 0							! comparing the value in the register %i1 with 0
		bne 			modeElse							! if it is not equal, branch goto modeElse
		nop 												! delay slot

		faddd 			%n_r, %one_r, %n_r 			! n++
		faddd 			%n_r, %one_r, %n_r 			! n++
		nop 													! delay slot
		fba 			modeNext
		nop 													! delay slot

modeElse:
		cmp 			%whileLoopCount_r, 1				! comparing the value stored in the register %whileLoopCount_r with 1 
		nop 													! delay slot
		bne 			modeInnerElse						! if not equal, branch goto modeInnerElse
		nop 													! delay slot

		set 			one, %o0 							! set one to o0
		ldd 			[%o0], %y_r 						! y = 1
		faddd 			%n_r, %one_r, %n_r 			! n++
		nop 													! delay slot

		fba 			modeNext
		nop 													! delay slot

modeInnerElse:
		faddd 			%n_r, %one_r, %n_r 			! n++
		faddd 			%n_r, %one_r, %n_r 			! n++

modeNext:
		inc 			%whileLoopCount_r 			! whileLoopCount++
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
