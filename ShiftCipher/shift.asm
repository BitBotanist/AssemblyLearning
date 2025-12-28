section .bss
	%define msgBuffer_len 32
	msgBuffer: resb msgBuffer_len
	%define kBuffer_len 4
	kBuffer: resb kBuffer_len

section .data
	inputMsg: db 'input message:',10d
	inputMsgLength: equ $-inputMsg
	kMsg: db 'input k (0-25):',10d
	kMsgLength: equ $-kMsg
	
section .text
	global _start
	_start:
	requestInputs:
		;stdout message requesting message to encrypt
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
		mov esi, eax ;save number of bytes read
		xor ecx, ecx
	requestK:
		;stdout message requesting K
		mov eax, 4
		mov ebx, 1
		mov ecx, kMsg
		mov edx, kMsgLength
		int 80h
		movzx eax, byte [kBuffer]
		sub eax, '0'
		mov bl, al
	inputK:
		;grab stdin for k and push to stack
		mov eax, 3
		mov ebx, 0
		mov ecx, kBuffer
		mov edx, kBuffer_len
		int 80h
		mov ecx, ecx
	encryptMsg:
		cmp ecx, esi ;compare counter with buffer length (esi)
		jge outputCiphertext
		mov al, [msgBuffer+ecx] ;grab character from buffer
		push ecx ;save loop counter
		
		cmp al, 'A'
		jl notUpper
		cmp al, 'Z'
		jg notUpper
		
		upperEncrypt:
			add al, bl ;al += k
			cmp al, 'Z'+1 ;overflow?
			jl storeChar
			sub al, 25 ;wrap: 'Z'+1 -> 'A'
			jmp storeChar
		
		notUpper:
			add al, bl
			cmp al, 'z'+1
			jl storeChar
			sub al,25
			jmp storeChar
		
		storeChar:
			mov [msgBuffer+ecx], al
		
		pop ecx ;restore loop counter
		inc ecx
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