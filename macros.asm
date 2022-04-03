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
  getChar
  cmp al, 13
  jne imprimirDatos  
endm

;Reporte json
CreateFile macro buffer,handle
    mov ah,3ch
    mov cx,00h
    lea dx,buffer
    int 21h
    mov handle,ax
endm

OpenFile macro ruta,handle
    mov ah,3dh
    mov al,10b
    lea dx,ruta
    int 21h
    mov handle,ax
endm
CloseFile macro handle
    mov ah,3eh
    mov handle,bx
    int 21h
endm

FileWrite macro numbytes,buffer,handle
    push cx
    write  numbytes,buffer,handle
    pop cx
endm

write macro numbytes,buffer,handle
    mov ah, 40h
    mov bx,handle
    mov cx, SIZEOF numbytes
    lea dx,buffer
    int 21h
endm

ObtFecha macro buffer
    xor ax, ax
    xor bx, bx
    mov ah, 2ah
    int 21h
    mov di,0
    mov al,dl
    convertirBCD buffer
    inc di
    mov al, dh
    convertirBCD buffer
    inc di
    mov buffer[di], 32h
    inc di
    mov buffer[di], 30h 
    inc di 
    mov buffer[di], 32h
    inc di
    mov buffer[di], 30h
endm

ObtHora macro buffer
    xor     ax, ax
    xor     bx, bx
    mov     ah, 2ch
    int     21h
    mov     di,0
    mov     al, ch
    convertirBCD buffer
    inc     di
    mov     al, cl
    convertirBCD buffer
    inc     di
    mov     al, dh
    convertirBCD buffer
endm


convertirBCD macro buffer
    push dx
    xor dx,dx
    mov dl,al
    xor ax,ax
    mov bl,0ah
    mov al,dl
    div bl
    push ax
    add al,30h
    mov buffer[di], al
    inc di
    pop ax
    add ah,30h
    mov buffer[di], ah
    inc di
    pop dx
endm

RepoJSON macro IniRepo,FinRepo,TitRepo,FinTit,Datos,CierreDatos, nameFile,fecha, CierreFecha,Hora,CierreHora,Estadistica,CierreEst,Ope, CierreOpe, handle
    CreateFile nameFile, handle
    OpenFile nameFile, handle
    FileWrite  IniRepo, IniRepo, handle
    FileWrite  TitRepo,TitRepo,handle
    FileWrite  Datos,Datos,handle
    FileWrite  CierreDatos,CierreDatos,handle
    FileWrite    fecha, fecha, handle
    ObtFecha EntradaFecha
    mov ah,EntradaFecha[0] 
    mov al,EntradaFecha[1] 
    mov dia[19], ah
    mov dia[20], al
    mov ah,EntradaFecha[3] 
    mov al,EntradaFecha[4] 
    mov mes[19], ah
    mov mes[20], al
    mov ah,EntradaFecha[6] 
    mov al,EntradaFecha[7] 
    mov anio[20], ah
    mov anio[21], al 
    FileWrite dia, dia, handle
    FileWrite mes, mes, handle
    FileWrite anio, anio, handle
    FileWrite CierreFecha, CierreFecha, handle
    FileWrite Hora, Hora, handle
    ObtHora bufferhora
    mov ah,bufferhora[0] 
    mov al,bufferhora[1] 
    mov hr[20], ah
    mov hr[21], al
    mov ah,bufferhora[3] 
    mov al,bufferhora[4] 
    mov min[22], ah
    mov min[23], al
    mov ah,bufferhora[6] 
    mov al,bufferhora[7] 
    mov segu[23], ah
    mov segu[24], al 
    FileWrite  hr, hr, handle
    FileWrite  min, min, handle
    FileWrite  segu, segu, handle
    FileWrite CierreHora, CierreHora, handle
    FileWrite Estadistica, Estadistica, handle
    FileWrite media, media, handle
    FileWrite mediana, mediana, handle
    FileWrite moda, moda, handle
    FileWrite impares, impares, handle
    FileWrite Pares, Pares, handle
    FileWrite Primos, Primos, handle
    FileWrite CierreEst, CierreEst, handle
    FileWrite Ope, Ope, handle
    FileWrite Operacionesrepo, Operacionesrepo, handle
    FileWrite Eje, Eje, handle
    FileWrite calc, calc, handle
    FileWrite CierreOpe, CierreOpe, handle
    FileWrite FinTit, FinTit, handle
    FileWrite  FinRepo, FinRepo, handle
    CloseFile handle
    PrintText msgrepo
