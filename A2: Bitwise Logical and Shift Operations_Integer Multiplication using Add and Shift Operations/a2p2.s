! a2p2.s
/*
Name: Muzhou, Zhai
Tutorial section: T01
Assignment: 2a
Course: CPSC 355
Date: 10 th, Feb, 2016
*/



setnum:
		.asciz 		"Set %d:\n"
databefore:
		.asciz 		"\tMultiplicand before = \t0x%8.8x\n\tProduct before = \t0x%8.8x\n\tMultiplier before = \t0x%8.8x\n\n"
dataafter:
		.asciz 		"\tMultiplicand after = \t0x%8.8x\n\tProduct after = \t0x%8.8x\n\tMultiplier after = \t0x%8.8x\n\n"

		.align		4			
		.global 	main
main:	
		save 		%sp, -96, %sp
			
		set 		82732983, %l0		! set 82732983 to multiplicand	
		set     	120490892, %l1		! set 120490892 tomultiplier
		set 		0, %l2				! set 0 to product
		set 		0, %l3				! set 0 to negative
		set 		0, %l4				! set 0 to i	
		
		cmp 		%l1, 0				! compare multiplier with 0
		bge 		loop 				   ! branch to loop if greater or equal
		cmp 		%l4, 32				! delay slot
		mov 		1, %l3				! set negative to 1 if 
	
		
loop:
		cmp 		%l4, 32				! compare 0 with 32
		bge,a		ifnegative			! branch to ifnegative if greater or equal
		cmp 		%l3, 1				! delay slot
		
		btst		1, %l1				! check if the left most bit of multiplier is 1			
		ble,a 	shiftmultiplier   ! branch go to shiftmultiplier if less or equal
		srl 		%l1, 1, %l1			! delay slot		
		add		%l0, %l2, %l2		! product += multiplicand 
				
		srl 		%l1, 1, %l1			! shift multiplier right logically by 1
		
shiftmultiplier:	
		and		1, %l2, %o0			! check if the left most bit of product is 1
		cmp		%o0, 0				! compare the left most bit with 0
		ble,a 	shiftproduct		! branch to shiftproduct if less or equal
		sra 		%l2, 1, %l2			! delay slot	
		
		set		0x80000000, %o0	! set 80000000 in order to add a 1 on the left most side
		add		%o0, %l1, %l1		! add 1 to the left most side of the multiplier 
		sra 		%l2, 1, %l2			! shift product right arithematically by 1	

	
shiftproduct:			
		inc 		%l4					! i++
		ba,a  	loop  				! branch always to loop
		cmp 		%l4, 32				! delay slot
		
			
ifnegative:	
		cmp 		%l3, 1				! compare 1 with negative 		
		bne,a 	printdata			! branch to printdata if not equal
		set 		setnum, %o0			! delay slot
		sub 		%l2, %l0, %l2 		! product-=multiplicand
		
printdata:
		set 		setnum, %o0			! set setnum in o0
		call 		printf				! calling printf
		mov 		1, %o1				! move 1 in o1

	
		set 		databefore, %o0	! set databefore in o0
		set 		82732983, %o1		! set multiplicand to o1
		mov 		0, %o2				! move product to o2		
		call 		printf				! calling printf
		set 		120490892, %o3		! set multiplier to o3	
		
	
		
		set 		dataafter, %o0		! set dataafter in o0
		mov 		%l0, %o1			   ! mov multiplicand to o1
		mov 		%l2, %o2			   ! mov product to o2
		call 		printf				! calling printf
		mov 		%l1, %o3		   	! mov multiplier to o3
		
main2:
		set 		0, %l4				! set i		
		set 		82732983, %l0		! set multiplicand	
		set     	-120490892, %l1	! set multiplier
		set 		0, %l2				! set product
		set 		0, %l3				! set negative
		
		cmp 		%l1, 0				! compare multiplier with 0
		bge 		loop2 				! branch to loop2 if greater or equal
		cmp 		%l4, 32				! delay slot
		mov 		1, %l3				! set negative to 1 if multiplier is less than
	
		
loop2:
		cmp 		%l4, 32				! compare 0 with 32
		bge,a		ifnegative2			! branch to ifnegative2 if greater or equal than
		cmp 		%l3, 1				! delay slot
		
		btst		1, %l1				! check whether the left most side of multiplier is 1			
		ble,a 	shiftmultiplier2 	! branch to shiftmultiplier2 if less or equal
		srl 		%l1, 1, %l1			! delay slot		
		add		%l0, %l2, %l2		! product -= multiplicand
				
		srl 		%l1, 1, %l1			! shift multiplier right logically by 1
		
