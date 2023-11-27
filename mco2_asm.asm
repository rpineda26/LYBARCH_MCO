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
	
	mov dword[row_index], 0x0; row index
	mov dword[col_index], 0x0 ;col index
L1:
	mov edx, 0
	call checkBorder ;only add apply filter to the pixels not found in the border
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
	mov eax, 0
	mov ecx, [sampling_window_size]
	shr ecx, 1
	mov edx, [row_index]
	add  edx,ecx
	mov  [add_x], edx
	imul ecx, 4	
	imul ecx, [image_size_y]
	add  esi, ecx
	jmp addRow
addRow: 
	mov ebx, [sampling_window_size]
	shr ebx, 1
	mov edx, [col_index]
	add  edx, ebx
	mov [add_y], edx
	imul ebx, 4
	sub esi, ebx
	mov edx, [row_index]
	sub edx, ebx
	mov ebx, 0
	cmp [add_x], edx
	jge  addCol
	jmp divideNum 
addCol:		
	mov edx, 4
	imul edx, ebx
	add eax, [esi+edx]
	add esi, edx
	inc ebx
	dec dword[add_y]
	mov edx, [sampling_window_size]
	shr edx, 1
	mov ecx, [col_index]
	sub ecx, edx
	cmp [add_y], ecx
	jle backToRow
	jmp addCol
backToRow:
	mov edx, 4
	imul edx, [image_size_y]
	sub esi, edx
	mov edx, [sampling_window_size]
	shr edx, 1
	imul edx, 4
	add esi, edx
	dec dword[add_x]
	jmp addRow
divideNum:
	mov edx, [image_size_y]
	mov ebx, [sampling_window_size]
	shr ebx, 1
	imul edx, ebx
	imul edx, 4
	imul ebx, 4
	add esi, ebx
	add esi, edx
	shl ebx, 1
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