endm

Calculadora macro
	entradas:
  		PrintText Num1
  		call entrada_num1
		cmp actlon1, 5
		je dos_digitos_1
		mov bl, numero1
		sub bl, 30h
  		PrintText Num2
  		call entrada_num2
		cmp actlon2, 5
    	je dos_digitos_2
		mov cl, numero2
		sub cl, 30h
  		PrintText signo
		jmp caseoperaciones

	caseoperaciones:
		RecibirText Lec
		casesuma:
  			cmp Lec[0],43
			jne caseresta
			je suma
			jmp entradas
		caseresta:
			cmp Lec[0],45
			jne casemulti
			je resta
			jmp entradas
		casemulti:
			cmp Lec[0],42
			jne casedivi
			je multi
			jmp entradas
		casedivi:
			cmp Lec[0],47
			jne caseEnd
			je divi
			jmp entradas
		caseEnd:
		    cmp Lec[0],69
			jne ninguno
			cmp Lec[1],78
			jne ninguno
			cmp Lec[2],68
			jne ninguno
			je start

		ninguno:
			jmp entradas	
	
	dos_digitos_1:
		mov cl, numero1[0]
		sub cl, 30h
		mov ax, 0000
	decenas:
		add al, 10
		dec cl
		cmp cl, 0
		jne decenas
		mov bx, 0000
		mov bl, al
		mov cl, numero1[1]
		sub cl, 30h
		add bl, cl
	dos_digitos_2:
		mov cl, numero2[0]
		sub cl, 30h
		mov ax, 0000
	decenas2:
		add al, 10
		dec cl
		cmp cl, 0
		jne decenas2
		mov cx, 0000
		mov cl, al
		mov al, numero2[1]
		sub al, 30h
		add cl, al
		jmp caseoperaciones
	Suma:
		add bl, cl
		PrintText Result
		cmp bl, 100
		jb Imprimir2
		cmp bl, 200
		jb Imprimir3
	multi:
		mov al, bl
		mul cl
		mov multiplicacion, al
		jmp imprimirmulti
	divi:
		mov al, bl
		div cl
		mov division, al
		jmp imprimirdivi

	imprimirmulti:
		mov ah,09
		lea dx, Result
		int 21h
		mov dl, multiplicacion
		add dl,30h
		mov ah, 02
		int 21h
	
	imprimirdivi:
		mov ah,09
    	lea dx,Result
    	int 21h
    	mov dl,division
    	add dl,30h 
   	 	mov ah,02
    	int 21h

	Resta:
		PrintText Result
		cmp bl, cl
		jb Restaneg
		sub bl, cl
		jmp Imprimir2
	Restaneg:
		mov al, bl
		mov bl, cl
		mov cl, al
		mov resultado[0], '-'
		sub bl, cl
		mov ah, 00
		mov al, bl
		mov cl, 0ah
		div cl
		add ah, 30h
		mov resultado[2], ah
		add al, 30h
		mov resultado[1], al
		PrintText resultado
		PressEnter
		mov ax, 00
		mov ah, 08h
		int 21h
		mov resultado[0], ' '
		mov resultado[1] ,' '
		mov resultado[2], ' '
		jmp entradas
	Imprimir2:
		mov ah, 00
		mov al, bl
		mov cl, 0ah
		div cl
		add ah, 30h
		mov resultado[1], ah
		add al, 30h
		mov resultado[0], al
		PrintText resultado
		PressEnter
		mov ax, 00
		mov ah, 08h
		int 21h
		mov resultado[0], ' '
		mov resultado[1], ' '
		jmp entradas
	Imprimir3:
		mov ah, 00
		mov al, bl
		mov cl, 0ah
		div cl
		add ah, 30h
		mov resultado[2], ah
		mov ah, 00
		div cl
		add ah, 30h
		mov resultado[1], ah
		add al, 30h
		mov resultado[0], al
		PrintText resultado
		PressEnter
		mov ax, 00
		mov ah, 08h
		int 21h
		mov resultado[0], ' '
		mov resultado[1] ,' '
		mov resultado[2], ' '
		jmp entradas	
