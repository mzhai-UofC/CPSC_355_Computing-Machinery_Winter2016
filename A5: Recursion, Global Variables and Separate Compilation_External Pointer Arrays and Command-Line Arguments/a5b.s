/*
Name: Muzhou, Zhai	
Course: CPSC 355	
Tutorial Section: T01
Assignment 5 part B
*/

  									!  macro_defs.m


 										! month = l1
 										! day = l2
										! year = l3


		.align 		4 										! set alignment
		.global 	month 									! allocate month global variable
month: 	.word 		jan_m, feb_m, mar_m 			! set month array
		.word 		apr_m, may_m, jun_m 				! set month array
		.word 		jul_m, aug_m, sep_m 				! set month array
		.word 		oct_m, nov_m, dec_m 				! set month array

jan_m: 	.asciz 		"January" 						! janurary format string
feb_m: 	.asciz 		"February" 						! february format string
mar_m: 	.asciz 		"March"							! march format string
apr_m: 	.asciz 		"April" 							! april format string
may_m: 	.asciz 		"May" 							! may format string
jun_m: 	.asciz 		"June" 							! june format string
jul_m: 	.asciz 		"July" 							! july format string
aug_m: 	.asciz 		"August" 						! august format string
sep_m: 	.asciz 		"September" 					! september format string
oct_m: 	.asciz 		"October" 						! october format string
nov_m: 	.asciz 		"November" 						! november format string
dec_m: 	.asciz 		"December"						! december format string

dateSt: .asciz 		"%s %dst, %d\n" 				! date for first format string
dateNd:	.asciz 		"%s %dnd, %d\n"				! date for second format string
dateRd:	.asciz 		"%s %drd, %d\n"				! date for third format string
dateTh:	.asciz 		"%s %dth, %d\n"				! date for other format string

errorString:
		.asciz 		"Error: There must be exactly 3 arguments in the form of mm dd yyyy.\n"
																! errorString format string
monthLowerErrorString:
		.asciz 		"Error: Month must be an integer and greater than or equal to 1.\n"
																! monthLowerErrorString format string
monthHigherErrorString:
		.asciz 		"Error: Month must be less than or equal to 12.\n"
																! monthHigherErrorString format string
day28ErrorString:
		.asciz 		"Error: There are only 28 days in February\n"
																! day28ErrorString format string
day30ErrorString:
		.asciz 		"Error: There are only 30 days in this month\n"
																! day30ErrorString format string
dayLowerErrorString:
		.asciz 		"Error: Day must be an integer and greater than or equal to 1.\n"
																! dayLowerErrorString format string
dayHigherErrorString:
		.asciz 		"Error: Day must be less than or equal to 31.\n"
																! dayHigherErrorString format string
yearLowerErrorString:
		.asciz 		"Error: Year must be an integer and greater than or equal to 1.\n"
																! yearLowerErrorString format string
yearHigherErrorString:
		.asciz 		"Error: Year must be less than or equal to 2050.\n"
																! yearHigherErrorString format string
		.align 		4 										! set alignment

.global	main
	.align	4
main:	save	%sp, -96, %sp

		mov 		1, %l0
		
		cmp 		%i0, 4 									! compare number of arguments with 4
		bne 		error 									! branch to error if not equal
		mov		0, %o1									! delay slot

		!month
		sll 		%l0, 2, %o0
		ld 		[%i1 + %o0], %o0 						! load month to o0
		call 		atoi 										! call atoi
		mov		0, %o1									! delay slot
		mov 		%o0, %l1 							! move result to month

		inc	 	%l0
		
		!day
		sll 		%l0, 2, %o0
		ld 		[%i1 + %o0], %o0 						! load day to o0
		call 		atoi 										! call atoi
		nop													! delay slot
		mov 		%o0, %l2		 						! move result to day

		inc	 	%l0
		
		!year
		sll 		%l0, 2, %o0
		ld 		[%i1 + %o0], %o0						! load year to o0
		call 		atoi 										! call atoi
		nop													! delay slot
		mov 		%o0, %l3 							! move result to year

checkMonth:
		!month error checking
		cmp 		%l1, 1 							! compare month with 1
		bl 		monthLowerError 						! branch to monthLowerError if less than
		nop													! delay slot

		cmp 		%l1, 2 							! compare month with 2
		be 			check28Days	 						! branch to checkMonthCont if not equal
		nop													! delay slot

		cmp 		%l1, 4								! compare month with 4
		be 			check30Days							! branch to check30Days if equal
		nop													! delay slot

		cmp 		%l1, 6								! compare month with 6
		be 			check30Days							! branch to check30Days if equal
		nop													! delay slot

		cmp 		%l1, 9								! compare month with 9
		be 			check30Days							! branch to check30Days if equal
		nop													! delay slot

		cmp 		%l1, 11							! compare month with 11
		be 			check30Days							! branch to check30Days if equal
		nop													! delay slot

		cmp 		%l1, 12 							! compare month with 12
		bg 			monthHigherError 					! branch to monHigherError
		nop													! delay slot

