section .data
    msg db "Hello World!"
    msg_len equ $ - msg
    
    SYS_WRITE equ 0x01
    STD_OUT equ 0x01
    SYS_EXIT equ 60

section .text
global main
main:
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, msg
    mov rdx, msg_len
    syscall
    
    xor rax, rax
    ret