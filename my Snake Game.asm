;Firaol Teshale         

data segment
    letter_addresses dw 2484, 2120, 1712, 488, 1862, 692, 968, 3374, 1536, 1880, 2048, 3072, 1456, 1832, 2764, 1216, 3480, 3992, 2376, 3540
    snake_address dw 2482, 15 Dup(0)
    collected_letters db '*', 15 Dup(0)
    collected_count db 1
    end_message db "Game Over", "$"
    target_count db 20 ;
    score dw 0          
ends

stack segment
    dw 128 dup(0)
ends

code segment
start:
    mov ax, data
    mov ds, ax

    mov ax, 0b800h ; Video memory for text mode starts at 0xB8000
    mov es, ax

    cld
    
    ;cursor position
    mov ah, 1
    mov ch, 43
    mov cl, 11
    int 10h
    
    call clear_screen
    jmp start_game

start_game:  

    call place_letters
    call display_score

    xor cl, cl
    xor dl, dl

read_input:
    mov ah, 1   ;perform an action no need waiting
    int 16h
    jz skip_input 
        
    mov ah, 0   ;wait for input
    int 16h
    and al, 0dfh
    mov dl, al                 
    jmp skip_input

skip_input:
    cmp dl, 1bh
    je exit_game
    

check_direction:
    cmp dl, 'A'
    jne check_right
    call move_left
    mov cl, dl
    jmp read_input

check_right:
    cmp dl, 'D'
    jne check_up
    call move_right
    mov cl, dl
    jmp read_input

check_up:
    cmp dl, 'W'
    jne check_down
    call move_up
    mov cl, dl
    jmp read_input

check_down:
    cmp dl, 'S'
    jne read_next
    call move_down
    mov cl, dl
    jmp read_input

read_next:
    mov dl, cl
    jmp read_input

exit_game:
    mov ax, 4c00h
    int 21h
ends

place_letters proc
    mov di, snake_address
    mov dl, collected_letters
    es: mov [di], dl  
    
    mov cl, target_count
    lea si, letter_addresses  
    
    place_loop:
    lodsw
    mov di, ax
    mov dl, '*'
    es: mov [di], dl
    loop place_loop
    ret
endp  

move_left proc
    push dx 
    call shift_addresses
    sub word ptr [snake_address], 2
    call check_eat
    call move_snake
    call check_collision
    pop dx
    ret    
endp

move_right proc
    push dx 
    call shift_addresses
    add word ptr [snake_address], 2
    call check_eat
    call move_snake
    call check_collision
    pop dx
    ret    
endp

move_up proc
    push dx 
    call shift_addresses
    sub word ptr [snake_address], 160
    call check_eat
    call move_snake
    call check_collision
    pop dx
    ret    
endp

move_down proc
    push dx 
    call shift_addresses
    add word ptr [snake_address], 160
    call check_eat
    call move_snake
    call check_collision
    pop dx
    ret    
endp

shift_addresses proc
    push ax
    xor ch, ch
    xor bh, bh
    mov cl, collected_count
    inc cl
    mov al, 2
    mul cl
    mov bl, al
    
    xor dx, dx
    
    shift_snake:
    mov dx, word ptr [snake_address + bx - 2] ; previos snake element 
    mov word ptr [snake_address + bx], dx ;to location of next 
    sub bx, 2
    loop shift_snake
    pop ax
    ret
endp

check_eat proc
    push ax 
    push cx 

    mov di, word ptr [snake_address] 
    es: cmp [di], 0   ;check for empty space
    jz no_letter
    es: cmp [di], 20h ;check for space 
    jz no_letter 
    xor ch, ch
    mov cl, target_count 
    xor si, si
    check_loop:
    cmp di, word ptr [letter_addresses + si]
    jz add_letter
    add si, 2
    loop check_loop
    jmp no_letter
    
    
    add_letter:
    mov word ptr [letter_addresses + si], 0 
    xor bh, bh 
    mov bl, collected_count 
    es: mov dl, [di] 
    mov [collected_letters + bx], dl 
    es: mov [di], 0 
    add collected_count, 1 
    sub target_count, 1 

    
    inc score

    ; Display the updated score
    call display_score

no_letter:
    pop cx 
    pop ax 
    ret
endp 

check_collision proc
    push ax
    push cx
    push si

    mov di, word ptr [snake_address] ; snake's head position
    mov cl, collected_count
    lea si, [snake_address + 2] ; start checking from the second element

collision_loop:
    cmp di, [si]
    je game_over ; 
    add si, 2
    loop collision_loop

    pop si
    pop cx
    pop ax
    ret
endp


move_snake proc
    xor ch, ch 
    xor si, si 
    xor dl, dl 
    mov cl, collected_count 
    xor bx, bx 
    move_loop:
    mov di, word ptr [snake_address + si] 
    mov dl, [collected_letters + bx] 
    es: mov [di], dl 
    add si, 2 
    inc bx 
    loop move_loop 
    mov di, word ptr [snake_address + si] 
    es: mov [di], 0 
    ret
endp

clear_screen proc  ;make sure entire screen is cleared and page number 7
    xor cx, cx 
    mov dh, 24 
    mov dl, 79 
    mov bh, 7 
    mov ax, 700h ;for clearing text 
    int 10h 
    ret
endp    

display_score proc
    push ax
    push bx
    push cx
    push dx

    mov bx, 140
    mov ax, score
    call print_number

    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

print_number proc
    ; Print AX as a decimal number at a fixed video memory location
    push ax
    push bx
    push cx
    push dx

    mov bx, 10
    xor cx, cx

convert_loop:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    and ax, ax
    jnz convert_loop

print_digits:

    pop dx
    mov es:[bx], dl
    add bx, 2
    loop print_digits

    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

game_over:
    ; Clear the screen
    call clear_screen

    lea dx, end_message
    mov ah, 09h
    int 21h

    mov ax, 4c00h
    int 21h

end start
