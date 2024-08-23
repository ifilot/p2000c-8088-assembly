;-------------------------------------------------------------------------------
;   Screen test program for the P2000C: this program will load "SCREEN.IMG" and
;   show it on the screen in graphical mode.
;
;   Author: Ivo Filot <ivo@ivofilot.nl>
;
;   SCRNTEST.COM is free software:
;   you can redistribute it and/or modify it under the terms of the
;   GNU General Public License as published by the Free Software
;   Foundation, either version 3 of the License, or (at your option)
;   any later version.
;
;   SCRNTEST.COM is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty
;   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
;   See the GNU General Public License for more details.
;
;   You should have received a copy of the GNU General Public License
;   along with this program.  If not, see http://www.gnu.org/licenses/.
;
;-------------------------------------------------------------------------------
CPU 8086    ; specifically compile for 8086 architecture (compatible with 8088)
;-------------------------------------------------------------------------------

    org 100h

start:
    ; open file handle using existing file
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
    mov [videomode],al          ; store video mode
    mov ax,5                    ; set graphical mode
    int 10h

    ; set start row counter
    mov dx,252                  ; set row counter

nextline:
    push dx                     ; put row counter on stack

    ; load single line of data (512 pixels = 64 bytes) into buffer
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
    mov bl,[si]                 ; load pixel to write

%rep 8                          ; transfer the 8 bits as pixels to the screen
    rcr bl,1
    rcl al,1
    and al,1
    mov ah,0ch                  ; set print pixel interrupt routine
    int 10h                     ; print pixel
    inc cx                      ; increment column
%endrep

    inc si                      ; increment pointer
    cmp cx,512                  ; check if all pixels are consumed
    jne nextbyte                ; if not zero, print next 8 pixels

    inc dx                      ; increment row counter
    cmp dx,252                  ; compare with 252
    jnz nextline                ; go to next line if not 252

    ; close file handle
    ; (see: https://stanislavs.org/helppc/int_21-3e.html)
    mov bx,[filehandle]
    mov ah,3eh
    int 21h
    jc error

    ; wait for key press
    mov ah,00
    int 16h

    ; revert back to old video mode
    mov al,[videomode]
    mov ah,00
    int 10h

    ; terminate program
    mov ah,00h
    int 21h

;-------------------------------------------------------------------------------
; print error and terminate program
;-------------------------------------------------------------------------------
error:
    mov al,[videomode]
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

videomode:
    resb 1

; number of bytes read
bytesread:
    resb 2

; two-byte filehandle
filehandle:
    resb 2

; 64 byte buffer
buffer:
    resb 64