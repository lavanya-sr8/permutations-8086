include 'emu8086.inc'
org 100h

.data
    string dw 'A', 'B', 'C', 0 ; Input string (terminated by 0)
    length dw $-string-2   ; Calculate length of the string (excluding 0)

.code
main proc
    mov ax, @data          ; Initialize data segment
    mov ds, ax

    mov cx, length         ; Load length of the string into cx
    sub cx, 2              ; Decrement cx to get zero-based index

    mov si, 0              ; Start with the first character (index 0)
    call permute           ; Call the permutation routine                                             

    
    mov ah, 4Ch            ; DOS interrupt to terminate program
    int 21h
main endp



permute proc               
    cmp si, cx             
    jge print_string       ; Base case: Print permutation if si == length
    mov di, si             ; Start swapping from current index si
permute_loop:
    ; Swap characters at si and di
    mov ax, string[si]
    mov bx, string[di]
    mov string[si], bx
    mov string[di], ax

    ; Recursively call permute with the next index (si + 1)
    add si, 2            
    push di                  ; Push di onto the stack, to perform swapping after the recursive calls
    call permute
    sub si, 2                ; Restore si after recursion
    pop di

    ; Swap back to restore original order (backtracking)
    mov ax, string[si]
    mov bx, string[di]
    mov string[si], bx
    mov string[di], ax

    add di, 2              ; Move to the next character for swapping
    cmp di, cx             ; Compare di with end index
    jle permute_loop       ; If di <= cx, continue swapping   
    
    ret
permute endp



print_string proc
    mov di, 0              ; Start from the beginning of the string
print_loop:
    mov ax, string[di]     ; Load the 16-bit character from the string
    cmp ax, 0              
    je done_printing       ; Exit the loop, if null terminator is reached

    ; Print the character using DOS interrupt
    mov dl, al             ; Move the lower byte (character) to DL
    mov ah, 02h            ; DOS function to print a character
    int 21h

    add di, 2              ; Move to the next 16-bit character
    jmp print_loop         ; Repeat the loop

done_printing:
    ; Print a new line after each permutation
    mov dl, 0Dh            ; Carriage return
    mov ah, 02h
    int 21h
    mov dl, 0Ah            ; Line feed
    mov ah, 02h
    int 21h
    ret
print_string endp


end main
