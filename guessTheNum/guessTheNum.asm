bits 64

section .data
    prompt db "Enter your guess: "
    prompt_len equ $ - prompt

    success_message db "Correct!",10
    success_message_length equ $ - success_message

    failure_message db "Incorrect, try again", 10
    failure_message_length equ $ - failure_message

    death_message db "You ran out of lives, You lose!", 10
    death_message_length equ $ - death_message

    too_low_message db "Your last guess was too low", 10
    too_low_message_length equ $ - too_low_message

    too_high_message db "Your last guess was too high", 10
    too_high_message_length equ $ - too_high_message

section .bss
    buffer resb 32
    rand_num resq 1

section .text
    global _start

_start:
    call get_rand
    mov r12, rax

    xor r13, r13
.loop:
    mov rsi, prompt
    mov rdx, prompt_len
    call print

    call read_input
    call atoi

    cmp rax, r12
    je .success

.failure:
    inc r13
    cmp r13, 3
    je .death

    mov r14, rax

    mov rsi, failure_message
    mov rdx, failure_message_length
    call print

    cmp r14, r12
    jg .too_high
    jmp .too_low

.success:
    mov rsi, success_message
    mov rdx, success_message_length
    call print
    jmp .exit

.death:
    mov rsi, death_message
    mov rdx, death_message_length
    call print
    jmp .exit

.too_high:
    mov rsi, too_high_message
    mov rdx, too_high_message_length
    call print

    jmp .loop

.too_low:
    mov rsi, too_low_message
    mov rdx, too_low_message_length
    call print

    jmp .loop

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall

print:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

read_input:
    xor rax, rax
    xor rdi, rdi
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

get_rand:
    mov rax, 318
    lea rdi, [rand_num]
    mov rsi, 8
    xor rdx, rdx
    syscall
    
    mov rax, [rand_num]
    xor rdx, rdx
    mov rcx, 10
    div rcx
    mov rax, rdx
    inc rax
    ret