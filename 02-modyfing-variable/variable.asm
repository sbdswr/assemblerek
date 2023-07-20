; asmsyntax=nasm


SYSCALL_WRITE equ 1
SYSCALL_EXIT equ 60

STDOUT_FILENO equ 1
EXIT_SUCCESS equ 0


; In order to be able to modify variables we need to store them in writable
; region of memory. The standard section for writable data in Linux is called
; .data. There's also dedicated .rodata section for read-only data, and .bss
; section for data not initialized explicitly in the source file, that will
; be reserved and filled with zeroes upon execution.

section .data

message:
	db `Cello, cords!\n`
	MESSAGE_LEN equ $ - message


; Section continues unless using section keyword again. Code belongs to section
; named .text. The nasm source code starts in .text section by default.

section .text

global _start
_start:
	mov byte [message], 'H'     ; message[0] = 'H'
	mov byte [message + 7], 'w' ; message[7] = 'w'

	; We can also use a shifted "pointer"
	mov rax, message            ; rax = message
	add rax, 10                 ; rax += 10

	mov byte [rax], 'l'         ; rax[0] = 'l'
	mov byte [rax + 1], 'd'     ; rax[1] = 'd'

	; write(STDOUT_FILENO, "Hello, world!", 14);
	mov rax, SYSCALL_WRITE
	mov rdi, STDOUT_FILENO
	mov rsi, message
	mov rdx, MESSAGE_LEN
	syscall

	; exit(EXIT_SUCCESS);
	mov rax, SYSCALL_EXIT
	mov rdi, EXIT_SUCCESS
	syscall
