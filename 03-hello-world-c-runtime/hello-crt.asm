; We need to inform nasm that identifier puts is not to be found in the current
; file, rather it is going to be available in link time.
extern puts


; When linking with C Runtime Library, that library provides _start entry point
; and then calls function main.
global main
main:
	; Make sure rsp is aligned to 16 bytes. This is required by ABI
	; (Application Binary Interface) before calling any function. On entry
	; to main rsp has value 16 * n - 8, n ∈ ℕ.
	sub rsp, 8

	; As with syscalls, the first argument for function is passed in rdi.
	mov rdi, message
	; call pushes the address of instruction right after call to stack and
	; them jumps to given label.
	call puts

	; int values in C are 32-bit wide on x86-64 and they are returned in
	; eax.
	mov eax, 0

	; We need to reset rsp back to original value, otherwise ret wouldn't
	; be able to read proper return address.
	add rsp, 8

	; ret pops the value from the top of the stacks and treats is an
	; address to jump to.
	ret


message:
	; C string functions does not require passing length, they rely on
	; strings ending with 0 instead.
	db "Hello, world!", 0