endm
RecibirText macro buffer
        LOCAL CONTINUE, FIN
        PUSH SI
        PUSH AX
        xor si, si
        CONTINUE:
            Entrada
            cmp al, 0dh
            je FIN
            mov buffer[si], al
            inc si
            jmp CONTINUE
        FIN:
            mov al, '$'
            mov buffer[si], al
        POP AX
        POP SI
endm  
Entrada macro
        mov ah, 01h
        int 21h
endm

leyendoJSON  macro buffer
		LOCAL SALIR, BuscarID, guardarID, guardarPadre, ObtenerNumero, BuscarNumero , Operacion, Multiplicacion 
		LOCAL IngresarID, CONTINUE, EndNumero, abrirLlave, cerrarLlave, FinOperacion, Division, Suma, Resta
		LOCAL operarFIN, guardaIDoperacion, Csuma, Cresta, Cmultiplicacion, Cdivision, guardarOperaciones 
		LOCAL numeroNegativo
		limpiarBuffer bufferOperaciones
		limpiarBuffer nombrePadre
		limpiarBuffer nombreReporte
		limpiarBuffer bufferAux
		limpiarBuffer nombreOperacion
		limpiarBuffer operaciones 
		limpiarBuffer bufferMediaR
		limpiarBuffer bufferMedianaR
		limpiarBuffer bufferMayorR
		limpiarBuffer bufferMenorR
		limpiarBuffer bufferModaR


		XOR si, si 
		XOR cx, cx 
		XOR ax, ax 
		XOR bx, bx 
		XOR dx, dx 
		MOV contadorPadre, 0
		MOV finOpe, 0
		MOV contadorLLaves, 0
		MOV contadorNumero, 0
		MOV totalOperaciones, 0

		CICLO:
			MOV dh, buffer[si]
			CMP dh, 22h ;  "
			JE  BuscarID 
			CMP dh, 7Bh ; {
			JE abrirLlave 
			CMP dh, 7Dh ; }
			JE cerrarLlave
			JMP CONTINUE

		CONTINUE:		
			CMP dh, 24h ; $ 
			JE SALIR 
			INC si 
			JMP CICLO

		abrirLlave:
			INC si 
			CMP contadorPadre, 0
			JE CICLO
			ADD contadorLLaves, 1 
			JMP CICLO

		cerrarLlave:
			SUB contadorLLaves, 1
			CMP contadorLLaves, 0
			JE FinOperacion 
			INC si 
			JMP CICLO

		FinOperacion:
			MOV finOpe, 0
			print msgResultado 
			print nombreOperacion 
			print espacio 
			; este es el resultado de la operacion 
			JMP guardarOperaciones
			
		
		guardarOperaciones:
			XOR ax, ax 
			POP ax 
			MOV auxiliar, 0
			MOV auxiliar, ax 
			; guardar ID de la operacion 

			limpiarBuffer bufferAux
			ConvertirString bufferAux
			print bufferAux
			llenarOperacionesR bufferOperaciones, inicioOR 
			llenarOperacionesR bufferOperaciones, nombreOperacion
			llenarOperacionesR bufferOperaciones, cierreComillas2
			llenarOperacionesR bufferOperaciones, bufferAux
			llenarOperacionesR bufferOperaciones, finOR 
			llenarOperacionesR bufferOperaciones, coma2
			ADD totalOperaciones, 1
			ingresarOperaciones operaciones

			MOV ax, auxiliar 
			PUSH ax 
			
			XOR ax, ax 
			XOR cx, cx 
			INC si 
			JMP CICLO
		
		BuscarID:
			INC si 
			MOV dh, buffer[si]
			mov ah, dh
			CMP dh, 22h ; para guardar EL ID necesito otra "
			JE guardarID

			CMP dh, 23h	; #
			JE BuscarNumero

			PUSH si 
			XOR si, si 
			MOV si, cx 
			MOV bufferAux[si], dh 
			inc cx 
			POP si 
			JMP BuscarID

		guardarID:
			XOR cx, cx
			XOR ax, ax 
			MOV ah, bufferAux
			;PUSH ax 
			CMP ah, 76h ; v 
			JE BuscarNumero
			
			CMP ah, 6Fh ; o
			JE buscarOperando

			CMP contadorPadre, 0
			JE guardarPadre 

			MOV contadorNumero, 0

			CMP finOpe, 0
			JE guardaIDoperacion

			;---------------- para ver que es ----------------------

			CMP ah, 61h ; a 
			JE Csuma 
			CMP ah, 41h ; A 
			JE Csuma 
			CMP ah, 64h ; d
			JE Cdivision
			CMP ah, 44h ; D 
			JE Cdivision
			CMP ah, 73h ; s 
			JE Cresta 
			CMP ah, 53h ; S 
			JE Cresta
			CMP ah, 6Dh ; m 
			JE Cmultiplicacion
			CMP ah, 4Dh ; M 
			JE Cmultiplicacion
			
			;CMP ah, 6h ; V 
			;JE BuscarNumero

			PUSH ax 
			;print saltoLinea
			;print bufferAux 
			limpiarBuffer bufferAux
			XOR cx, cx 
			INC si 
			JMP CICLO

		Csuma:
			XOR ax, ax 
			MOV ah, 2Bh ; +
			limpiarBuffer bufferAux
			MOV bufferAux, ah 
			PUSH ax 

			;print saltoLinea
			;print bufferAux
			limpiarBuffer bufferAux
			XOR cx, cx 
			INC si 
			JMP CICLO

		Cresta:
			XOR ax, ax 
			MOV ah, 2Dh ; - 
			limpiarBuffer bufferAux
			MOV bufferAux, ah 
			PUSH ax 

			;print saltoLinea
			;print bufferAux
			limpiarBuffer bufferAux
			XOR cx, cx 
			INC si 
			JMP CICLO

		Cmultiplicacion:
			XOR ax, ax 
			MOV ah, 2Ah ; *
			limpiarBuffer bufferAux
			MOV bufferAux, ah 
			PUSH ax 

			;print saltoLinea
			;print bufferAux
			limpiarBuffer bufferAux
			XOR cx, cx 
			INC si 
			JMP CICLO

		Cdivision:
			XOR ax, ax 
			MOV ah, 2Fh ; /
			limpiarBuffer bufferAux
			MOV bufferAux, ah 
			PUSH ax 

			;print saltoLinea
			;print bufferAux
			limpiarBuffer bufferAux
			XOR cx, cx 
			INC si 
			JMP CICLO

		guardaIDoperacion:
			MOV finOpe, 1
			;print msgIDoperacion
			;print bufferAux
			transferir bufferAux, nombreOperacion
			limpiarBuffer bufferAux
			XOR cx, cx
			INC si 
			JMP CICLO 		

		guardarPadre:
			MOV contadorPadre, 2
			;getChar
			print msgnombrePadre 
			print bufferAux
			transferir bufferAux, nombrePadre
			limpiarBuffer bufferAux
			XOR cx, cx
			INC si 
			JMP CICLO 

		BuscarNumero:
			limpiarBuffer bufferAux
			MOV negativo, 0 ; aqiiii 
			INC si 
			MOV dh, buffer[si]
			CMP dh, 22h 
			JE BuscarNumero
			CMP dh, 3Ah 
			JE BuscarNumero
			CMP dh, 20h 
			JE BuscarNumero
			JMP ObtenerNumero

		buscarOperando:
			limpiarBuffer bufferAux
			INC si 
			MOV dh, buffer[si]
			CMP dh, 3Ah 			; :
			JE buscarOperando
			CMP dh, 20h 			; espacio
			JE buscarOperando
			JMP CICLO	

		ObtenerNumero:
			MOV dh, buffer[si]
			CMP dh, 2Ch ; , 
			JE EndNumero 
			CMP dh, 7Dh ; }
			JE EndNumero
			CMP dh, 0ah ; \n 
			JE EndNumero 
			CMP dh, 20h ; espacio 
			JE EndNumero

			CMP dh, 2Dh ; - 
			JE numeroNegativo

			PUSH si 
			XOR si, si 
			MOV si, cx 
			MOV bufferAux[si], dh 
			inc cx 
			POP si 
			INC si 
			JMP ObtenerNumero

		numeroNegativo:
			MOV negativo, 1
			INC si 
			MOV dh, buffer[si]

			PUSH si 
			XOR si, si 
			MOV si, cx 
			MOV bufferAux[si], dh 
			INC cx 
			POP si 
			INC si 
			JMP ObtenerNumero

		EndNumero:
			XOR cx, cx 
			XOR ax, ax 
			CMP contadorNumero, 0
			JE primerNumero 
			CMP contadorNumero, 1
			JE segundoNumero
			JMP CICLO

		primerNumero:
			MOV contadorNumero, 1
			;getChar
			;print saltoLinea
			;print bufferAux

			ConvertirAscii bufferAux
			PUSH ax 

			;limpiarBuffer bufferAux
			XOR cx, cx 
			INC si 
			JMP CICLO 

		segundoNumero:
			MOV contadorNumero, 0

			;getChar
			;print saltoLinea 
			;print bufferAux
			ConvertirAscii bufferAux
			PUSH ax 
			;limpiarBuffer bufferAux
			JMP  Operacion 
			XOR cx, cx 
			INC si 
			JMP CICLO

		Operacion:
			XOR bx, bx 
			XOR cx, cx 
			XOR ax, ax 
			POP ax  
			MOV bx, ax 
			POP ax  
			MOV cx, ax 
			POP ax 

			CMP ah, 2Ah 
			JE Multiplicacion
			CMP ah, 2Fh 
			JE Division 
			CMP ah, 2Bh 
			JE Suma
			CMP ah, 2Dh 
			JE Resta			

		Suma:			
			;print suma1
			MOV ax, cx 
			ADD ax, bx 

			XOR cx, cx 
			MOV cx, ax 
			PUSH ax 
			MOV ax, cx
			ConvertirString bufferAux
			;print saltoLinea
		    ;print bufferAux
		    MOV contadorNumero, 1
		    JMP revisarPila
			
			XOR cx, cx 
			INC si 
			JMP CICLO

		Resta:
			;print resta1 
			MOV ax, cx 
			SUB ax, bx 

			XOR cx, cx 
			MOV cx, ax 
			PUSH ax 
			MOV ax, cx
			ConvertirString bufferAux
			;print saltoLinea
		    ;print bufferAux

			POP ax 
			MOV bx, ax 
			limpiarBuffer bufferAux
			ConvertirString bufferAux
			;print saltoLinea
			;print bufferAux
			MOV ax, bx 
			PUSH ax 
			MOV contadorNumero, 1
			JMP revisarPila
			XOR cx, cx 
			INC si 
			JMP CICLO

		Multiplicacion:
			;print multiplicacion1 
			MOV ax, cx 
			IMUL bx 		

			XOR cx, cx 
			MOV cx, ax 
			PUSH ax 
			MOV ax, cx		    

			;ConvertirString bufferAux
			;print saltoLinea
		    ;print bufferAux

		    MOV contadorNumero, 1
		    JMP revisarPila 
			XOR cx, cx
			INC si 
			JMP CICLO

		Division:
			;print division1  ; aqio va bien JAJAJA 
			XOR dx, dx 
			MOV ax, cx 
			CWD 
			IDIV bx		

			XOR cx, cx 
			MOV cx, ax 
			PUSH ax 
			MOV ax, cx
			ConvertirString bufferAux
			;print saltoLinea
		    ;print bufferAux

		    MOV contadorNumero, 1
			JMP revisarPila 

			XOR cx, cx 			
			INC si 
			JMP CICLO

		revisarPila:
			;print msgRevisarPila 
		 	XOR cx, cx
		 	XOR bx, bx 
		 	XOR ax, ax 
		 	POP ax  
		 	MOV bx, ax 
		 	POP ax  

		 	CMP ah, 2Ah  ; *
			JE regresarPila
			CMP ah, 2Fh  ; /
			JE regresarPila
			CMP ah, 2Bh  ; +
			JE regresarPila
			CMP ah, 2Dh  ; -
			JE regresarPila
			
			MOV cx, ax 
			POP ax 

			CMP ah, 2Ah 
			JE Multiplicacion
			CMP ah, 2Fh 
			JE Division 
			CMP ah, 2Bh 
			JE Suma
			CMP ah, 2Dh 
			JE Resta

		regresarPila:
			PUSH ax 
			MOV ax, bx 
			PUSH ax 
			INC si 
			JMP CICLO

		SALIR:
			XOR ax, ax
			MOV ax, totalOperaciones
            ;print msgTotalOperaciones
			;print bufferAux
			limpiarBuffer bufferAux
			ConvertirString bufferAux
      print msgTotalOperaciones
			print bufferAux
			limpiarBuffer bufferAux		
