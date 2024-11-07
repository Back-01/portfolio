;este programa es una calculadora de bases en ensamblador
clean macro             ;macro para limpiar pantalla
	mov ax,0600h
	mov bh,07h
	mov cx,0000h
	mov dx,314fh
	int 10h
endm

modo macro              ;macro para darle formato de resolucion al programa 
	mov ah,00h ;modo grÃ¡fico
	mov al,12h ;640x480 color
	mov bh,00h ;pagina 0
	mov bl,00h ;fondo negro de la pantalla
	int 10h
endm

.model small
.data
;MENU
    nu db 10,13,   '         Universidad Tecnologica de mexico ',0
    cu db 10,13,   '                     campus sur ',0
    barr db 10,13, '____________________________________________________ ',0
    mat db 10,13,  '   Arquitectura y programacion de computadoras ',0
    tit db 10,13,  '            Conversion entre bases ',0
    me db 10,13,   '                        MENU ',0
    op1 db 10,13,  '               1) Decimal a binario ',0
    op2 db 10,13,  '               2) Decimal a octal ',0
    op3 db 10,13,  '               3) Decimal a hexadec ',0
    op4 db 10,13,  '               4) binario a decimal ',0  
    op5 db 10,13,  '               5) octal a decimal ',0
    op6 db 10,13,  '               6) hexadecimal a decimal ',0
    slop Db 10,13, '              seleccione una opcion ',0
    seleccion db 0
    otra db 10,13,'                 otro calculo? S/N ',0
;leedec                                       variables para leer los numeros en su respectiva base
    U_1	EQU	1
	NUMERO DB 0
	UNIDADES DB 0
	DECENAS	DB 0
	CENTENAS DB 0
	MILES DB 0
	RESULTADO DW 0
	MSG_LD DB 10,13,"          INGRESA UN NUMERO: ",0
	MSG_Re DB 10,13,"          NUMERO INGRESADO: ",0	
;leebin
    OCHO DB 0
    CUATRO DB 0
    DOS DB 0
    UNO DB 0
;leeoct
    OCHO_CUBO DB 0
    OCHO_CUADRADO DB 0
    OCHO_o DB 0
    UNO_o DB 0
;leehex
    HEX_CUBO DB 0
    HEX_CUADRADO DB 0
    HEX DB 0
    UNO_h DB 0
.code

    mov ax,@data
    mov ds,ax

;menu
    sel:
    call menu
    MOV BL, 1h 
    call cambia_color
    lea dx,slop
    call imprime_cadena_color
    call lee_caracter  
    cmp seleccion,31h
    je opcion_1           
    cmp seleccion,32h
    je opcion_2
    cmp seleccion,33h
    je opcion_3
    cmp seleccion,34h
    je opcion_4
    cmp seleccion,35h
    je opcion_5
    cmp seleccion,36h
    je opcion_6
    cmp seleccion,37h
    je fin
;Conversiones
    ;decimal a binario
    opcion_1:
    clean
    modo
    call fondo
    mov seleccion,0
    mov RESULTADO,0
    MOV BL, 1h 
    call cambia_color
    lea dx,op1
    call imprime_cadena_color
    call leedec
    MOV	DX,RESULTADO
	CALL write_binario
    MOV BL, 1h 
    call cambia_color 
    lea dx,otra
    call imprime_cadena_color
    call lee_caracter
    cmp seleccion,53h
    je sel
    ;decimal a octal
    opcion_2:
    clean
    modo
    call fondo
    mov seleccion,0
    mov RESULTADO,0
    MOV BL, 1h 
    call cambia_color
    lea dx,op2
    call imprime_cadena_color
    call leedec
    MOV	DX,RESULTADO
	CALL write_octal
    MOV BL, 1h 
    call cambia_color
    lea dx,otra
    call imprime_cadena_color
    call lee_caracter
    cmp seleccion,53h
    je sel
    cmp seleccion,53h
    je fin
    ;decimal a hexadecimal
    opcion_3:
    clean
    modo
    call fondo
    mov seleccion,0
    mov RESULTADO,0
    MOV BL, 1h 
    call cambia_color
    lea dx,op3
    call imprime_cadena_color
    call leedec
    MOV	DX,RESULTADO
	CALL write_hexadecimal
    MOV BL, 1h 
    call cambia_color 
    lea dx,otra
    call imprime_cadena_color
    call lee_caracter
    cmp seleccion,53h
    je sel
    ;binario a decimal
    opcion_4:
    clean
    modo
    call fondo
    mov seleccion,0
    mov RESULTADO,0
    MOV BL, 1h 
    call cambia_color
    lea dx,op4
    call imprime_cadena_color
    call leeBin
    MOV	DX,RESULTADO
	CALL write_decimal
    MOV BL, 1h 
    call cambia_color
    lea dx,otra
    call imprime_cadena_color
    call lee_caracter
    cmp seleccion,53h
    je sel
    ;octal a decimal
    opcion_5:
    clean
    modo
    call fondo
    mov seleccion,0
    mov RESULTADO,0
    MOV BL, 1h 
    call cambia_color
    lea dx,op5
    call imprime_cadena_color
    call leeoct
    MOV	DX,RESULTADO
	CALL write_decimal
    MOV BL, 1h 
    call cambia_color
    lea dx,otra
    call imprime_cadena_color
    call lee_caracter
    cmp seleccion,53h
    je sel
    ;hexadecimal a decimal
    opcion_6:
    clean
    modo
    call fondo
    mov seleccion,0
    mov RESULTADO,0
    MOV BL, 1h 
    call cambia_color
    lea dx,op6
    call imprime_cadena_color
    call leehex
    MOV	DX,RESULTADO
	CALL write_decimal
    MOV BL, 1h 
    call cambia_color
    lea dx,otra
    call imprime_cadena_color
    call lee_caracter
    cmp seleccion,53h
    je sel
