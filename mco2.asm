%include "io.inc"
section .data
arr: db 0x
image_size_x: db 0x0
image_size_y: db 0x0
sampling_window_size: db 0x0
section .text
global main
main:
    mov ebp, esp; for correct debugging
;write your code here
GET_DEC 1, sampling_window_size
GET_DEC 1, image_size_x
GET_DEC 1, image_size_y
mov al, [image_size_x]
LEA esi, [arr]

mov edx, 0
PRINT_HEX 4, esi 

JMP LOOP_X

GET
LOOP_X:     CMP al, 0
            JE END_LOOP_X
            DEC al
            mov ah, [image_size_y]
            NEWLINE
            JMP LOOP_Y
            
            
            
END_LOOP_X: xor eax, eax
            ret
LOOP_Y:     CMP ah, 0
            JE END_LOOP_Y
            add esi, edx
            GET_DEC 1,[esi]
            mov BH, [esi]
            PRINT_DEC 1, BH
            inc edx
            DEC ah
            JMP LOOP_Y      
END_LOOP_Y: JMP LOOP_X
     
