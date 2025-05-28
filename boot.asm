ORG 0
BITS 16 

_start:
    jmp short start
    nop

 times 33 db 0
start:
    jmp 0x7c0:step2


handle_zero:
    mov ah, 0eh
    mov al, 'A'
    ; mov bx, 0x00
    int 0x10
    iret

hanlde_one:
    mov ah, 0eh
    mov al, 'V'
    ; mov bx, 0x00

    int 0x10
    iret

step2:
    cli ; Clear the interupts
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enables interupts

    mov word[ss:0x00], handle_zero
    mov word[ss:0x02], 0x7c0

    mov word[ss:0x04], hanlde_one
    mov word[ss:0x06], 0x7c0

    mov ax, 0x00
    div ax

    int 1

    mov ah, 2
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov bx, buffer
    int 0x13
    jc error
    jmp $

error:
    mov si, error_message
    call print
    jmp $

print:
    mov bx, 0

.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop

.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret

error_message: db 'Failed to load sector', 0

message: db 'Hello World!', 0
times 510-($ - $$) db 0
dw 0xAA55 ; For 512 bytes boot signuture needs to be.


buffer: 
