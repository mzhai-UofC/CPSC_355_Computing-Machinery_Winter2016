/*
Name: Muzhou, Zhai	
Course: CPSC 355	
Tutorial Section: T01
Assignment 5 part B
*/

include(macro_defs.m) 									! include macro_defs.m

define(argCounter_r, l0)
define(month_r, l1) 										! month = l1
define(day_r, l2) 										! day = l2
define(year_r, l3)										! year = l3


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

begin_fn(main)
		mov 		1, %argCounter_r
		
		cmp 		%i0, 4 									! compare number of arguments with 4
		bne 		error 									! branch to error if not equal
		mov		0, %o1									! delay slot

		!month
		sll 		%argCounter_r, 2, %o0
		ld 		[%i1 + %o0], %o0 						! load month to o0
		call 		atoi 										! call atoi
		mov		0, %o1									! delay slot
		mov 		%o0, %month_r 							! move result to month

		inc	 	%argCounter_r
		
		!day
		sll 		%argCounter_r, 2, %o0
		ld 		[%i1 + %o0], %o0 						! load day to o0
		call 		atoi 										! call atoi
		nop													! delay slot
		mov 		%o0, %day_r		 						! move result to day

		inc	 	%argCounter_r
		
		!year
		sll 		%argCounter_r, 2, %o0
		ld 		[%i1 + %o0], %o0						! load year to o0
		call 		atoi 										! call atoi
		nop													! delay slot
		mov 		%o0, %year_r 							! move result to year

checkMonth:
		!month error checking
		cmp 		%month_r, 1 							! compare month with 1
		bl 		monthLowerError 						! branch to monthLowerError if less than
		nop													! delay slot

		cmp 		%month_r, 2 							! compare month with 2
		be 			check28Days	 						! branch to checkMonthCont if not equal
		nop													! delay slot

		cmp 		%month_r, 4								! compare month with 4
		be 			check30Days							! branch to check30Days if equal
		nop													! delay slot

		cmp 		%month_r, 6								! compare month with 6
		be 			check30Days							! branch to check30Days if equal
		nop													! delay slot

		cmp 		%month_r, 9								! compare month with 9
		be 			check30Days							! branch to check30Days if equal
		nop													! delay slot

		cmp 		%month_r, 11							! compare month with 11
		be 			check30Days							! branch to check30Days if equal
		nop													! delay slot

		cmp 		%month_r, 12 							! compare month with 12
		bg 			monthHigherError 					! branch to monHigherError
		nop													! delay slot

checkDay:
		!day error Checking
		cmp 		%day_r, 1 								! compare day with 1
		bl 			dayLowerError 						! branch to dayLowerError if less than
		nop													! delay slot

		cmp 		%day_r, 31 								! compare day with 31
		bg 			dayHigherError 					! branch to dayHigherError if greater than
		nop													! delay slot

		ba 			checkYear 							! branch always to checkYear
		nop													! delay slot

check28Days:
		cmp 		%day_r, 28 								! compare day with 28
		bg 			day28Error	 						! branch to day28Error if greater than
		nop													! delay slot

check30Days:
		cmp 		%day_r, 30								! compare day with 28
		bg 			day30Error 							! branch to day28Error if greater than
		nop													! delay slot

checkYear:
		!year error checking
		cmp 		%year_r, 1 								! compare year with 1
		bl 			yearLowerError 					! branch to yearLowerError if less than
		nop													! delay slot

		cmp 		%year_r, 2050 							! compare year with 2050
		bg 			yearHigherError 					! branch to yearHigherError if greater
		nop													! delay slot		

		!month integer to label
		dec 		%month_r 								! month--
		sll 		%month_r, 2, %month_r 				! month * 4

suffix:
		!set suffix
		cmp 		%day_r, 1								! compare day with 1
		be 			setFirst 							! branch to setFirst if equal
		nop													! delay slot

		cmp 		%day_r, 21								! compare day with 21
		be 			setFirst								! branch to setFirst if equal
		nop													! delay slot

		cmp 		%day_r, 31								! compare day with 31
		be 			setFirst								! branch to setFirst if equal
		nop													! delay slot

		cmp 		%day_r, 2								! compare day with 2
		be 			setSecond							! branch to setSecond if equal
		nop													! delay slot

		cmp 		%day_r, 22								! compare day with 22
		be 			setSecond							! branch to setSecond if equal
		nop													! delay slot

		cmp 		%day_r, 3								! compare day with 3
		be 			setThird								! branch to setThird if equal
		nop													! delay slot

		cmp 		%day_r, 23								! compare day with 23
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
		add 		%o1, %month_r, %o1 					! locate month's label
		ld 			[%o1], %o1 							! move month's label to o1
		mov 		%day_r, %o2 							! move day to o2
		call 		printf									! calling printf
		mov 		%year_r, %o3 							! move year to o3

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
		end_main