endm 
print macro cadena
        MOV ah, 09h
        MOV dx,offset cadena
        INT 21h
endm
limpiarBuffer macro fila
    LOCAL CICLO, SALIR
    PUSH cx 
    PUSH si 
    PUSH dx 

    mov cx, SIZEOF fila
    xor si, si
    MOV si, 0
    CICLO:
        xor dl, dl
        MOV fila[si], 24h
        inc si
        dec cx 
        cmp cx, 0
        je SALIR
        JMP CICLO

    SALIR:
        POP dx 
        POP si
        POP cx 
endm
revisarBuffer macro 
    LOCAL CONTINUE, Imprimir, SALIR
    PUSH cx

    MOV cx, 20
    XOR si, si 
    MOV si, offset bufferLectura

    CONTINUE:
        XOR dl, dl
        MOV dl, [si]
        ;printChar[si]
        analizador   ; aqui cambie para probar el analizador
        inc si
        LOOP CONTINUE
        JMP SALIR

    Imprimir:
        printChar [si]
        inc si 
        JMP CONTINUE

    SALIR:
        POP cx
endm
opcion1 macro 
    limpiarBuffer bufferLectura
    limpiarBuffer nombrePadre
    limpiarBuffer nombreReporte
    limpiarBuffer namePadre
    generarDress rutaArchivo
    openF rutaArchivo, handleFichero
    leerF bufferLectura, bufferLectura, handleFichero
    closeF handleFichero      ;print bufferLectura
    leyendoJSON bufferLectura
    print saltoLinea
    print nombrePadre
    print msgArchivoLeido
    print saltoLinea
