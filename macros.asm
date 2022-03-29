PrintText macro Text ;Macro para imprimir textos
    mov ah,09h
    lea dx,offset Text
    int 21h
endm
RecibirEntrada macro  ;Macro para recibir datos de entrada 
    mov ah,01
    int 21h
endm
Cls macro   ;Macro para limpiar la pantalla
  mov  ah, 0
  mov  al, 3
  int  10H
endm

PressEnter macro
  mov ah, 00
  int 16h
endm