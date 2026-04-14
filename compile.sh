mkdir -p ./build
echo build $1
nasm -g -f elf64 $1.asm -o ./build/obj.o
gcc ./build/obj.o -o ./build/app