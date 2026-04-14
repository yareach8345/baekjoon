STDIN equ 0x00
STDOUT equ 0x01

SYS_READ equ 0x00
SYS_WRITE equ 0x01

section .bss
    buf resb 10 
    buf_size equ $ - buf

section .text
global main

; ==========================================
; description - 숫자를 문자로 바꾸어서 buf에 담는다
; input 
;   - rdi : 문자로 바꿀 숫자
;   - rsi : 문자열이 저장될 곳
; output 
;   - rax : 문자열의 길이
; distroy - rax, rcx, rdx, rsi
; ==========================================
num_to_string:
    ; 프롤로그
    push rbp 
    mov rbp, rsp

    push rbx ; rbx는 callee save임으로 저장
    sub rsp, 16 ; 아스키화 된 숫자가 임시저장될 곳 (1의 자리부터 역순으로 구하게 되기에 필요)

    ; rax는 나눌 숫자
    mov rax, rdi
    ; rbx는 다음 숫자가 저장될(스택상의) 위치
    mov rbx, rsp

    ; 10으로 나누면서 나머지를 스택에 저장
    ; 1의 자리부터 역순으로 저장됨
    mov rcx, 10
    num_to_string_loop:
        mov rdx, 0
        ; rcx에는 10이 들어있다.
        ; rdx = rax % 10
        ; rax = rax / 10
        div rcx
        add rdx, '0'
        mov [rbx], rdx

        ; 다음에 저장될 위치를 가리킴
        inc rbx

        ; 종료조건 : rax == 0 (더 이상 문자로 만들 숫자가 없을 때)
        cmp rax, 0
        je num_to_string_loop_end

        jmp num_to_string_loop
    num_to_string_loop_end:

    ; rcx는 문자 수
    mov rcx, 0
    move_to_buf_loop:
        ; 다음으로 저장될 숫자를 가리킴
        dec rbx

        ; buf의 rcx자리에 rbx가 가리키는 숫자의 아스키코드 저장
        mov al, [rbx]
        mov [rsi + rcx], al

        inc rcx

        ; rbx == rsp는 더 이상 옮길 숫자가 없음을 의미
        cmp rbx, rsp
        je move_to_buf_loop_end

        jmp move_to_buf_loop
    move_to_buf_loop_end:

    add rsp, 16 ; 스택 복구

    ; 에필로그
    ; 반환값 저장
    mov rax, rcx

    pop rbx ; rbx 복구

    mov rsp, rbp
    pop rbp
    ret

main:
    ; 입력
    mov rax, SYS_READ
    mov rdi, STDIN
    lea rsi, [rel buf]
    mov rdx, buf_size
    syscall

    ; 곱할 수 저장
    movzx rax, byte [rel buf]
    sub rax, '0'
    movzx rcx, byte [rel buf + 2]
    sub rcx, '0'

    ; 곱셈 rdx:rax = rax * rcx
    mul rcx

    ; rax의 숫자를 문자열로 변환
    mov rdi, rax
    lea rsi, [rel buf]
    call num_to_string

    ; 결과 출력
    mov rdx, rax
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    lea rsi, [rel buf]
    syscall

    xor rax, rax
    ret