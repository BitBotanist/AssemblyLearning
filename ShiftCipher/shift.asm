section .bss
	%define msgBuffer_len 32
	msgBuffer: resb msgBuffer_len
	%define kBuffer_len 4
	kBuffer: resb kBuffer_len

section .data
	inputMsg: db 'input message:',10d
	inputMsgLength: equ $-inputMsg
	kMsg: db 'input k:',10d
	kMsgLength: equ $-kMsg
	
section .text
	global _start
	_start:
	requestInputs:
		;stdout message requesting message
		mov eax, 4
		mov ebx, 1
		mov ecx, inputMsg
		mov edx, inputMsgLength
		int 80h
	inputMessage:
		;grab stdin for message and write it to buffer
		mov eax, 3
		mov ebx, 0
		mov ecx, msgBuffer
		mov edx, msgBuffer_len
		int 80h
	requestK:
		;stdout message requesting K
		mov eax, 4
		mov ebx, 1
		mov ecx, kMsg
		mov edx, kMsgLength
		int 80h
	inputK:
		;grab stdin for k and push to stack
		mov eax, 3
		mov ebx, 0
		mov ecx, kBuffer
		mov edx, kBuffer_len
		int 80h
		mov ecx, 0
	encryptMsg:
	;loop through every byte of msg buffer
		;filter if upper or lower
		;check if +K would overflow
			;if no then add K
			;if yes then letter becomes 65(upper) or 97(lower)
		cmp ecx, inputMsgLength
		jge outputCiphertext
		mov bl, [msgBuffer+ecx]
		inc ecx
		push ebx
		
		mov eax,4
		mov ebx,1
		mov ecx,esp
		mov edx,1
		;int 80h
	
		jmp encryptMsg
	
			lowerEncrypt:
	
			jmp encryptMsg
	
			upperEncrypt:
	
			jmp encryptMsg
	
	outputCiphertext:
		mov eax, 4
		mov ebx, 1
		mov ecx, msgBuffer
		mov edx, msgBuffer_len
		int 80h
	
	
	shutdown:
		mov eax, 1
		mov ebx, 0
		int 80h