STDIN equ 0x00
STDOUT equ 0x01

SYS_READ equ 0x00
SYS_WRITE equ 0x01

section .bss
input resb 4
output resb 2
output_size equ $ - output

section .text
global main
main:
    mov rax, SYS_READ
    mov rdi, STDIN
    lea rsi, [rel input]
    mov rdx, 3
    syscall

    mov al, byte [rel input]
    sub al, '0'
    mov ah, byte [rel input + 2]
    sub ah, '0'

    mov cl, 0 ; cl == 0 means result is positive
    cmp al, ah
    jge comp
    mov cl, al
    mov al, ah
    mov ah, cl
    mov cl, 1 ; cl == 1 means result is negative
comp:
    sub al, ah

    ; fill output
    mov rdx, 0
    lea rbx, [rel output]
    add rbx, output_size - 1

    inc rdx
    add al, '0'
    mov [rbx], al

    cmp cl, 0
    je print

    dec rbx
    inc rdx
    add [rbx], byte '-'

    ; print
print:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, rbx

    syscall

    xor rax, rax
    ret