endm
ConvertirString macro buffer
    LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN2,FIN
    PUSH si 
    PUSH cx 
    PUSH bx 
    PUSH dx 
    xor si,si
    xor cx,cx
    xor bx,bx
    xor dx,dx
    mov dl,0ah
    test ax,1000000000000000
    jnz NEGATIVO
    jmp Dividir2

    NEGATIVO:
        neg ax
        mov buffer[si],45
        inc si
        jmp Dividir2

    Dividir:
        xor ah,ah
    Dividir2:
        div dl
        inc cx
        push ax
        cmp al,00h
        je FinCr3
        jmp Dividir
    FinCr3:
        pop ax
        add ah,30h
        mov buffer[si],ah
        inc si
        loop FinCr3
        mov ah,24h
        mov buffer[si],ah
        inc si
    FIN:
        POP dx 
        POP bx 
        POP cx 
        POP si 
endm
ConvertirAscii macro numero
    LOCAL INICIO,FIN, negar, SALIR 
    PUSH bx 
    PUSH cx 
    PUSH si 

    xor ax,ax
    xor bx,bx
    xor cx,cx
    mov bx,10
    xor si,si
    INICIO:
        mov cl,numero[si] 
        cmp cl,48
        jl FIN
        cmp cl,57
        jg FIN
        inc si
        sub cl,48
        mul bx
        add ax,cx
        jmp INICIO
    FIN:
        CMP negativo, 1
        JE negar 
        POP si
        POP cx 
        POP bx 
        JMP SALIR 
    negar:
        MOV negativo, 0
        NEG ax 
        POP si 
        POP cx 
        POP bx 

    SALIR:
