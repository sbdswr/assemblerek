; We need to inform nasm that identifier puts is not to be found in the current
; file, rather it is going to be available in link time.
extern puts


; When linking with C Runtime Library, that library provides _start entry point
; and then calls function main.
global main
main:
	; As with syscalls, the first argument for function is passed in rdi.
	mov rdi, message
	; call pushes the address of instruction right after call to stack and
	; them jumps to given label.
	call puts

	; int values in C are 32-bit wide on x86-64 and they are returned in
	; eax.
	mov eax, 0

	; ret pops the value from the top of the stacks and treats is an
	; address to jump to.
	ret


message:
	; C string functions does not require passing length, they rely on
	; strings ending with 0 instead.
	db "Hello, world!", 0
