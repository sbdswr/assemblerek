global hello_syscall
global hello_puts

; void hello_syscall(void)
hello_syscall:
	mov rax, SYSCALL_WRITE
	mov rdi, STDOUT_FILENO
	mov rsi, message1
	mov rdx, MESSAGE1_LEN
	syscall

	; Functions returning "void", i.e. nothing, don't need to set rAX.
	ret

; void hello_puts(void)
hello_puts:
	; Note that stack alignment isn't required in functions using syscall,
	; like the hello_syscall above as those don't utilize user process
	; stack.
	sub rsp, 8

	mov rdi, message2
	call puts

	add rsp, 8
	ret

message1:
	db "Hello, world!", 10
	MESSAGE1_LEN equ $ - message1

message2:
	db "Hello, world!", 0

; There's no difference whether you put extern or constants before use or not.

extern puts

SYSCALL_WRITE equ 1
STDOUT_FILENO equ 1