endm

getChar macro
    mov ah,01h
    int 21h
endm

getNumero macro buffer
    LOCAL INICIO,FIN, numeroNegativo
    MOV negativo, 0
    xor si,si
    INICIO:
        getChar
        cmp al,0dh
        je FIN
        CMP al,45 
        je numeroNegativo 
        mov buffer[si],al
        inc si
        jmp INICIO

    numeroNegativo:
        MOV negativo, 1
        JMP INICIO 
    FIN:
        mov buffer[si],00h
endm

transferirExtension macro arreglo1, arreglo2, arreglo3,

    LEA si, arreglo1
    LEA bx, arreglo2
    MOV cx, 12

    CONTINUE:
        MOV ax, [si] 
        MOV [bx], ax
        INC si 
        INC bx
        LOOP CONTINUE

    LEA si, arreglo3
    MOV cx,4 

    OTRO: 
        MOV ax, [si]
        MOV [bx],ax
        INC si 
        INC bx 
        LOOP OTRO
endm

transferir macro arreglo1, arreglo2 
    LOCAL INGRESAR
    PUSH si 
    PUSH cx
    PUSH ax 
    PUSH bx
    LEA si, arreglo1
    LEA bx, arreglo2
    MOV cx, 12

    INGRESAR:
        MOV ax, [si] 
        MOV [bx], ax
        INC si 
        INC bx
        LOOP INGRESAR

    POP bx 
    POP ax 
    POP cx 
    POP si 
