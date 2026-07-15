bits 64

section .data
    prompt1 db "First number: "
    p1len equ $ - prompt1

    prompt2 db "Second number: "
    p2len equ $ - prompt2

    prompt_op db "Enter your operator: "
    prompt_op_len equ $ - prompt_op

    invalid_input db "Invalid input, try again...", 10
    invalid_input_length equ $ - invalid_input

section .bss
    buffer resb 32
    output resb 32

section .text
    global _start

_start:
    mov rsi, prompt1
    mov rdx, p1len
    call print

    call read_input
    mov rsi, buffer
    call atoi
    mov r12, rax

    mov rsi, prompt2
    mov rdx, p2len
    call print

    call read_input
    mov rsi, buffer
    call atoi
    mov r13, rax

.op_loop:
    mov rsi, prompt_op
    mov rdx, prompt_op_len
    call print

    call read_input
    mov rbx, buffer
    movzx rsi, byte [rbx]

    cmp rsi, 42
    je .multiply
    cmp rsi, 43
    je .add
    cmp rsi, 45
    je .subtract
    cmp rsi, 47
    je .divide

    mov rsi, invalid_input
    mov rdx, invalid_input_length
    call print
    jmp .op_loop

.add:
    add r12, r13
    mov rax, r12
    jmp .end

.subtract:
    sub r12, r13
    mov rax, r12
    jmp .end

.multiply:
    imul r12, r13
    mov rax, r12
    jmp .end

.divide:
    mov rax, r12
    div r13
    jmp .end

.end:
    call itoa
    call print

    mov rax, 60
    xor rdi, rdi
    syscall



print:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

read_input:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 32
    syscall
    ret

atoi:
    xor rax, rax
.loop:
    movzx rbx, byte [rsi]

    cmp rbx, 10
    je .done

    sub rbx, '0'

    imul rax, 10
    add rax, rbx

    inc rsi
    jmp .loop
.done:
    ret

itoa:
    lea rsi, [output + 31]   ; point to end of buffer
    mov byte [rsi], 10       ; newline
    mov rcx, 1               ; length starts at 1

.loop:
    xor rdx, rdx             ; RDX:RAX is dividend
    mov rbx, 10
    div rbx                  ; RAX = quotient, RDX = remainder

    add dl, '0'              ; digit -> ASCII

    dec rsi
    mov [rsi], dl

    inc rcx

    test rax, rax
    jnz .loop

    mov rdx, rcx             ; length
    ret