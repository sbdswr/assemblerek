; See chapter on Function Calling Sequence, Parameter Passing:
; https://gitlab.com/x86-psABIs/x86-64-ABI/-/jobs/artifacts/master/raw/x86-64-ABI/abi.pdf?job=build

; Short version:
; https://en.wikipedia.org/wiki/X86_calling_conventions#System_V_AMD64_ABI 


; int sum(int, int)
; => edi: first argument
; => esi: second argument
; <= eax: sum of the arguments given
sum:
	add edi, esi  ; edi += esi
	mov eax, edi  ; eax = edi
	ret


; We can also put global somewhere else, although end of file makes it a bit
; unreadable.
global sum
