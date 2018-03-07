/*
Name: Muzhou, Zhai
Tutorial section: T01
Assignment: 2a
Course: CPSC 355
Date: 10 th, Feb, 2016
*/

beforeData:
		.asciz 	"-----------------------\nBit Field = %x\nRight Most Bit = %d\nNumber of Bits = %d\n\n"
afterData:
		.asciz 	"Extracted = %x\n\n"	
					
		.align 4
		.global main		
main:
		save 	%sp, -96, %sp    				! allocate memory 
		set 	1, %l4							! set 1 to l4
set1:		
		set	0x49D723, %l0					! set 0x49d723 to l0		
		set	11, %l1							! set 11 to l1
		set 	9, %l2		       			! set 9 to l2

printBefore:
		set 	beforeData, %o0    			! set beforeData to o0
		mov 	%l0, %o1  						! move l0 to o0
		mov 	%l1, %o2							! move l1 to o2
		call	printf 							! calling printf		
		mov 	%l2, %o3							! move l2 to o3

extraction:
		set 	32, %o0							! set 32 to o0
		sub 	%o0, %l1, %o0					! o0 - l1
		sub 	%o0, %l2, %o0					! o0 - l2
		sll	%l0, %o0, %l3					! shift l0 left by the number in o0	
		
		add 	%l1, %o0, %o0					! l1 + o0
		srl 	%l3, %o0, %l3					! shift l3 right by the number in o0
		
printAfter:
		set 	afterData, %o0					! set afterData to o0
		call 	printf							! call printf
		mov 	%l3, %o1							! move l3 to o1
		
		inc 	%l4								! l4 += 1
		
		cmp 	%l4, 2							! compare l4 and 2
		be 	set2								! if l4 equal to 2, branch go to set 2
		mov 	0, %o0							! delay slot
		
		cmp 	%l4, 3							! compare l4 to 3
		be 	set3								! if l4 equal to 3, branch go to set 3
		mov 	0, %o0							! delay slot
		
		cmp 	%l4, 4							! compare l4 to 4
		be		done								! if l4 equal to 4, branch go to done and stop
		mov 	1, %g1                  	! delay slot

set2:
		set 	0x1BA621B0, %l0				! set 0x1ba621b0 to l0
		set 	4, %l1							! set 4 to l1
		set 	4, %l2							! set 4 to l2
		ba 	printBefore						! branch always go to printBefore
		mov 	0, %o0							! delay slot
		
set3:
		set 	0xDEADBEEF, %l0				! set 0xdeadbeef to l0
		set 	8, %l1							! set 8 to l1
		set 	22, %l2							! set 22 to l2
		ba 	printBefore						! branch always go to printBefore
		mov 	0, %o0							! delay slot
		
done:     
		mov 	1, %g1                     ! 1 to g1
		ta 	0									! trap to system
		
