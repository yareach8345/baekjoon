STDIN equ 0x00
STDOUT equ 0x01

SYS_READ equ 0x00
SYS_WRITE equ 0x01

section .bss
input resb 3
output resb 2
output_size equ $ - output

section .text
global main
main:
    ;-- 입력 --
    ; input에 입력받은 값 저장
    mov rax, SYS_READ
    mov rdi, STDIN
    lea rsi, [rel input]
    mov rdx, 3
    syscall

    mov al, byte [rel input]
    sub al, '0'
    mov ah, byte [rel input + 2]
    sub ah, '0'

    ; 덧셈
    add al, ah
    ; 이후 나누기 작업을 위해 0으로 설정
    xor ah, ah

    ;al = al % 10, ah = ah % 10
    mov cl, 10
    div cl

    ; fill output
    ; rcx: 문자수, rbx: 문자열의 시작
    mov rcx, 0
    lea rbx, [rel output]
    add rbx, output_size - 1

    inc rcx
    add ah, '0'
    mov [rbx], ah

    cmp al, 0
    je print

    ; 10이상일 경우 10의 자리 추가
    dec rbx
    inc rcx
    add al, '0'
    add [rbx], al

print:
    ; print
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, rbx
    mov rdx, rcx

    syscall

    xor rax, rax
    ret