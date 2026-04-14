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
    ; 1. ----- 입력받기 -----
    ; input에 입력된 값 저장
    mov rax, SYS_READ
    mov rdi, STDIN
    lea rsi, [rel input]
    mov rdx, 3
    syscall

    ; 2. ----- 파싱 -----
    ;al, ah에 숫자 저장
    mov al, byte [rel input]
    mov ah, byte [rel input + 2]
    ;ascii값에서 숫자로 변환
    sub al, '0'
    sub ah, '0'

    ; 3. ----- 계산 -----
    ; 절댓값을 구하고 cl값에 따라 '-' 기호를 문자열에 추가
    ; cl은 부호플래그 0일시 양수, 1일시 음수
    mov cl, 0 ;초기화
    cmp al, ah
    jge comp
    mov cl, al
    mov al, ah
    mov ah, cl
    mov cl, 1 ;음수
comp:
    ; al에 연산의 절댓값 저장
    sub al, ah

    ; 4. ----- 문자열 제작 -----
    mov rdx, 0                  ; rdx : 문자열 길이
    lea rbx, [rel output]       ; rbx : 문자열 시작점
    add rbx, output_size - 1    ; rbx를 output의 마지막으로 초기화

    inc rdx
    add al, '0'                 ; 숫자에서 ascii 값으로
    mov [rbx], al

    cmp cl, 0                   ; 부호 플래그가 0인경우(양수인 경우)
    je print                    ; 출력으로 점프

    ; 음수일 경우 '-'기호 추가
    dec rbx
    inc rdx
    add [rbx], byte '-'

print:
    ; 5. ----- 출력 -----
    ; rdx는 문자열을 제작하며 할당하였기에 여기서 따로 할당하지는 않음
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, rbx
    syscall

    xor rax, rax
    ret