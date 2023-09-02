org 0x7C00              ;origin point is set as 0x7C00 to +512 bytes then last two bytes are the magic numbers to tell this 512 byte section is bootable
bits 16                 ;tells  assembler to execute code in 16 bit mode

;%define ENDL 0x0D, 0x0A

start:
    jmp main

puts:
    ; save registers we will modify
    push si
    push ax
    push bx

.loop:
    lodsb               ; loads next character in al
    or al, al           ; verify if next character is null?
    jz .done

    mov ah, 0x0E        ; call bios interrupt
    mov bh, 0           ; set page number to 0
    int 0x10

    jmp .loop

.done:
    pop bx
    pop ax
    pop si    
    ret
    

main:
    ; setup data segments
    mov ax, 0           ; can't set ds/es directly
    mov ds, ax
    mov es, ax
    
    ; setup stack
    mov ss, ax
    mov sp, 0x7C00      ; stack grows downwards from where we are loaded in memory

    ; print hello world message
    mov si, msg_hello
    call puts

    hlt

.halt
    jmp .halt



msg_hello: db 'i am operating systummm', 0x0D, 0x0A, 0


times 510-($-$$) db 0
dw 0AA55h