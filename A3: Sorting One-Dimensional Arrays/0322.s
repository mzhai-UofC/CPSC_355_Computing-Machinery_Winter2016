! set two variables into %o0 and %o1
! call max
! print value from %o0

! implementing max as a leaf subroutine:
! do not use save or restore
! only use %o0 to %o5
! do not call any function from inside the leaf subroutine
! find something to fill the ret, delay slot, or use a nop

.global main
.align 4
main:

	mov 23,		 %o0
	mov 21,		 %o1
	call max
	nop
printData:

	mov %o0,	%o1
	set fmt, 	%o0	
	call printf
	nop

max:
		
	ret %o0,	%o0

	call max
	 nop
	call printf
	nop:
	
	mov %g0,	%o0
	mov 1,		%g1
	ta	0
