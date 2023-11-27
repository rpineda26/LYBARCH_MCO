global _imgAvgFilter
segment .data
image_size_x: dd 0
image_size_y: dd 0
sampling_window_size: dd 0
row_index: dd 0
col_index: dd 0
add_x: dd 0
add_y: dd 0
offset: dd 0
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
	mov ebx, [ebp + 24]
	mov [image_size_y],ebx
	
	mov dword[row_index], 0x1; row index
	mov dword[col_index], 0x1 ;col index
L1:
	mov edx, 0
	call checkBorder ;only add apply filter to the pixels not found in the border
	add dword[col_index], 0x1
	cmp edx,1 
	jne average
	mov eax, [esi]
	mov [edi], eax
	jmp updateCounter
checkBorder:
	mov ecx, [sampling_window_size]
	shr ecx, 1
	mov eax, [row_index]
	add eax, ecx
	mov ebx, [image_size_x]
	cmp  eax, ebx
	jge isBorder
	sub eax, ecx
	cmp eax, ecx
	jl isBorder

	mov eax, [col_index]
	mov ebx, [image_size_y]
	add eax, ecx
	cmp eax, ebx
	jge isBorder
	sub eax, ecx
	cmp eax, ecx
	jl isBorder
	ret 
isBorder:
	mov edx, 1
	ret 
average:
	mov ecx, [sampling_window_size]
	shr ecx, 1
	mov edx, [row_index]
	add  edx,ecx
	mov  [add_x], edx
	jmp addRow
	; results
	mov [edi], eax
	jmp updateCounter
addRow: 
	mov ebx, [sampling_window_size]
	shr ebx, 1
	mov ecx, ebx
	mov edx, [col_index]
	add  edx, ebx
	mov [add_y], edx
	cmp dword[add_x], 0
	jge  addCol
	jmp divideNum 
addCol:	
	mov edx, [add_x]
	mov ebx, [add_y]
	imul edx, [image_size_y]
	add  edx, ebx
	imul edx, 4
	sub esi, edx
	add eax, [esi]
	add esi, edx
	
	dec dword[add_y]
	cmp dword[add_y], 0
	jle backToRow
	jmp addCol
backToRow:
	dec dword[add_x]
	jmp addRow
divideNum:
	mov ebx, [sampling_window_size]
	imul ebx, ebx
	mov edx, 0
	idiv  ebx
	shr ebx,1
	cmp edx, ebx
	jge round
	jmp output
round:
	inc eax
	jmp output
output:
	mov [edi], eax
	jmp updateCounter	
	
updateCounter:
	add edi, 4
	add esi, 4
	inc dword [col_index]
	mov eax, [col_index]
	cmp eax, [image_size_y]
	jg resetCol
	jmp L1
	
resetCol:
	mov dword[col_index], 0x1
	add dword[row_index], 0x1
	mov eax, [image_size_x]
	cmp [row_index], eax
	jg terminate
	jmp L1

terminate: 
	mov esp, ebp
	pop ebp
	ret