checkDay:
		!day error Checking
		cmp 		%l2, 1 								! compare day with 1
		bl 			dayLowerError 						! branch to dayLowerError if less than
		nop													! delay slot

		cmp 		%l2, 31 								! compare day with 31
		bg 			dayHigherError 					! branch to dayHigherError if greater than
		nop													! delay slot

		ba 			checkYear 							! branch always to checkYear
		nop													! delay slot

check28Days:
		cmp 		%l2, 28 								! compare day with 28
		bg 			day28Error	 						! branch to day28Error if greater than
		nop													! delay slot

check30Days:
		cmp 		%l2, 30								! compare day with 28
		bg 			day30Error 							! branch to day28Error if greater than
		nop													! delay slot

checkYear:
		!year error checking
		cmp 		%l3, 1 								! compare year with 1
		bl 			yearLowerError 					! branch to yearLowerError if less than
		nop													! delay slot

		cmp 		%l3, 2050 							! compare year with 2050
		bg 			yearHigherError 					! branch to yearHigherError if greater
		nop													! delay slot		

		!month integer to label
		dec 		%l1 								! month--
		sll 		%l1, 2, %l1 				! month * 4

suffix:
		!set suffix
		cmp 		%l2, 1								! compare day with 1
		be 			setFirst 							! branch to setFirst if equal
		nop													! delay slot

		cmp 		%l2, 21								! compare day with 21
		be 			setFirst								! branch to setFirst if equal
		nop													! delay slot

		cmp 		%l2, 31								! compare day with 31
		be 			setFirst								! branch to setFirst if equal
		nop													! delay slot

		cmp 		%l2, 2								! compare day with 2
		be 			setSecond							! branch to setSecond if equal
		nop													! delay slot

		cmp 		%l2, 22								! compare day with 22
		be 			setSecond							! branch to setSecond if equal
		nop													! delay slot

		cmp 		%l2, 3								! compare day with 3
		be 			setThird								! branch to setThird if equal
		nop													! delay slot

		cmp 		%l2, 23								! compare day with 23
		be 			setThird 							! branch to setThird if equal
		nop													! delay slot
	
		ba 			setOther								! branch always to setOther
		nop													! delay slot

setFirst:
		set 		dateSt, %o0 							! set string for print
		ba 			print 								! branch always to print
		nop													! delay slot

setSecond:
		set 		dateNd, %o0								! set string for print
		ba 			print 								! branch always to print
		nop													! delay slot

setThird:
		set 		dateRd, %o0								! set string for print
		ba 			print 								! branch always to print
		nop													! delay slot

setOther:
		set 		dateTh, %o0								! set string for print

print:
		set 		month, %o1 								! set month to o1
		add 		%o1, %l1, %o1 					! locate month's label
		ld 			[%o1], %o1 							! move month's label to o1
		mov 		%l2, %o2 							! move day to o2
		call 		printf									! calling printf
		mov 		%l3, %o3 							! move year to o3

		ba 			done									! branch always to done
		mov 		1, %g1 									! delay slot

monthLowerError:
		set 		monthLowerErrorString, %o0			! set string for print
		call 		printf									! calling printf
		nop													! delay slot

		ba 			done									! branch always to done
		mov 		1, %g1 									! delay slot

monthHigherError:
		set 		monthHigherErrorString, %o0		! set string for print
		call 		printf									! calling printf
		nop													! delay slot

		ba 			done									! branch always to done
		mov 		1, %g1 									! delay slot

day28Error:
		set 		day28ErrorString, %o0				! set string for print
		call 		printf									! calling printf
		nop													! delay slot

		ba 			done									! branch always to done
		mov 		1, %g1 									! delay slot

day30Error:
		set 		day30ErrorString, %o0				! set string for print
		call 		printf									! calling printf
		nop													! delay slot

		ba 			done									! branch always to done
		mov 		1, %g1 									! delay slot

dayLowerError:
		set 		dayLowerErrorString, %o0			! set string for print
		call 		printf									! calling printf
		nop													! delay slot

		ba 			done									! branch always to done
		mov 		1, %g1 									! delay slot

dayHigherError:
		set 		dayHigherErrorString, %o0			! set string for print
		call 		printf									! calling printf
		nop													! delay slot

		ba 			done									! branch always to done
		mov 		1, %g1 									! delay slot

yearLowerError:
		set 		yearLowerErrorString, %o0			! set string for print
		call 		printf									! calling printf
		nop													! delay slot

		ba 			done									! branch always to done
		mov 		1, %g1 									! delay slot

yearHigherError:
		set 		yearHigherErrorString, %o0			! set string for print
		call 		printf									! calling printf
		nop												   ! delay slot

		ba 			done									! branch always to done 
		mov 		1, %g1 									! delay slot

error:
		set 		errorString, %o0						! set string for print
		call 		printf									! calling printf
		mov 		1, %g1 									! delay slot

done:
		mov	1, %g1
	ta	 0