fin:
    .exit
;procedimientos

imprime_cadena proc
    mov ah,9
    int 21h
    ret
imprime_cadena ENDP

lee_caracter proc
    push ax
    mov ah, 1
    int 21h
    mov seleccion,al
    pop ax
    ret
lee_caracter endp

leedec PROC
    push ax
    push bx
    push cx
    push dx
; IMPRIME MENSAJE
    MOV BL, 1h 
    call cambia_color
	LEA DX,MSG_LD
	CALL imprime_cadena_color

;LEE NUMERO MILES (UN DIGITO)
	MOV AH,01H
	INT 21H
	SUB AL,30H
	MOV MILES,AL

; LEE NUMERO CENTENAS (UN DIGITO)
	MOV AH,01H
	INT 21H
	SUB AL,30H
	MOV CENTENAS,AL

;LEE NUMERO DECENAS (UN DIGITO)
	MOV AH,01H
	INT 21H
	SUB AL,30H
	MOV DECENAS,AL

;LEE NUMERO UNIDADES (UN DIGITO)
	MOV AH,01H
	INT 21H
	SUB AL,30H
	MOV UNIDADES,AL

	XOR AX,AX

	MOV AL,MILES
	MOV BX,1000
	MUL BX         ; AL = AL * BL
	
	ADD	RESULTADO,AX

	MOV AL,CENTENAS
	MOV BL,100
	MUL BL         ; AL = AL * BL

	ADD RESULTADO,AX

	MOV AL,DECENAS
	MOV BL,10
	MUL BL         ; AL = AL * BL
	
	ADD RESULTADO,AX

	MOV AL,UNIDADES
	MOV BL,U_1
	MUL BL         ; AL = AL * BL
	
	ADD RESULTADO,AX
;IMPRIME MENSAJE     lo imprime en hexadecimal
    MOV BL, 1h 
    call cambia_color
	LEA DX,MSG_RE
	CALL imprime_cadena_color
    pop dx
    pop cx
    pop bx
    pop ax
    ret
leedec endp

leebin PROC
    push ax
    push bx
    push cx
    push dx
; IMPRIME MENSAJE
    MOV BL, 1h 
    call cambia_color
    LEA DX,MSG_LD
    CALL imprime_cadena_color

;LEE NUMERO 2^3 (UN DIGITO)
    MOV AH,01H
    INT 21H
    SUB AL,30H
    MOV OCHO,AL

; LEE NUMERO 2^2 (UN DIGITO)
    MOV AH,01H
    INT 21H
    SUB AL,30H
    MOV CUATRO,AL

;LEE NUMERO 2^1 (UN DIGITO)
    MOV AH,01H
    INT 21H
    SUB AL,30H
    MOV DOS,AL

;LEE NUMERO 2^0 (UN DIGITO)
    MOV AH,01H
    INT 21H
    SUB AL,30H
    MOV UNO,AL

    XOR AX,AX

    MOV AL,OCHO
    MOV BL,8
    MUL BL         ; AL = AL * BL
    
    ADD	RESULTADO,AX

    MOV AL,CUATRO
    MOV BL,4
    MUL BL         ; AL = AL * BL

    ADD RESULTADO,AX

    MOV AL,DOS
    MOV BL,2
    MUL BL         ; AL = AL * BL
    
    ADD RESULTADO,AX

    MOV AL,UNO
    MOV BL,1
    MUL BL         ; AL = AL * BL
    
    ADD RESULTADO,AX
