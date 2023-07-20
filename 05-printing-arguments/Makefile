arguments: arguments.o

%: %.o
	ld $< -o $@

%.o: %.asm
	nasm -felf64 $<
