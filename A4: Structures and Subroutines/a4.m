/*
Name: Muzhou, Zhai	
Course: CPSC 355	
Tutorial Section: T01
Assignment 4
*/
		include(macro_defs.m)
		
		
		define(FALSE_r, 0)
		define(TRUE_r,	1)
		
		begin_struct(point)
		field(x, 4)
		field(y, 4)
		end_struct(point)
		
		begin_struct(circle)
		field(origin, align_of_point, size_of_point)
		field(radius, 4)
		end_struct(circle)
		
dataString:
		.asciz	"Circle %s orign = (%d, %d)  radius = %d\n"
initialString:
		.asciz	"\nInitial circle valuse:\n"
firstString:
		.asciz	"first\n"
secondString:
		.asciz	"second\n"
changedString:
		.asciz   "\nChanged circle values:\n"
		
local_var
var(c_s, align_of_circle, size_of_circle)

begin_fn(newCircle)													! declaring that it is the begin function of newCircle(from macro_defs.m)							

		ld [%i7 +8],	%o1											! loading the value of %i7 + 8 in to the register %o1
		cmp	%o1,	size_of_circle									! comparing the value stored in the register %o1(%i7 +8) and the fuction size_of_circle
		bne,a return													! if not equal, branch always goto return
		ld [%fp + c_s], %i0											! delay slot
		
		ld	[%fp + struct_s],	%l1									! loading the frame pointer and the struct_s into the register %l1
		st %g0,	[%fp + c_s + circle_origin + point_x]		! storing the value 0  into the struct c.original.x
		st %g0,	[%fp + c_s + circle_origin + point_y]		! storing the value 0  into the struct c.original.y
		mov 1,	%o0													! moving 1 to the register %o0
		st %o0,	[%fp + c_s + circle_radius]					! storing the value 1 into the struct c.radius
		
		ld [%fp + c_s + circle_origin + point_x], %o0		! loading the value of the struct c.original.x to the register %o0
		st	%o0,	[%l1 + circle_origin + point_x]				! restoring the value
		ld [%fp + c_s + circle_origin + point_y], %o0		! loading the value of the struct c.original.y to the register %o0
		st	%o0,	[%l1 + circle_origin + point_y]				! restoring the value
		ld [%fp + c_s + circle_radius], %o0						! loading the value of the struct c.radius to the register %o0
		st	%o0,	[%l1 + circle_radius]							! restoring the value
		
return:	
		ld [%fp + c_s], %i0											! loading the value of the struct c into the register %i0
		jmpl	%i7+12,	%g0											! transfer control to the instruction and return the address 
		restore															! return the value of c

begin_fn(move)															! declaring that it is the begin function of move(from macro_defs.m)
		ld [%i0 + circle_origin + point_x], %o0				! loading c.origin.x into the register %o0(c is stored in the register %i0)
		add %o0,	%i1,	%o0											! c.origin.x += deltax (daltx is stored in the register %i1)
		st %o0,	[%i0 + circle_origin + point_x]				! restroing the value into c.origin.x
		
		ld [%i0 + circle_origin + point_y], %o0				! loading c.origin.y into the register %o0(c is stored in the register %i0)
		add %o0,	%i2,	%o0											! c.origin.y += deltay (dalty is stored in the register %i2)
		st %o0,	[%i0 + circle_origin + point_y]				! restroing the value into c.origin.y
end_fn(move)															! declaring that it is the end function of move(from macro_defs.m)

begin_fn(expand)														! declaring that it is the begin function of expand(from macro_defs.m)
		ld [%i0 + circle_radius], %o0								! loading c.radius into the register %o0(factor is stored in the register %i1)
		smul %o0,	%i1,	%o0										! c.radius *= facotrs
		st %o0,	[%i0 + circle_radius]							! restroing the value into c.radius
end_fn(expand)															! declaring that it is the end function of expand(from macro_defs.m)

local_var																! setting local_var for result
var(result, 4)															! result is an integer that is 4 bytes