endm

transferirCadenas macro arreglo1, arreglo2
    LOCAL INGRESAR
    PUSH si 
    PUSH cx
    PUSH ax 
    PUSH bx
    LEA si, arreglo1
    LEA bx, arreglo2
    MOV cx, 10

    INGRESAR:
        MOV ax, [si] 
        MOV [bx], ax
        INC si 
        INC bx
        LOOP INGRESAR

    POP bx 
    POP ax 
    POP cx 
    POP si 
endm

transferir2 macro arreglo1, arreglo2, cantidad 
    LOCAL INGRESAR, SALIR
    PUSH si 
    PUSH cx
    PUSH ax 
    PUSH bx
    LEA si, arreglo1
    LEA bx, arreglo2
    MOV cx, cantidad

    INGRESAR:
        MOV ax, [si] 
        CMP ax, 24h 
        JE SALIR
        MOV [bx], ax
        INC si 
        INC bx
        LOOP INGRESAR

    SALIR:

    MOV ax, 00h 
    MOV [bx], ax 

    POP bx 
    POP ax 
    POP cx 
    POP si 
endm
llenarOperacionesR macro arreglo, arreglo2
    LOCAL CICLO, INGRESAR, Fin 
    PUSH si 
    PUSH ax 
    PUSH bx 
    PUSH cx 

    MOV cx, SIZEOF arreglo
    LEA bx, arreglo2  ; este es el que quiero ingresar 
    LEA si, arreglo

        CICLO:
            XOR ax, ax 
            MOV ax, [si]
            CMP al, 24h 
            JE INGRESAR
            INC si 
            JMP CICLO

        INGRESAR:
            XOR ax, ax 
            MOV ax, [bx]
            CMP al, 24h 
            JE Fin 
            MOV [si], ax 
            INC bx 
            INC si 
            JMP INGRESAR

        Fin:

    POP cx
    POP bx 
    POP ax 
    POP si 
endm 

contador macro buffer
    LOCAL CICLO, FIN
    PUSH si 
    PUSH ax 
    PUSH bx 
    PUSH cx 
    MOV numeroEscribir, 0

    LEA si, buffer
    MOV cx, 0

    CICLO:
        MOV ax, ax 
        MOV ax, [si]
        CMP al, 24h 
        JE FIN 
        INC si 
        INC cx 
        JMP CICLO 

    FIN:
        MOV numeroEscribir, cx 
        POP cx
        POP bx
        POP ax 
        POP si 
endm
ObtenerResultados macro 
    writeF SIZEOF inicioResultados, inicioResultados, handleFicheroReporte

    ;MEDIA 
    contador bufferMediaR
    writeF numeroEscribir, bufferMediaR, handleFicheroReporte
    writeF SIZEOF coma, coma, handleFicheroReporte

    ;MEDIANA  --- NO SE HA HECHO  ---
    writeF SIZEOF bufferMediana, bufferMediana, handleFicheroReporte
    writeF SIZEOF coma, coma, handleFicheroReporte

    ; MODA  --- NO SE HA HECHO  --- 
    writeF SIZEOF bufferModa, bufferModa, handleFicheroReporte
    writeF SIZEOF coma, coma, handleFicheroReporte

    ;MENOR
    writeF SIZEOF bufferMenor, bufferMenor, handleFicheroReporte
    contador bufferMenorR
    writeF numeroEscribir, bufferMenorR, handleFicheroReporte
    writeF SIZEOF coma, coma, handleFicheroReporte

    ;MAYOR 
    writeF SIZEOF bufferMayor, bufferMayor, handleFicheroReporte
    contador bufferMayorR
    writeF numeroEscribir, bufferMayorR, handleFicheroReporte

    writeF SIZEOF cerrarObject1, cerrarObject1, handleFicheroReporte
