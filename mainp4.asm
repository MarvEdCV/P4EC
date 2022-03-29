include macros.asm
.model large
.stack 


.data 
	datos   db 13,10,"Universidad de San Carlos de Guatemala"
			db 13,10,"Facultad de Ingenieria"
			db 13,10,"Escuela de Ciencias y Sistemas"
			db 13,10,"Arquitectura de Compiladores y ensambladores 1"
			db 13,10,"Seccion A"
			db 13,10,"Marvin Eduardo Catalan Veliz"
			db 13,10,"201905554",13,10,"Presione enter para continuar",10,13,"$"

	menu    db 13,10,"*****MENU PRINCIPAL*****"
            db 13,10,"Opciones:"
            db 13,10,"1. Calculadora"
            db 13,10,"2. Archivo"
            db 13,10,"3. Salir", 10,13, '>   $'

    modcalcu  db 13,10,"Estoy en modo calcu $"
    modcarchi  db 13,10,"Estoy en modo archivo $"	
    modsalir  db 13,10,"Estoy en modo salir $"	
.code
main proc
	mov ax,@data
	mov ds,ax
	PrintText datos
	PressEnter
	start:
		PrintText menu
		RecibirEntrada
		mov bl,al
		case1:
			cmp bl,"1"
			jne case2
			;Calculadora
            PrintText modcalcu
			jmp start
		case2:
			cmp bl,"2"
			jne case3
			;Archivo
            PrintText modcarchi
            jmp start
		case3:
			cmp bl,"3"
			jne case4
            PrintText modsalir
			mov ah,4ch
			int 21h
			jmp start
        case4:
			Cls
			jmp start
main endp   
end main