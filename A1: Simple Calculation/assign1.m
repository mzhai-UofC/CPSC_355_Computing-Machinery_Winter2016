!assign1.m

		define(x_r, l0)
		define(y_r, l1)
		define(min_r, l2)
		
headerString:
		.asciz 	"x\ty\tmin\n-------------------------\n"
		
dataString:  
 		.asciz	"%d\t%d\t%d\n"
		
 		.align 	4      
		.global	main
main:    
		save	%sp, -96, %sp 		! allocate memory 
		mov	-6, %x_r     		! -6 to x
		mov 	0, %y_r 				! 0 to y
		mov	1000, %min_r 			! 1000 to min

		set	headerString, %o0	! set headerString to o0
		call	printf 				! calling printf
		mov 	0, %o1				! delay slot
		
loop:
		cmp	%x_r, 6				! compare x to 6
		bg,a 	done					! branch to done if greater than
		mov  	1, %g1 				! delay slot
		
		set	5, %o0				! 5 in %o0
		call	.mul					! calling .mul
		mov	%x_r, %o1			! x in %o1   
		 		
      call	.mul					! calling .mul  	
		mov	%x_r, %o1			! x in %o1 
		   	
      call	.mul					! calling .mul  
		mov	%x_r, %o1			! x in %o1    
		
		mov 	%o0, %y_r    		! y=5xxx

		set 	27, %o0     	 	! 27 in %o0	
		call	 .mul       		! calling .mul
		mov 	%x_r, %o1    		! x in %o1    
	
		call	.mul					! calling .mul
		mov 	%x_r, %o1   		! x in %o1    

		add	%o0, %y_r, %y_r  	! y=5xxx+27xx

		set	27, %o0				! 27 in %o0	
		call	.mul 					! calling .mul
		mov	%x_r, %o1			! x in %o1    
	     
		sub	%y_r, %o0, %y_r 	! y=5xxx+27xx-27x
         
		sub	%y_r, 43, %y_r  	! y=5xxx+27xx-27x-43

		cmp	%y_r, %min_r 		! compare y with min
		bl,a	setMin 				! branch to setMin if less than
		mov	%y_r, %min_r		! delay slot
			
		ba,a	printData			! branch always to printData
      set	dataString, %o0 	! delay slot
		
setMin:
		mov	%y_r, %min_r		! y to min

printData:
		set	dataString, %o0 	! set dataString to o0	
		mov 	%x_r, %o1 			! x to o1
		mov 	%y_r, %o2 			! y to o2
		call	printf 				! calling printf
		mov 	%min_r, %o3 			! min to o3
	
		inc  	%x_r 					! x++
		ba,a 	loop 					! branch always to loop
		cmp	%x_r, 6				! delay slot

done:         
		mov  1,  %g1 				! 1 to g1
		ta   0 						! trap to system
     