endm 

ObtenerOperaciones macro 
    writeF SIZEOF comilla, comilla, handleFicheroReporte
    contador namePadre
    writeF numeroEscribir, namePadre, handleFicheroReporte
    writeF SIZEOF cierreComillas, cierreComillas, handleFicheroReporte
    writeF SIZEOF inicioArreglo, inicioArreglo, handleFicheroReporte
    contador bufferOperaciones
    dec numeroEscribir
    writeF numeroEscribir, bufferOperaciones, handleFicheroReporte
    ; =============AQUI TODAS LAS OPERACIONES QUE SE REALIZEN CON SU RESULTADO =========
    writeF SIZEOF finArreglo, finArreglo, handleFicheroReporte
endm 

showDate macro
        MOV DL,BH      ; Since the values are in BX, BH Part
        ADD DL,30H     ; ASCII Adjustment

        MOV bufferFecha[si],dl 
        inc si 

        MOV DL,BL      ; BL Part 
        ADD DL,30H     ; ASCII Adjustment
        MOV bufferFecha[si],dl 
        inc si 
        writeF SIZEOF bufferFecha, bufferFecha, handleFicheroReporte
endm
ingresarOperaciones macro buffer 
    LOCAL CICLO, INGRESAR
    PUSH si 
    PUSH ax 
    PUSH bx 
    PUSH cx 

    limpiarBuffer bufferAux
    LEA si, buffer 
    MOV cx, totalOperaciones

        CICLO:
            MOV ax, [si]
            CMP al, 24h 
            JE INGRESAR
            INC si 
            INC si 
            JMP CICLO

        INGRESAR:
            MOV ax, auxiliar
            MOV [si],ax
            MOV auxiliar, 0
            ;ConvertirString bufferAux
            ;print saltoLinea 
            ;print bufferAux
            POP cx 
            POP bx 
            POP ax 
            POP si 
endm
closeF macro handle
    MOV ah, 3eh
    MOV handle, bx
    INT 21h 
endm
leerF macro numbytes, buffer, handle ;; ESTE FUNCIONA 
    LOCAL ErrorRead, SALIR
    MOV ah,3fh 
    MOV bx,handle
    MOV cx, SIZEOF numbytes
    LEA dx, buffer
    INT 21h 
    JC ErrorRead
    JMP SALIR

    ErrorRead:
        print msgErrorRead

    SALIR:
        ;print buffer
endm
openF macro ruta, handle
    MOV ah, 3dh
    MOV al, 10h 
    LEA dx, ruta 
    INT 21h 
    MOV handle, ax
endm
generarDress macro buffer
    LOCAL CONTINUE, FIN
    PUSH SI
    PUSH AX

    xor si,si
    CONTINUE:
    getChar
    cmp al,0dh
    je FIN
    mov buffer[si],al
    inc si
    jmp CONTINUE

    FIN:
    mov al,'$'
    mov buffer[si],al
    POP AX
    POP SI
endm
calcularMedia macro arreglo 
    LOCAL CONTEO, SALIR
    XOR ax, ax 
    MOV cx, 0
    MOV cx,ax
    MOV ax, 0
    LEA si, arreglo
    CONTEO:
        CMP cx,totalOperaciones
        JE FIN 
        INC cx 
        XOR bx, bx
        MOV bx, [si]
        ADD ax, bx 
        INC si
        INC si 
        JMP CONTEO
    FIN:
        CWD
        IDIV totalOperaciones ; el promedio esta en al 
        MOV media1, ax 
        limpiarBuffer bufferAux
        ConvertirString bufferAux
        transferirCadenas bufferAux, bufferMediaR
endm