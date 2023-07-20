variable: variable.o
	ld $< -o $@

%.o: %.asm
	nasm -felf64 $<
