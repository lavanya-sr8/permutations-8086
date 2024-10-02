include 'emu8086.inc'
org 100h

.data
    string db 'ABC$', 0 ; Input string (terminated by '$')
    length dw $-string-2   ; Calculate length of the string (excluding '$')

.code
main proc
    mov ax, @data          ; Initialize data segment
    mov ds, ax

    mov cx, length         ; Load length of the string into cx
    dec cx                 ; Decrement cx to get zero-based index

    mov si, 0              ; Start with the first character (index 0)
    call permute           ; Call the permutation routine                                             

    
    mov ah, 4Ch            ; DOS interrupt to terminate program
    int 21h
main endp

; Recursive procedure to generate permutations
permute proc               

    cmp si, cx             ; If si == length, print permutation
    jge print_string       ; Base case: Print permutation if si == length
    

    ; Loop over characters from current si to the end of the string
    mov di, si             ; Start swapping from current index si
permute_loop:
    ; Swap characters at si and di
    mov al, string[si]
    mov ah, string[di]
    mov string[si], ah
    mov string[di], al

    ; Recursively call permute with the next index (si + 1)
    inc si            
    push di
    call permute
    dec si                 ; Restore si after recursion
    pop di

    ; Swap back to restore original order (backtracking)
    mov al, string[si]
    mov ah, string[di]
    mov string[si], ah
    mov string[di], al

    inc di                 ; Move to the next character for swapping
    cmp di, cx             ; Compare di with end index
    jle permute_loop       ; If di <= cx, continue swapping   
    
    ;dec si
    ;inc di
    ;cmp si,0
    ;jge permute_loop
    
    ret
permute endp

; Procedure to print the current permutation
print_string proc
    mov dx, offset string  ; Load address of the string
    mov ah, 09h            ; DOS interrupt to print a string
    int 21h                ; Print the current permutation

    ; Print a new line (carriage return and line feed)
    mov dl, 0Dh
    mov ah, 02h
    int 21h
    mov dl, 0Ah
    mov ah, 02h
    int 21h

    ret
print_string endp

end main
