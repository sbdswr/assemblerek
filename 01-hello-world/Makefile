hello: hello.o
	ld hello.o -o hello

hello.o: hello.asm
	nasm -felf64 hello.asm
