include macros.asm
.model large
.stack 


.data 
	datosn   db 13,10,"Universidad de San Carlos de Guatemala"
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
;INICIO VARIABLES DE REPORTE
IniRepo db 0ah, 0dh,        '{'
    FinRepo db 0ah, 0dh,        '}'
    TitRepo db 0ah, 0dh,        '   "reporte":['
    FinTit db 0ah, 0dh,         '    ]'
    Datos db 0ah, 0dh,          '       "Datos": {',
                  0ah,          '           "nombre": "Marvin Eduardo Catalán Véliz",',
                  0ah,          '           "carnet":"201905554",',
                  0ah,          '           "curso":"Arquitectura de compiladores y ensambladores 1",',
                  0ah,          '           "sección":"A"'
    CierreDatos db 0ah, 0dh,    '       },'
    fecha db 0ah, 0dh,          '       "Fecha": {'
    dia db 0ah,0dh,             '           "dia":  ,'
    mes db 0ah,0dh,             '           "mes":  ,'
    anio db 0ah,0dh,            '           "año":   '
    CierreFecha db 0ah, 0dh,    '       },'
    Hora db 0ah, 0dh,           '       "Hora": {'
    hr db 0ah,0dh,              '           "Hora":     ,'
    min db 0ah,0dh,             '           "Minuto":   ,'
    segu db 0ah,0dh,            '           "Segundo":   '
    CierreHora db 0ah, 0dh,     '       },'
    Estadistica db 0ah, 0dh,    '       "Estadísticos": {'
    media db 0ah,0dh,           '           "Media":     ,'
    mediana db 0ah,0dh,         '           "Mediana":   ,'
    moda db 0ah,0dh,            '           "Moda":      ,'
    impares db 0ah,0dh,         '           "Impares":   ,'
    Pares db 0ah,0dh,           '           "Pares":     ,'
    Primos db 0ah,0dh,          '           "Primos":     '
    CierreEst db 0ah, 0dh,      '        },'
    Ope db 0ah, 0dh,            '        "Operaciones": ['
    Operacionesrepo db 0ah,0dh, '            {   ',
                    0ah,        '              "Oper1":',
                    0ah,        '            },'               
    Eje db 0ah,0dh,             '            {   ',
                    0ah,        '              "Ejemplo":',
                    0ah,        '            },'                
    calc db 0ah,0dh,            '            {   ',
                    0ah,        '              "Calculos":',
                    0ah,        '             }' 
    CierreOpe db 0ah, 0dh,      '         ]'
	bufferhora db 8 dup(':') 
    EntradaFecha db 12 dup('-')
    handleFichero dw ? 
    nameFile db 'file.json',00h	
	msgrepo db 0ah, 0dh,'Reporte creado con Exito', '$'
	;VARIABLES CALCULADORA
	Num1 db 10,13, '>','$'
Num2 db 10,13, '>','$'
signo db 10,13, '>','$'
Result db 10,13, 'Resultado: ',10,13,'$'
signo2 db 10,13, ' ','$'
Lec db 200 dup('$')
datos1 label byte
maxlon1 db 10
actlon1 db ?
numero1 db 10 dup(' ')
datos2 label byte 
maxlon2 db 10
actlon2 db ?
numero2 db 10 dup(' ')
datosigno label byte 
maxlon3 db 3
actlon3 db ?
varsigno db 3 dup(' ')
resultado db 10 dup(' '), '$'
msgsuma db 13, 10,"soy suma ",10,13, "$"
msgresta db 13, 10,"soy resta ",10,13, "$"
multiplicacion db 0
division db 0
;VARIABLES PARA REPORTE

    numeroEscribir dw 0


    bufferFecha db 2 dup(' ')
    handleFicheroReporte dw ?

    msgErrorAbrir db 0ah, 0dh,'Error al Abrir el archivo', '$'
    msgErrorLeer db 0ah, 0dh,'Error al leer el archivo', '$'
    msgErrorCrear db 0ah, 0dh,'Error al crear el archivo', '$'
    msgErrorEscribir db 0ah, 0dh, 'Error al escribir archivo', '$'

    bufferOperaciones db 200 dup('$')

    msgNoIguales db 0ah, 0dh, ' La cadena no es igual ','$'
    msgIguales db 0ah, 0dh, ' La cadena es igual ','$'

;VARIABLES PARA REPORTE
    CommandShowMedia db 0ah, 0dh, 'Resultado estadistico media:  ', '$'
    CommandShowMediana db 0ah, 0dh, 'Comando Show Mediana', '$'
    CommandShowModa db 0ah, 0dh, 'Comando Show Moda', '$'
    CommandShowMayor db 0ah, 0dh, 'Resultado estadistico mayor:  ', '$'
    CommandShowMenor db 0ah, 0dh, 'Resultado estadistico menor:  ', '$'
    CommandID db 0ah, 0dh, 'Buscar ID ', '$'
    errorConsole db 0ah, 0dh, ' No se reconoce el comando ', '$'
    probando db 0ah, 0dh, 'Probando que entro aqui','$'
    msgnombrePadre db 0ah, 0dh, 'Nombre del Objeto Padre: ', '$'
    msgTotalOperaciones db 0ah, 0dh, 'Total de Operaciones: ', '$'
    ;------LECTURA DEL ARCHIVO .JSON ------------------------------------------
    msgErrorOpen db 0ah, 0dh,'Error al Abrir el archivo', '$'
    msgErrorRead db 0ah, 0dh,'Error al leer el archivo', '$'
    msgErrorCreate db 0ah, 0dh,'Error al crear el archivo', '$'
    msgErrorWrite db 0ah, 0dh, 'Error al escribir archivo', '$'
    msgArchivoLeido db 0ah, 0ah, 0dh, '> Archivo Leido con exito! ', '$'
    msgFinOperacion db 0ah, 0dh, 'FIN DE OPERACION ', '$'
    msgCargarArchivo db 0ah, 0dh, '>>INGRESE RUTA: ','$'
    rutaArchivo db 100 dup(?)
    bufferLectura db 10000 dup('$')
    limpiarD db 21 dup('$')
    bufferEscritura db 20 dup(' ')
    dividirpor db 0
