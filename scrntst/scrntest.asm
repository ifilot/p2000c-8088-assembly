;
; Open a file and output its contents to the terminal
;
; Interrupt routines overview: https://stanislavs.org/helppc/idx_interrupt.html
;

    org 100h

    ; open file using handle (file handle stored in ax)
    ; (see: https://stanislavs.org/helppc/int_21-3d.html)
    mov ah,3dh                  ; interrupt 21,3d
    mov al,00h                  ; read only
    lea dx,filename             ; filename
    int 21h                     ; call interrupt
    jc error                    ; stop on error (when CF set)
    mov [filehandle],ax         ; store filehandle

    ; change video mode
    mov ah,0fh                  ; get current video mode
    int 10h
    push ax                     ; store current video mode on the stack
    mov ax,0012h                ; set vga
    int 10h

    ; set start row counter
    mov dx,252                  ; set row counter

nextline:
    push dx                     ; put row counter on stack

    ; load single line of data into buffer
    mov ah,3fh
    mov bx,[filehandle]         ; load file handle
    mov cx,64                   ; set (maximum) number of bytes
    lea dx,buffer               ; set pointer to read buffer
    int 21h                     ; run it
    jc error                    ; stop on error

    ; set row/column counter
    pop dx                      ; retrieve row counter
    mov cx,0                    ; set starting column
    mov bh,0                    ; set page number
    mov si,buffer               ; load pointer address

nextbyte:
    push si                     ; put pointer on stack (pointer can be garbled)
    mov bl,[si]                 ; load pixel to write

%rep 8
    rcr bl,1
    rcl al,1
    and al,1
    mov ah,0ch                  ; set print pixel interrupt routine
    int 10h                     ; print pixel
    inc cx                      ; increment column
%endrep

    pop si                      ; retrieve pointer
    inc si                      ; increment pointer

    cmp cx,512
    jne nextbyte                ; if not zero, print next pixel

    inc dx                      ; increment row counter
    cmp dx,252                  ; compare with 252
    jnz nextline                ; go to next line if not 252

    ; close file
    ; (see: https://stanislavs.org/helppc/int_21-3e.html)
    mov bx,[filehandle]
    mov ah,3eh
    int 21h
    jc error

    ; wait for key press
    mov ah,00
    int 16h

    pop ax                      ; retrieve old video mode from stack
    mov ah,00                   ; revert back to old video mode
    int 10h

    ; terminate program
    mov ah,00h
    int 21h

; print error and terminate program
error:
    pop ax                      ; retrieve old video mode from stack
    mov ah,00                   ; revert back to old video mode
    int 10h                     ; run it

    mov dx,errorstring          ; set pointer to error string
    mov ah,09h                  ; print error string to screen
    int 21h                     ; run it
    
    mov ah,00h                  ; terminate program
    int 21h                     ; run it

;-------------------- SECTION DATA --------------------------------------------- 
section .data 

errorstring:
    db "An error was encountered.$"

filename: 
    db 'SCREEN.IMG',0

;-------------------- SECTION BSS ----------------------------------------------
section .bss

; number of bytes read
bytesread:
    resb 2

; two-byte filehandle
filehandle:
    resb 2

; 256 byte buffer
buffer:
    resb 64