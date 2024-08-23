;-------------------------------------------------------------------------------
;   Simple Hello World program for P2000C
;
;   Author: Ivo Filot <ivo@ivofilot.nl>
;
;   HELLO is free software:
;   you can redistribute it and/or modify it under the terms of the
;   GNU General Public License as published by the Free Software
;   Foundation, either version 3 of the License, or (at your option)
;   any later version.
;
;   HELL:O is distributed in the hope that it will be useful,
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

    mov ah,0
    mov al,5
    int 10h
    call drawdots
.loop:
    mov ah,1
    int 16h
    jz .loop
    mov ah,0
    mov al,2
    int 10h
    int 20h

drawdots:
    mov ah,0xC
    mov dx,251
    mov cx,511
    mov al,1
    int 10h
    mov dx,0
    mov cx,0
    int 10h
    mov ah,2
    mov dx,0xffff
    int 10h  
    ret
