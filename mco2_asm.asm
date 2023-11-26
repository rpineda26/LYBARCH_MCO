global _imgAvgFilter
segment .data
image_size_x: dd 0
image_size_y: dd 0
sampling_window_size: dd 0
row_index: dd 0
col_index: dd 0
segment .text
_imgAvgFilter:
	push ebp
	mov ebp, esp
	mov esi, [ebp+8]
	mov edi, [ebp + 12]
	mov dword[sampling_window_size], [ebp + 16]
	mov dword[image_size_x], [ebp + 20]
	mov dword[image_size_y], [ebp + 24]
	
	IMUL eax, ebx
	mov ecx, eax
	mov dword[row_index], 0x1; row index
	mov dword[col_index], 0x1 ;col index
L1:
	call checkBorder ;only add apply filter to the pixels not found in the border
	add dword[row_index], 0x1
	add dword[col_index], 0x1
	cmp edx, 0
	jne averaged
	mov eax, [esi]
	mov [edi], eax
	add esi, 4
	add edi, 4
	loop L1
	xor eax, eax
	ret
checkBorder: ;if row index not equal 0 or image_size_X
		;if col_index not equal 0 or image_size_y
	mov eax, [row_index]
	mov ebx, [image_size_x]
	cmp  eax, ebx
	jge isBorder
	cmp dword[row_index], 0x0
	jge isBorder
	mov eax, [col_index]
	mov ebx, [image_size_y]
	cmp eax, ebx
	jge isBorder
	cmp dword[col_index], 0x0
	jge isBrder
	mov esp, ebp
	ret 
isBorder:
	mov edx, 1
	mov esp, ebp
	ret 
average:
	mov ebx, [sampling_window_size]
	imul ebx, ebx
	mov edx, 0x4
	mov eax, [esi -4]
	add eax, [esi]
	add eax, [esi+4]
	add eax, [esi + ebx]
	add eax, [esi + ebx + edx]
	add eax, [esi +  ebx - edx]
	add eax, [esi - ebx]
	add ebx, 4
	add eax, [esi - ebx]
	sub ebx, 8
	add eax, [esi - ebx]
	mov edx, 0
	idiv ebx
	mov [edi], eax
	add edi, 4
	add esi, 4
	loop L1
