!assign1.m

		
		
		
		
headerString:
		.asciz 	"x\ty\tmin\n-------------------------\n"
		
dataString:  
 		.asciz	"%d\t%d\t%d\n"
		
 		.align 	4      
		.global	main
main:    
		save	%sp, -96, %sp 		! allocate memory 
		mov	-6, %l0     		! -6 to x
		mov 	0, %l1 				! 0 to y
		mov	1000, %l2 			! 1000 to min

		set	headerString, %o0	! set headerString to o0
		call	printf 				! calling printf
		mov 	0, %o1				! delay slot
		
loop:
		cmp	%l0, 6				! compare x to 6
		bg,a 	done					! branch to done if greater than
		mov  	1, %g1 				! delay slot
		
		set	5, %o0				! 5 in %o0
		call	.mul					! calling .mul
		mov	%l0, %o1			! x in %o1   
		 		
      call	.mul					! calling .mul  	
		mov	%l0, %o1			! x in %o1 
		   	
      call	.mul					! calling .mul  
		mov	%l0, %o1			! x in %o1    
		
		mov 	%o0, %l1    		! y=5xxx

		set 	27, %o0     	 	! 27 in %o0	
		call	 .mul       		! calling .mul
		mov 	%l0, %o1    		! x in %o1    
	
		call	.mul					! calling .mul
		mov 	%l0, %o1   		! x in %o1    

		add	%o0, %l1, %l1  	! y=5xxx+27xx

		set	27, %o0				! 27 in %o0	
		call	.mul 					! calling .mul
		mov	%l0, %o1			! x in %o1    
	     
		sub	%l1, %o0, %l1 	! y=5xxx+27xx-27x
         
		sub	%l1, 43, %l1  	! y=5xxx+27xx-27x-43

		cmp	%l1, %l2 		! compare y with min
		bl,a	setMin 				! branch to setMin if less than
		mov	%l1, %l2		! delay slot
			
		ba,a	printData			! branch always to printData
      set	dataString, %o0 	! delay slot
		
setMin:
		mov	%l1, %l2		! y to min

printData:
		set	dataString, %o0 	! set dataString to o0	
		mov 	%l0, %o1 			! x to o1
		mov 	%l1, %o2 			! y to o2
		call	printf 				! calling printf
		mov 	%l2, %o3 			! min to o3
	
		inc  	%l0 					! x++
		ba,a 	loop 					! branch always to loop
		cmp	%l0, 6				! delay slot

done:         
		mov  1,  %g1 				! 1 to g1
		ta   0 						! trap to system
     