nasm -f win32 mco2_asm.asm
gcc -c mco2_c.c -o mco2_c.obj -m32
gcc mco2_c.obj mco2_asm.obj -o mco2_c.exe -m32
mco2_c.exe<input.txt