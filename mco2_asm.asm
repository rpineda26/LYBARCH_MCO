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
        ;initialize to first element in the sampling window
        mov eax, 0
        push esi
        mov ebx, [sampling_window_size]
        shr ebx, 1
        mov dword[add_x], 0
        ;first col, same row pointer
        imul ebx, 4
        sub esi, ebx
        ;first row first col pointer
        imul ebx, [image_size_y]
        sub esi, ebx
	jmp addRow
addRow: 
	mov ebx, [sampling_window_size]
	mov dword[add_y],0
	cmp [add_x], ebx
	jl addCol
	jmp divideNum
addCol:		
        ;add all elements in a row in the sampling window
        mov edx, [add_x]
        imul edx,[image_size_y]
        add edx, [add_y]
        imul edx, 4
	add eax, [esi + edx]
	inc dword[add_y]
        mov ebx, [sampling_window_size]
	cmp [add_y], ebx
	jl addCol
	jmp backToRow

backToRow:
        ;offset to next row in the sampling window
	inc dword[add_x]
	jmp addRow

divideNum:
        pop esi
	mov edx, 0
        mov ebx, [sampling_window_size]
        imul ebx,ebx
        mov ecx, ebx
        shr ecx, 1
        add eax, ecx
	idiv ebx        
	cmp edx, ecx
	jle round
	jmp output
round:
	; eax
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
