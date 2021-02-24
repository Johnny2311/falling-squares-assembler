; Noten que incluye al todos los demás
; Este fichero es una especie de plantilla, solo contiene algunas
; inicializaciones tribiales como el modo de video y la lectura
; de disco que veremos más adelante
; La implementación de la lógica estara en el fichero isr.asm
; TODO lo demás es inicialización y configuración del modo protegido
; y las interrupciones

format binary as 'img'
org 7C00h
	include 'consts.asm'

	;Código para leer desde HDD:
	mov	ah,02h		; Read Sectors From Drive 
	mov	al,SECTOR	; Sectors To Read Count 
	mov	ch,00h			; Cylinder 
	mov	cl,02h		; a partir del segundo sector lógico (Sector)
	mov	dh,00h			; Head
	mov	dl,00h		; 1st hard disk ( "drive A:" )
	mov	bx,0800h	; y escribir el contenido en 0x800:0
	mov	es,bx			; Buffer Address Pointer
	mov	bx,00h
    @@: 
	int	13h
	jc	@b
	
	jmp	8000h	     ;poner en ejecución el código cargado en HDD
	times 510-($-$$) db 0
		 dw 0aa55h

org 8000h
	cli
	; Activar el modo video
	mov	ax,13h			; activar el modo de video VGA
	int	10h				; al establecer el modo de video se limpia la pantalla
	
	; Activar Direccion de Caracteres
	mov ah,11h			; llamando a la funcion 11h, subfuncion 30h que me devuelve una direccion donde estaran definido los patrones de caracteres
	mov al,30h			; lo q devuelve esta funcion es la direccion donde se encuentran estos patrones ES:BP (BP solo puede ser accedido desde le modo protegido)
	mov bh,3
	int 10h 			; acceso def. caracteres

	@@: 
	mov	ax,0x2401		; activar la línea A20
	int	0x15
	jc	@b

	lgdt [gdtr]				; Inicializar el registro de descriptores globales
	mov	eax,cr0
	or	al,1				; activar el modo protegido
	mov	cr0,eax
	jmp	8:protectedMode 	; activar los selectores del modo protegido
	
use32
	protectedMode: 
		mov	ax,10h			; inicializar los selectores de segmento
		mov	ds,ax
		mov	ss,ax


		call InitInterrupts		; configurar las interrupciones del sistema
		;push    dword 0                 ; Operación. 0: lectura, 1: escritura
		;push    dword record               ; Dirección en memoria para escribir o leer los datos
		;push    dword 0                 ; dirección LBA48 (bytes 6,3)
		;push    dword 0                 ; dirección LBA48 (bytes 5,2)
		;push    dword 2                 ; dirección LBA48 (bytes 4,1)
		;push    dword 1                 ; Cantidad de sectores
		;call    accessHDD


		jmp	$					; InitInterrupts está implementada en el fichero interrupts.asm

		; Incluir código en ficheros separados
		; Esto ayuda a organizar y segmentar el código
		; en aquellas partes que nos sean de interés
	include 'interrupts.asm'
	include 'isr.asm'
	include 'choose.asm'
	include 'enemy.asm'
	include 'vars.asm'
	include 'descriptors.asm'
	include 'subrutins.asm'
	record db 0

times (SECTOR*510)-($-$$) db 0
		 dw 0xaa55