;IMPRIME MENSAJE     lo imprime en hexadecimal
    MOV BL, 1h 
    call cambia_color
    LEA DX,MSG_RE
    CALL imprime_cadena_color
    pop dx
    pop cx
    pop bx
    pop ax
    ret
leebin endp

leeoct PROC
    push ax
    push bx
    push cx
    push dx
; IMPRIME MENSAJE
    MOV BL, 1h 
    call cambia_color
    LEA DX,MSG_LD
    CALL imprime_cadena_color

;LEE NUMERO 8^3 (UN DIGITO)
    MOV AH,01H
    INT 21H
    SUB AL,30H
    MOV OCHO_CUBO,AL

; LEE NUMERO 8^2 (UN DIGITO)
    MOV AH,01H
    INT 21H
    SUB AL,30H
    MOV OCHO_CUADRADO,AL

;LEE NUMERO 8^1 (UN DIGITO)
    MOV AH,01H
    INT 21H
    SUB AL,30H
    MOV OCHO_o,AL

;LEE NUMERO 8^0 (UN DIGITO)
    MOV AH,01H
    INT 21H
    SUB AL,30H
    MOV UNO_o,AL

    XOR AX,AX

    MOV AL,OCHO_CUBO
    MOV BX,512
    MUL BX         ; AL = AL * BX
    
    ADD	RESULTADO,AX

    MOV AL,OCHO_CUADRADO
    MOV BX,64
    MUL BX         ; AL = AL * BX

    ADD RESULTADO,AX

    MOV AL,OCHO_o
    MOV BX,8
    MUL BX         ; AL = AL * BX
    
    ADD RESULTADO,AX

    MOV AL,UNO_o
    MOV BX,1
    MUL BX         ; AL = AL * BX
    
    ADD RESULTADO,AX
;IMPRIME MENSAJE     lo imprime en hexadecimal
    MOV BL, 1h 
    call cambia_color
    LEA DX,MSG_RE
    CALL imprime_cadena_color
    pop dx
    pop cx
    pop bx
    pop ax
    ret
leeoct endp

leehex PROC
    push ax
    push bx
    push cx
    push dx
; IMPRIME MENSAJE
    MOV BL, 1h 
    call cambia_color
    LEA DX,MSG_LD
    CALL imprime_cadena_color

;LEE NUMERO 16^3 (UN DIGITO)
    MOV AH,01H
    INT 21H
    CALL HEX_TO_DEC
    MOV HEX_CUBO,AL

; LEE NUMERO 16^2 (UN DIGITO)
    MOV AH,01H
    INT 21H
    CALL HEX_TO_DEC
    MOV HEX_CUADRADO,AL

;LEE NUMERO 16^1 (UN DIGITO)
    MOV AH,01H
    INT 21H
    CALL HEX_TO_DEC
    MOV HEX,AL

;LEE NUMERO 16^0 (UN DIGITO)
    MOV AH,01H
    INT 21H
    CALL HEX_TO_DEC
    MOV UNO_h,AL

    XOR AX,AX

    MOV AL,HEX_CUBO
    MOV BX,4096
    MUL BX         ; AL = AL * BX
    
    ADD	RESULTADO,AX

    MOV AL,HEX_CUADRADO
    MOV BX,256
    MUL BX         ; AL = AL * BX

    ADD RESULTADO,AX

    MOV AL,HEX
    MOV BX,16
    MUL BX         ; AL = AL * BX
    
    ADD RESULTADO,AX

    MOV AL,UNO_h
    MOV BX,1
    MUL BX         ; AL = AL * BX
    
    ADD RESULTADO,AX
;IMPRIME MENSAJE     lo imprime en hexadecimal
    MOV BL, 1h 
    call cambia_color
    LEA DX,MSG_RE
    CALL imprime_cadena_color
    pop dx
    pop cx
    pop bx
    pop ax
    ret
leehex endp

write_binario proc
    mov si,2
    call decimal  
    ret
write_binario endp

write_decimal proc
    mov si,10
    call decimal
    ret
write_decimal endp

write_octal proc
    mov si,8
    call decimal
    ret
write_octal endp

write_hexadecimal proc
    mov si,16  
    call decimal
    ret
write_hexadecimal endp

decimal proc
    push ax
    push cx
    push dx
    push si
    mov ax,dx
    xor cx,cx
non_zero:
    xor dx,dx
    div si
    push dx
    inc cx
    or ax,ax
    jne non_zero
ciclo:
    pop dx
    call imprime_digito_hexadecimal
    loop ciclo
end_decimal:
    pop si
    pop dx
    pop cx
    pop ax
    ret
