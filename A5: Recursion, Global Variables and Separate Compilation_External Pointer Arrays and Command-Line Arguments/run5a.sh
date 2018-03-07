m4 a5a.m > a5a.s
gcc -c a5amain.c
as a5a.s
gcc a5amain.o a5a.o -o a5a
./a5a