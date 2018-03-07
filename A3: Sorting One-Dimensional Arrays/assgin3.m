/*
Name: Muzhou, Zhai	
Course: CPSC 355	
Tutorial Section: T01
Assignment 3
*/

	define(local_var, `define(last_sym, 0)')
	define(`var', `define(`last_sym', eval((last_sym - $2) & -$2))$1 = last_sym')
	
	
	define(begin_main, `
		.align 4
		.global main')

	define(SIZE_r, 40)
	define(gap_r, l0)	
	define(i_r, l1)
	define(j_r, l2)
	define(temp_r, l3)
	
	local_var
	var(v_s, 4, 4 * 40)				! 4 is the element size, 40 is the numbers of element
	
dataString:  
 	.asciz	"v[%d] = %d\n"
 	

	begin_main
main:  
   save	%sp, (-92+last_sym) & -8, %sp
   
   set 	0, %i_r						! i=0
   ba		test1								! branch always goto test1
	nop									! delay slot

loop1:
	call 	rand
	nop
	and 	%o0, 0xFF, %o1
	
	sll	%i_r, 2, %o0				! to access element 1
	add 	%fp, %o0, %o0					! add frame pointer
	st 	%o1, [%o0 + v_s]				! write to array v[i]

	inc	%i_r							! i+=1

test1:  
	cmp 	%i_r, SIZE_r				! compare i with size
	bl		loop1							! if i is less than size, branch always goto loop1
	nop									! delay slot

	set 	0,	%i_r						! i=0
   ba		test2								! branch always goto test2
	nop									! delay slot
	
printBefore:
	sll	%i_r, 2, %o0				! to access element 1
	add 	%fp, %o0, %o0					! add frame pointer
	ld 	[%o0 + v_s], %o2 				! v[i] to o1
	
	set	dataString, %o0 			! set dataString to o0
	mov 	%i_r, %o1
	call	printf 						! calling printf
	nop
	
	inc 	%i_r							! i+=1
	
test2:  
	cmp 	%i_r, SIZE_r 				! compare i with size
	bl 	printBefore							! if i is less than size, branch always goto printData
	nop									! delay slot
	
	














	mov	SIZE_r, %o0
	mov 	2, %o1
	call 	.div
	nop
	mov 	%o0, %gap_r
	
	ba 	sortTest1
	nop
	
sortLoop1:	
	mov 	%gap_r, %o0
	mov 	2, %o1
	call 	.div
	nop
	mov 	%o0, %gap_r
	
sortTest1:
	cmp 	%gap_r, 0
	bg	 	sortLoop1
	nop
	
	mov 	%gap_r,	%i_r		
	ba 	sortTest2
	nop	

sortLoop2:
	inc 	%i_r

sortTest2:
	cmp 	%i_r,	SIZE_r
	bl 	sortLoop2
	nop	
	
	sub 	%i_r, %gap_r, %j_r
	ba 	sortTest3
	nop 












sortLoop3:
	sll	%j_r, 2, %o0					! to access element 1
	add 	%fp, %o0, %o0					! add frame pointer
	ld 	[%o0 + v_s], %o0 				! v[j] to o0
	mov 	%o0,	%temp_r
		
	add 	%j_r,	%gap_r, %o0
	sll	%o0, 2, %o0						! to access element 1
	add 	%fp, %o0, %o0					! add frame pointer
	ld 	[%o0 + v_s], %o0				! v[j+gap] to o0
	
	sll	%j_r, 2, %o1					! to access element 1
	add 	%fp, %o1, %o1					! add frame pointer
	st 	%o0 ,	[%o1 + v_s] 			! v[j] to o0
	
	add 	%j_r,	%gap_r, %o0
	sll	%o0, 2, %o0						! to access element 1
	add 	%fp, %o0, %o0					! add frame pointer
	st 	%temp_r,	[%o0 + v_s]			! move temp into v[j+gap]
	
	sub 	%j_r, %gap_r, %j_r			!j -= gap








	
sortTest3:
	cmp 	%j_r,	0
	bl		sortLoop2	
	nop
	
	add 	%j_r,	%gap_r,	%o0
	sll	%o0, 2, %o0				! to access element 1
	add 	%fp, %o0, %o0					! add frame pointer
	ld 	[%o0 + v_s], %o1 				! v[j+gap] to o1
	
	sll	%j_r, 2, %o0				! to access element 1
	add 	%fp, %o0, %o0					! add frame pointer
	ld 	[%o0 + v_s], %o0 				! v[j] to o0
	
	cmp	%o0,	%o1
	bg		sortLoop3
	nop
	
	set 	0, %i_r						! i=0
   ba		test3								! branch always goto test1
	nop									! delay slot


	

printAfter:
	sll	%i_r, 2, %o0				! to access element 1
	add 	%fp, %o0, %o0					! add frame pointer
	ld 	[%o0 + v_s], %o2 				! v[i] to o1
	
	set	dataString, %o0 			! set dataString to o0
	mov 	%i_r, %o1
	call	printf 						! calling printf
	nop
	
	inc 	%i_r							! i+=1
	
test3:
	cmp 	%i_r, SIZE_r				! compare i with size
	bl		printAfter							! if i is less than size, branch always goto loop1
	nop									! delay slot


















done:
	mov	1, %g1 
	ta 	0
		