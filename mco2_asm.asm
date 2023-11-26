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
	mov eax, [ebp + 16]
	mov [sampling_window_size], eax
	mov eax, [ebp + 20]
	mov [image_size_x], eax
	mov eax, [ebp + 24]
	mov [image_size_y],eax
	
	IMUL eax, ebx
	mov ecx, eax
	mov dword[row_index], 0x1; row index
	mov dword[col_index], 0x1 ;col index
L1:
	call checkBorder ;only add apply filter to the pixels not found in the border
	add dword[col_index], 0x1
	cmp edx, 0
	jne average
	mov eax, [esi]
	mov [edi], eax
	add esi, 4
	add edi, 4
	mov eax, [col_index]
	cmp eax, [image_size_y]
	jge resetCol
	loop L1
	mov esp, ebp
	pop ebp
	ret
checkBorder: ;if row index not equal 0 or image_size_X
		;if col_index not equal 0 or image_size_y
	mov ebp, esp
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
	jge isBorder
	ret 
isBorder:
	mov edx, 1
	ret 
average:
	mov ebx, [sampling_window_size]
	imul ebx, ebx
	mov edx, [image_size_x]
	mov eax, [esi -4]
	add eax, [esi]
	add eax, [esi+4]
	add eax, [esi + edx]
	add edx, 4
	add eax, [esi + edx]
	sub edx, 8
	add eax, [esi + edx]
	add edx, 4
	sub esi, edx
	add eax, [esi]
	add eax, [esi - 4]
	add eax, [esi + 4]
	add esi, edx
	mov edx, 0
	idiv ebx
	mov [edi], eax
	add edi, 4
	add esi, 4
	dec ecx
	jmp L1
resetCol: 
	mov dword[col_index], 0x1
	add dword[row_index], 0x1
	dec ecx
	jmp L1
