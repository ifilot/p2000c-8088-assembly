;-------------------------------------------------------------------------------
;   Screen test program for the P2000C
;
;   Author: Ivo Filot <ivo@ivofilot.nl>
;
;   INFOP2KC.COM is free software:
;   you can redistribute it and/or modify it under the terms of the
;   GNU General Public License as published by the Free Software
;   Foundation, either version 3 of the License, or (at your option)
;   any later version.
;
;   INFOP2KC.COM is distributed in the hope that it will be useful,
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

    int 11h
    mov bx,ax
    call printhex

    mov ah,4ch
    int 21h

printhex:
    mov dl,bh
    mov cl,4
    ror dl,cl
    call print_nibble
    mov dl,bh
    call print_nibble
    mov dl,bl
    ror dl,cl
    call print_nibble
    mov dl,bl
    call print_nibble
    ret

print_nibble:
    and dl,0Fh
    add dl,'0'
    cmp dl,'9'
    jbe print_digit
    add dl,7
print_digit:
    mov ah,2
    int 21h
    ret