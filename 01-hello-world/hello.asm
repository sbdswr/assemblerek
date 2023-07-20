; The line below is used by (neo)vim to set appropriate syntax highlighting,
; as there are many assemblers all sharing .asm extension.

; asmsyntax=nasm

; As an alternative, one may use commands:
; :let b:asmsyntax='nasm'
; :e
; to reload file with proper syntax.


; Constants

SYSCALL_WRITE equ 1
SYSCALL_EXIT equ 60

STDOUT_FILENO equ 1
EXIT_SUCCESS equ 0


; Some data, although it is placed together with code in read-only memory.

message:
	db `Hello, world!\n`  ; \n works only in backticks
	MESSAGE_LEN equ $ - message  ; $ is the address of currently assembled
	                             ; line


; Linux linker looks by default for _start label. This is where the execution
; starts And we need to make it exported, i.e. global.
global _start
_start:
	; Linux system call lists:
	; https://chromium.googlesource.com/chromiumos/docs/+/HEAD/constants/syscalls.md#x86_64-64_bit
	; https://filippo.io/linux-syscall-table/

	; man 2 write
	; write(STDOUT_FILENO, "Hello, world!", 14)
	mov rax, SYSCALL_WRITE  ; rax = SYSCALL_WRITE
	mov rdi, STDOUT_FILENO  ; rdi = STDOUT_FILENO
	; moving label to register means writing an address of that label
	; into it
	mov rsi, message        ; rsi = message
	mov rdx, MESSAGE_LEN    ; rdx = MESSAGE_LEN
	syscall

	; man 2 exit
	; exit(EXIT_SUCCESS)
	mov rax, SYSCALL_EXIT   ; rax = SYSCALL_EXIT
	mov rdi, EXIT_SUCCESS   ; rdi = EXIT_SUCCESS
	syscall