decimal endp

IMPRIME_HEXADECIMAL PROC
	PUSH	CX
	PUSH	DX
	MOV		DH,DL
	MOV		CX,4
	SHR 	DL,CL
	CALL 	IMPRIME_DIGITO_HEXADECIMAL
	MOV		DL,DH
	AND		DL,0FH
	CALL	IMPRIME_DIGITO_HEXADECIMAL
	POP		DX
	POP		CX
	RET
IMPRIME_HEXADECIMAL ENDP

IMPRIME_DIGITO_HEXADECIMAL		PROC
	PUSH	DX
	CMP		DL,10
	JAE		LETRA_HEXADECIMAL
	ADD		DL,"0"
	JMP		IMPRIME_DIGITO
LETRA_HEXADECIMAL:
	ADD		DL,"A"-10
IMPRIME_DIGITO:
	CALL	IMPRIME_CARACTER
	POP 	DX
	RET
IMPRIME_DIGITO_HEXADECIMAL ENDP

imprime_caracter proc
    push ax
    mov ah,02
    int 21h
    pop ax
    ret 
imprime_caracter endp

HEX_TO_DEC PROC
    CMP AL, '0'
    JB f
    CMP AL, '9'
    JBE dig
    CMP AL, 'A'
    JB f
    CMP AL, 'F'
    JA f

    ; Si es una letra (A-F), resta 'A' y suma 10
    SUB AL, 'A'
    ADD AL, 10
    JMP f

dig:
    ; Si es un dígito (0-9), resta '0'
    SUB AL, '0'

f:
    RET
HEX_TO_DEC ENDP

MENU PROC
    push ax
    push bx
    push dx
    clean
    modo
    call fondo
    MOV BL, 1h ; Establece el color del texto
    call cambia_color
    lea dx,nu
    call imprime_cadena_color
    MOV BL, 1h 
    call cambia_color
    lea dx,cu
    call imprime_cadena_color
    call sl
    MOV BL, 1h 
    call cambia_color
    lea dx,barr
    call imprime_cadena_color
    call sl
    MOV BL, 1h 
    call cambia_color
    lea dx,mat
    call imprime_cadena_color
    MOV BL, 1h 
    call cambia_color
    lea dx,tit
    call imprime_cadena_color
    MOV BL, 1h 
    call cambia_color
    lea dx,barr
    call imprime_cadena_color
    call sl
    MOV BL, 1h 
    call cambia_color
    lea dx,me
    call imprime_cadena_color
    call sl
    MOV BL, 1h 
    call cambia_color
    lea dx,op1
    call imprime_cadena_color
    MOV BL, 1h 
    call cambia_color
    lea dx,op2
    call imprime_cadena_color
    MOV BL, 1h 
    call cambia_color
    lea dx,op3
    call imprime_cadena_color
    MOV BL, 1h 
    call cambia_color
    lea dx,op4
    call imprime_cadena_color
    MOV BL, 1h 
    call cambia_color
    lea dx,op5
    call imprime_cadena_color
    MOV BL, 1h 
    call cambia_color
    lea dx,op6
    call imprime_cadena_color
    MOV BL, 1h 
    call cambia_color
    lea dx,barr
    call imprime_cadena_color
    call sl
    POP AX
    POP BX
    POP DX
    ret
MENU ENDP

sl proc
    push dx
    mov dl,13
    call imprime_caracter
    mov dl,10
    call imprime_caracter
    pop dx
    ret
sl endp

fondo proc
    push ax
    push bx
    MOV AH, 0Bh ; Establece el servicio
    MOV BH, 0   ; Establece el modo de paleta
    MOV BL,4    ; Establece el color de fondo
    INT 10h      ; Llama a la interrupción
    pop bx
    pop ax
    ret
fondo endp

imprime_cadena_color PROC
    PUSH SI
    PUSH ax
    MOV SI, DX ; Obtiene la dirección de la cadena
next_char:
    MOV AH, 0Eh ; Establece el servicio
    MOV AL, [SI] ; Obtiene el carácter actual
    INT 10h      ; Llama a la interrupción

    INC SI ; Avanza al siguiente carácter
    CMP BYTE PTR [SI],0 ; Comprueba si hemos llegado al final de la cadena
    JNE next_char ; Si no, repite el proceso para el siguiente carácter
    POP AX
    POP SI
    RET
imprime_cadena_color ENDP

cambia_color PROC
    PUSH AX
    ; AH = 10h: Establece el modo de video
    ; AL = 0: Establece el modo de video
    ; BL = Color del texto
    MOV AH, 10h
    MOV AL, 0
    INT 10h
    POP AX
    RET
cambia_color ENDP

end