suma1 db 0ah, 0dh, 'SUMA', '$'
    resta1 db 0ah, 0dh, 'RESTA', '$'
    multiplicacion1 db 0ah, 0dh, 'MULTIPLICACION', '$'
    division1 db 0ah, 0dh, 'DIVISION', '$'
    llaveAbre db 10,13, '{',10,13,'$'
    llaveCierra db 10,13, '}',10,13,'$'
    pruebaPaso db 10,13, 'wtf',10,13,'$'
;==============OPERACIONES==============================================
    resultados db 30 dup(0)
    totalOperaciones dw 0
    operaciones dw 20 dup('$')
    total dw 0
    imprimirNumero db 30 dup('$')
    nombrePadre db 20 dup('$'), '$' ; AQUI LO TENGO COMO LO GUARDO DESDE EL ARCHIVO 
    extension db '.json', '$'
    nombreReporte db 20 dup('$'),'$'  ; NOMBRE DEL REPORTE CON LA EXTENSION 
    nombreOperacion db 12 dup('$')
    finnnn db '$'
    namePadre db 30 dup('$'), '$'
    contadorbufferPadre db 0
    auxMayor dw 0
    auxMenor dw 0

    ;============Variables para Lectura de JSON (ANALIZADOR) ================
 
    estado db 0
    contadorPadre db 0
    contadorNumero db 0
    inicioArchivo db 0
    contadorLlaves db 0
    bufferAux db 30 dup('$')
    finOpe db 0
    msgRegresarPila db 0ah, 0dh, 'Regresando registros a la Pila', '$'
    msgRevisarPila db 0ah, 0dh, 'Revisando pila ', '$'
    msgIDoperacion db 0ah, 0dh, 'Este es el ID de una nueva operacion: ','$' 
    msgResultado db 0ah, 0dh, 'Resultado ', '$'
    msgnumeroNegativo db 0ah, 0dh, 'Es un numero negativo', '$'
    negativo db 0
    auxiliar dw 0

	saltoLinea db 0ah, 0dh,  '$'
    finObjeto db 0
    comandoConsola db 30 dup('$')
    comandoConsola2 db 30 dup('$') 
    showMedia db 'media', '$' 
    showMediana db 'mediana','$'
    showModa db 'moda','$'
    showMenor db 'menor','$'
    showMayor db 'mayor','$'
    showMayor2 db 'mayor','$'
    media1 dw 0
    mediana1 dw 0
    moda1 dw 0
    menor dw 0
    mayor dw 0 

    bufferMediaR dw 10 dup('$')
    bufferMedianaR dw 10 dup('$')
    bufferModaR dw 10 dup('$')
    bufferMenorR dw 10 dup('$')
    bufferMayorR dw 10 dup('$')
    bufferTemp db 200 dup('$')
	inicioConsole db 0ah, 0dh, ' >>', ' $'
    espacio db 20h, '$'
	comilla db 0ah, '        "'
    cierreComillas db  '":'
    cierreComillas2 db '":', '$'
    inicioArreglo db 0ah,  '        ['
    finArreglo db 0ah,     '        ]'
    coma db ','
    coma2 db ',','$'
    inicioOR db 0ah, 09h, 09h, 09h,'{',
                0ah, 09h, 09h, 09h, 09h, '"', '$'
    finOR db    0ah, 09h, 09h, 09h ,'}', '$'
.code
entrada_num1 proc near
    mov ah, 0ah
    lea dx, datos1
    int 21h
    ret
entrada_num1 endp

entrada_num2 proc near
    mov ah, 0ah
    lea dx, datos2
    int 21h
    ret
entrada_num2 endp

entrada_signo proc near
    mov ah, 0ah
    lea dx, varsigno
    int 21h
    ret
entrada_signo endp

main proc
	mov ax,@data
	mov ds,ax
	imprimirDatos:
		PrintText datosn
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
			Calculadora
			jmp start
		case2:
			cmp bl,"2"
			jne case3
			;Archivo
            PrintText modcarchi
			opcion1
			calcularMedia operaciones
			PrintText CommandShowMedia
			PrintText bufferMediaR
			RepoJSON IniRepo,FinRepo,TitRepo,FinTit,Datos,CierreDatos, nameFile,fecha, CierreFecha,Hora,CierreHora,Estadistica,CierreEst,Ope, CierreOpe, handleFichero
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