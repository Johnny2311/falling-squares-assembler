; Excepto por la sección en la que se ubican los descriptores en la IDT
; este código es una plantilla ;-)

InitInterrupts: 
	mov	ecx,256*2			; "Colonizar" los primeros 2K de la RAM para
	xor	edi,edi 			; que sean la IDT
	xor	eax,eax 			; La IDT comenzará en la dirección 0
	@@: 
		mov	[edi],eax		; y tendrá 2K de tamaño: 256 entradas de 8byte
		add	edi,4
	loop @b					; Primero hacer que todas las entradas sean cero
	
	; Configurar los PIC maestro(20h) y esclavo (A0)
	; para mapear las irqs 0-15 con las interrupciones 32-47
	mov	al,0x11 			; Comando para cambio de irq base
	out	0x20,al 			; al PC maestro
	out	0xA0,al 			; y al esclavo

	mov	al,32				; irq0->int32 (implica que la irq7 es la int39)
	out	0x21,al 			; para el maestro
	mov	al,40				; irq8->int40 (implica que la irq15 es la int47)
	out	0xA1,al 			; para el esclavo

	mov	al,0x4
	out	0x21,al 			; ¿Quién es maestro?
	mov	al,0x2
	out	0xA1,al 			; ¿Y quién el esclavo?

	mov	al,1				; Mismo modo de trabajo
	out	0x21,al 			; para los dos(modo 8086)
	out	0xA1,al

	xor	al,al				; activar todas las interrupciones
	out	0x21,al 			; en el maestro
	out	0xA1,al 			; y el esclavo

	; Luego ocupar los valores adecuados en la IDT:
	; Este es el código que normalmente variará
	; según la cantidad de interrupciones que
	; deban utilizarse
	mov	eax,[irq0]			; Instalar la int 32 (irq0->timer)
	mov	[32*8],eax
	mov	eax,[irq0+4]
	mov	[32*8+4],eax

	mov	eax,[irq1]			; Instalar la int 33 (irq1->teclado)
	mov	[33*8],eax
	mov	eax,[irq1+4]
	mov	[33*8+4],eax

	; mov	eax,[irq14]			; Instalar la int 46 (irq14->hdd)
	; mov	[46*8],eax
	; mov	eax,[irq14+4]
	; mov	[46*8+4],eax

	lidt [idtr]				; actualizar el registro idtr
	sti						; activar las interrupciones
ret