begin_fn(equal)														! declaring that it is the begin function of equal(from macro_defs.m)
		mov FALSE_r,	%o0											! moving FALSE_r into the register %o0
		st %o0,	[%fp + result] 									! storing the register %o0(contains FALSE_r) into result
		
		ld	[%i0 + circle_origin + point_x], %o0				! loading c1.origin.x into the register %o0
		ld [%i1 + circle_origin + point_x], %o1				! loading c2.origin.x into the register %o1
		cmp %o0, %o1													! comparing the register %o0(c1.origin.x) and the register %o1(c2.origin.x)
		bne,a	return1													! if not equal,branch always goto return1
		ld [%fp + result], %i0										! delay slot
		
		ld	[%i0 + circle_origin + point_y], %o0				! loading c1.origin.y into the register %o0
		ld [%i1 + circle_origin + point_y], %o1				! loading c2.origin.y into the register %o1
		cmp %o0, %o1													! comparing the register %o0(c1.origin.y) and the register %o1(c2.origin.y)
		bne,a	return1													! if not equal,branch always goto return1
		ld [%fp + result], %i0										! delay slot
		
		ld	[%i0 + circle_radius], %o0								! loading c1.radius into the register %o0
		ld [%i1 + circle_radius], %o1								! loading c2.radius into the register %o1
		cmp %o0, %o1													! comparing the register %o0(c1.radius) and the register %o1(c2.radius)
		bne,a	return1													! if not equal,branch always goto return1
		ld [%fp + result], %i0										! delay slot
		
		mov TRUE_r,	%o0												! moving TRUE_r into the register %o0
		st %o0,	[%fp + result] 									! storing the register %o0(TRUE_r) into result
		
return1:
		ld [%fp + result], %i0										! loading the result into the register %i0; returning the value of result
			
end_fn(equal)															! declaring that it is the end function of equal(from macro_defs.m)

begin_fn(printCircle)												! declaring that it is the begin function of printCircle(from macro_defs.m)
		set dataString,	%o0										! setting the dataString into the register %o0
		mov %i0,	%o1													! loading name into the register %o1
		ld [%i1 + circle_origin + point_x], %o2 				! loading the value of c.origin.x into the register %o2
		ld [%i1 + circle_origin + point_y], %o3 				! loading the value of c.origin.y into the register %o3
		call printf														! call printf
		ld [%i1 + circle_radius], %o4 							! loading the value os c.radius into the register %o4													      
end_fn(printCircle)													! declaring that it is the end function of printCircle(from macro_defs.m)

local_var
var(first, align_of_circle, size_of_circle)					
var(second, align_of_circle, size_of_circle)					

begin_fn(main)															! declaring that it is the begin function of main(from macro_defs.m)
		add %fp, first,	%o0										! storing the value of struct circle first into the register %o0
		call newCircle													! call the fuction newCircle
		st	%o0,	[%sp + struct_s]									! storing the value in the register %o0 into the struct_s
		.word size_of_circle											! the calling code embeds the size in bytes of data it expect to receive
		
		add %fp, second,	%o1										! storing the value of struct circle second into the register %o1
		call newCircle													! call the fuction new circle
		st	%o1,	[%sp + struct_s]									! storing the value in the register %o1 into the struct_s	
		.word size_of_circle											! the calling code embeds the size in bytes of data it expect to receive
		
		set initialString,	%o0									! setting the initialString into the register %o0
		call printf														! call printf
		nop																! delay slot
		
		set firstString,	%o0										! setting the firstString into the register %o0 
		call printCircle												! call the fuction printCircle
		add %fp, first,	%o1										! storing the struct first into the register %o1
		
		set secondString, %o0										! setting the secondString into the register %o0 
		call printCircle												! call the fuction printCircle
		add %fp, second,	%o1										! storing the struct second into the register %o1
		
		add %fp, first, %o0											! storing the struct first into the register %o0
		call equal														! call the function equal, if the struct first(%o0) and the struct second(%o1) are equal, 
																			! then after calling equal, the value stored in the register %o0 should be 1  
		add %fp, second,	%o1										! storing the struct second into the register %o1
		
		cmp %o0,1														! comparing the value stored in the register %o0 and 1
		bne next															! if it is not equal(first != second), branch goto next
		nop																! delay slot
		
		add %fp, first, %o0											! storing the struct first into the register %o0
		mov 3,	%o1													! moving the positive integer 3 into the register %o1
		call move														! call the function move
		mov -5,	%o2													! moving the negative integer into the register %o2
		
		add %fp, second,	%o0										! storing the struct second into the register %o0
		call expand														! call the function expand 
		mov 7,	%o1													! moving the integer 7 into the register %o1
		
next:
		set changedString,	%o0									! setting the changedString into the register %o0
		call printf														! call printf
		nop																! delay slot
		
		set firstString,	%o0										! setting the firstString into the register %o0
		call printCircle												! call the function printCircle
		add %fp, first,	%o1										! storing the struct first into the register %o1
		
		set secondString, %o0										! setting the secondString into the register %o0
		call printCircle												! call the function printCircle
		add %fp, second,	%o1										! setting the struct second into the register %o1	
		
end_fn(main)															! declaring that it is the end function of main(from macro_defs.m)
		