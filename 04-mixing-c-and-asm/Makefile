mixing: mixing.o hellos.o math.o

mixing.o: mixing.c hellos.h math.h

%.o: %.asm
	nasm -felf64 $<
