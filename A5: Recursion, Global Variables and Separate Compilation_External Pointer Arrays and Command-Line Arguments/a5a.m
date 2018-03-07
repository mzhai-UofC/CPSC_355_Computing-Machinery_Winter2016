/*
Name: Muzhou, Zhai	
Course: CPSC 355	
Tutorial Section: T01
Assignment 5
*/
include(macro_defs.m)							!include macro_defs.m

		.section ".data"							! indicate the data section
		.align 	4									! set alignment
		.global 	ch_m								! allocate month global variable ch_m
ch_m:
		.byte 	0	
cString: 
		.asciz 	"%c"
starString:
		.asciz 	"*"
		
blank: 
		.ascii 	" "
		.byte 	0
star:
		.ascii	"*"
		.byte 	0
bracket:
		.ascii	"("
		.byte 	0
								 
		.section ".text"							! indicate the text section
		.align 4										! set alignment
		
begin_fn(find)										! the beginning of the find fuction(subroutine)
		set		cString,	%o0					! set the cString "%c" into the register %o0
		set 		ch_m, 	%o1					! set ch_m into the register %o1 
		call		scanf								! call scanf, so that the input value will be stored in the register %o0
		nop											! delay slot
			
		set		ch_m,		%o0
		ldub     [%o0],	%o0
		 
		set 		blank, 	%o2					! set the ascii code for " " into the register %o2
		ldub		[%o2],	%o2					! access the ch_maracter into the register %o2
		cmp 		%o0, 		%o2					! comparing the input ch_maracter(stored in the register %o0) with the empty space(stored in the register%o2) 
		be 		find								! if equal, branch_m goto the beginning of the find fuction
		nop											! delay slot
		
		cmp 		%o0, -1							! EOF's valuse is -1 in the solaris system by the testing of the c code.So we compare ch_m(stored in the register %l0) and -1(EOF)
											
		be 		findExit							! if equal, branch_m goto find_exit
		nop											! delay slot
		
		ba 		findRet							! branch_m always goto the findRet
		nop											! delay slot

findExit: 
		mov 		0, %o0							! return the register %o0 with the value 0
		call 		exit								! call exit
		nop											! delay slot
		
findRet:	
end_fn(find)										! the end of the find function(subroutine)

		local_var
		var(op_s, 1)
		.global expression
		
expression:
		save	%sp,	(-92+last_sym)&-8, %sp		
		call 		term								! call the fuction(subroutine) term
		nop											! delay slot
		
expression_while_plus:
		set		ch_m,		%o0
		ldub     [%o0],	%l0
		
		mov		'+', 	%o2					   ! set the ascii code for "+" into the register %o2
		!ldub		[%o2],	%o2					! access the ch_maracter into the register %o2
		cmp 		%l0, 		%o2					! comparing the input ch_maracter(stored in the register %o0) with the ch_maracter"+"(stored in the register%o2) 
		be 		expression_loop				! if equal, branch_m goto the expression_loop
		nop											! delay slot

expression_while_minus:
		set		ch_m,		%o0
		ldub     [%o0],	%l0
		
		mov 		'-', 	%o2					   ! set the ascii code for "-" into the register %o2
		!ldub		[%o2],	%o2					! access the ch_maracter into the register %o2
		cmp 		%l0, 		%o2					! comparing the input ch_maracter(stored in the register %o0) with the ch_maracter"-"(stored in the register%o2) 
		bne		expression_done				! if equal, branch_m goto the expression_done
		nop											! delay slot
	
expression_loop:
		
		set		ch_m,		%o0
		ldub     [%o0],	%l0
		stb		%l0, [%fp + op_s]
		
		
		call 		find								! call the find() fuction
		nop											! delay slot
											
		call 		term								! call the term() fuction
		nop											! delay slot
		
		set 		cString,	%o0					! set the cString "%c" into the register %o0
		ldub 		[%fp + op_s], %o1				! loading the value of op into the register %o1
		call 		printf							! call printf
		nop											! delay slot
	
		ba			expression_while_plus		! branch_m always goto the expression_while_test
		nop	
		
expression_done:										! delay slot
		ret	
		restore	 


begin_fn(term)										! the beginning of the term fuction(subroutine)
		call 		factor							! call the function factor()
		nop											! delay slot
	
term_while_test:
		set		ch_m,		%o0
		ldub     [%o0],	%l0
		
		set 		star, 	%o2					! set the ascii code for "*" into the register %o2
		ldub		[%o2],	%o2					! access the ch_maracter into the register %o2
		cmp 		%l0, %o2							! comparing the input ch_maracter(stored in the register %o0) with the ch_maracter"*"(stored in the register%o2) 
		bne		term_done						! if do not equal, branch_m goto the term_done
		nop											! delay slot
	
		call 		find								! call the function(subroutine) find()
		nop											! delay slot
	
		call 		factor							! call the fuction(subroutine) factor()
		nop											! delay slot
	
		set 		starString,	%o0			   ! set the starString "*" into the register %o0
		call 		printf							! call printf
		nop											! delay slot
	
		ba 		term_while_test				! branch_m always goto term_while_test
		nop 											! delay slot

term_done:
end_fn(term)										! the end of the term function(subroutine)

begin_fn(factor)									! the beginning of the factor fuction(subroutine)
		!set 		ch_m, %o0						! set ch_m into the register %o0
		!ldub 		[%o0], %l0					! accessing the input ch_maracter(stored in %o0) into the register %l0
	
factor_if:
		set		ch_m,		%o0
		ldub     [%o0],	%l0
		
		set 		bracket, 	%o2				! set the ascii code for "(" into the register %o2
		ldub		[%o2],	%o2					! access the ch_maracter into the register %o2
		cmp 		%l0,	%o2						! comparing the input ch_maracter(stored in the register %o0) with the ch_maracter"("(stored in the register%o2) 
		bne 		factor_else						! if do not equal, branch_m goto the factor_else
		nop											! delay slot
	
		call 		find								! call the fuction(subroutine) find()
		nop											! delay slot
	
		call		expression						! call the fuction(subroutine) expression()
		nop											! delay slot
		
		ba 		factor_next						! branch_m always goto factor_next
		nop											! delay slot
	
factor_else:
		set 		ch_m, %o0						! set ch_m into the register %o0
		ldub 		[%o0], %l0						! accessing the input ch_maracter(stored in %o0) into the register %l0
		
		set 		cString,	%o0					! set the cString "%c" into the register %o0
		mov		%l0,	%o1						! moving the input ch_maracter(stored in %l0) into the register %o1
		call		printf							! call printf
		nop											! delay slot
		
factor_next:
		call		find								! call the fuction(subroutine) find()
		nop											! delay slot
		
end_fn(factor)										! the end of the factor function(subroutine)
	
done:
		end_main										! exit of the program
	