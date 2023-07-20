; asmsyntax=nasm


; Initial state of stack on process startup is documented in:
; https://gitlab.com/x86-psABIs/x86-64-ABI/-/jobs/artifacts/master/raw/x86-64-ABI/abi.pdf?job=build
; in chapter "Initial Stack and Register State"

; Some general information about hardware stacks:
; https://en.wikipedia.org/wiki/Stack_(abstract_data_type)#Hardware_stack


global _start
_start:
	; Table of the x86-64 registers:
	; https://en.wikipedia.org/wiki/X86#/media/File:Table_of_x86_Registers_svg.svg
	; r12 is a general purpose register.
	; rsp is special - it points to the top of the stack and is changed by
	; instructions like call, ret, push or pop.

	; r12 is one of the callee saved registers, i.e. function called cannot
	; modify it.
	mov r12, rsp

; Labels beginning with dot belong to local scope of non-dot label, so we can
; use same local label names in _start and strlen.
.loop:
	; We start the loop with pointer advancement, as the top of the stack
	; contains argument count.
	add r12, 8
	
	; In each iteration rdi points to a pointer of next argument.
	mov rdi, [r12]

	; Compare rdi to 0.
	cmp rdi, 0
	; Jump if Equal - if the pointer read is NULL (0), we've reached the
	; end of argument list.
	je .done
	
	; If we haven't jumped, we continue here, printing the argument.
	; puts accepts argument to print in rdi, so it's already there.
	call puts
	; Note that there isn't any sub rsp, 8 here. This is because the only
	; calls we make here are to short local functions in this file, so we
	; can ignore System V ABI in such case, also use different registers
	; for arguments or even pass them by stack. But in general case it is
	; safer to follow the ABI everywhere.

	; Unconditionally jump back to .loop.
	jmp .loop

.done:
	call exit


; void exit(void)
exit:
	mov rax, SYSCALL_EXIT
	mov rdi, EXIT_SUCCESS
	syscall

	ret


; size_t strlen(char *str)
; => rdi: pointer to string
; <= rax: string length
strlen:
	; Start with string length 0.
	mov rax, 0
.loop:
	; Compare [rdi] to 0.
	cmp byte [rdi], 0
	; Jump if Equal - if it was zero, we've reached end of string.
	je .done

	inc rax  ; rax++ (string length)
	inc rdi  ; rdi++ (advance pointer to next character)

	jmp .loop  ; and jump to .loop unconditionaly
.done:
	; rax already contains string length.
	ret


; void puts(char *str)
; => rdi: pointer to string
puts:
	; rdi is one of the volatile registers, i.e. registers, that can be
	; freely changed by called function. And indeed our strlen
	; implementation changes rdi, so let's push it on stack first.
	push rdi      ; stack[--rbp] = rdi
	call strlen
	; And now we bring original value back to rdi from stack.
	pop rdi       ; rdi = stack[rbp++]

	mov rdx, rax  ; rax contains string length returned from strlen
	mov rax, SYSCALL_WRITE
	mov rsi, rdi            ; write() accepts buffer as 2nd argument
	mov rdi, STDOUT_FILENO  ; while 1st if file descriptor
	syscall

	mov rax, SYSCALL_WRITE

	; syscall changes only registers rax (return value), rcx and r11 (for
	; internal syscall usage). Thus rdi remains unchanged and still
	; contains STDOUT_FILENO.

	; No option to pass just a single character, as write() always requires
	; pointer to a buffer in memory.
	mov rsi, .new_line  
	mov rdx, 1
	syscall

	ret

; We can also use local label for data sneaked in .text segment.
.new_line:
	db 10


SYSCALL_WRITE equ 1
SYSCALL_EXIT equ 60

STDOUT_FILENO equ 1
EXIT_SUCCESS equ 0