shiftmultiplier2:	
		and		1, %l2, %o0		   ! check whether the left most bit of product is 1
		cmp		%o0, 0				! compare the left most bit of product with 0
		ble,a 	shiftproduct2		! branch to shiftproduct2 if less or equal
		sra 		%l2, 1, %l2		   ! delay slot	
		
		set		0x80000000, %o0	! set 1 as the left most bit of the bitmask
		add		%o0, %l1, %l1		! add 1 to the left most bit of the multiplier (
		sra 		%l2, 1, %l2			! shift product right arithematically by 1	

	
shiftproduct2:			
		inc 		%l4					! i++
		ba,a  	loop2 				! branch always to loop2
		cmp 		%l4, 32				! delay slot
		
			
ifnegative2:	
		cmp 		%l3, 1				! compare 1 with negative 	
		bne,a 	printdata2			! branch to printdata2 if not equal
		set 		setnum, %o0			! delay slot
		sub 		%l2, %l0, %l2 		! product-=multiplicand
		
printdata2:
		set 		setnum, %o0			!set setnum in o0
		call 		printf				!calling printf
		mov 		2, %o1				!move 1 in o1

	
		set 		databefore, %o0		!set databefore in o0
		set 		82732983, %o1		!set multiplicand to o1
		mov 		0, %o2				!move product to o2
		call 		printf				!calling printf		
		set 		-120490892, %o3		!set multiplier to o3	

		
		
		set 		dataafter, %o0		!set dataafter in o0
		mov 		%l0, %o1			!mov multiplicand to o1
		mov 		%l2, %o2			!mov product to o2
		call 		printf				!calling printf
		mov 		%l1, %o3			!mov multiplier to o3
		


main3:
		
		set 		-82732983, %l0		! set multiplicand	
		set     	-120490892, %l1	! set multiplier
		set 		0, %l2				! set product
		set 		0, %l3				! set negative
		set 		0, %l4				! set i
				
		cmp 		%l1, 0				! compare multiplier  with 0
		bge 		loop3 				! branch to loop3 if greater or equal
		cmp 		%l4, 32				! delay slot
		mov 		1, %l3				! set negative to 1 if multiplier is less than
	
		
loop3:
		cmp 		%l4, 32				! compare 0 with 32
		bge,a		ifnegative3			! branch to ifnegative3 if greater or equal than
		cmp 		%l3, 1				! delay slot
		
		btst		1, %l1				! check whether the left most bit of multiplier is 1			
		ble,a 	shiftmultiplier3 	! branch to shiftmultiplier3 if less or equal
		srl 		%l1, 1, %l1			! delay slot		
		add		%l0, %l2, %l2		! product+=product 
				
		srl 		%l1, 1, %l1			! shift multiplier right logically by 1
		
shiftmultiplier3:	
		and		1, %l2, %o0			! check whether the left most bit of product  is 1
		cmp		%o0, 0				! compare the left most bit of product with 0
		ble,a 	shiftproduct3		! branch to shiftproduct3 if less or equal
		sra 		%l2, 1, %l2			! delay slot	
		
		set		0x80000000, %o0	! set 1 as the left most bit of the bitmask
		add		%o0, %l1, %l1		! add 1 to the left most bit of the multiplier 
		sra 		%l2, 1, %l2			! shift product right arithematically by 1	

	
shiftproduct3:			
		inc 		%l4					! i++
		ba,a  	loop3 			   ! branch always to loop3
		cmp 		%l4, 32				! delay slot
		
			
ifnegative3:	
		cmp 		%l3, 1				! compare 1 with negative 	
		bne,a 	printdata3			! branch to printdata3 if not equal
		set 		setnum, %o0			! delay slot
		sub 		%l2, %l0, %l2 		! product-=multiplicand
		
printdata3:
		set 		setnum, %o0			! set setnum in o0
		call 		printf				! calling printf
		mov 		3, %o1				! move 1 in o1

	
		set 		databefore, %o0	! set databefore in o0
		set 		-82732983, %o1		! set multiplicand to o1
		mov 		0, %o2				! move product to o2		
		call 		printf				! calling printf	
		set 		-120490892, %o3	! set multiplier to o3	
		
		
		set 		dataafter, %o0		! set dataafter in o0
		mov 		%l0, %o1			   ! mov multiplicand to o1
		mov 		%l2, %o2			   ! mov product to o2
		call 		printf				! calling printf
		mov 		%l1, %o3			   ! mov multiplier to o3
		
		
done:     
		mov 1, %g1                 ! 1 to g1
		ta 0								! trap to system
		