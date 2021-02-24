     del_all:
		mov ecx,PANTALLA	 ; Contador hasta el final de la pantalla
		mov edi,0xa0000 	; Posiciona edi al principio de la pantalla
		.ciclo:
		mov [edi],byte 0	; Color negro
		inc edi 			; Se mueve al proximo pixel de la pantalla
		loop .ciclo			; Salta a ciclo
		mov edi,0xa0000 	; Posiciona edi al principio de la pantalla
	ret



	finish_game:
		call	del_all
		call	print_game_over
		call	show_text_next
		call	check_record
	    call    show_statistics
		; push  dword 1                 ; Operación. 0: lectura, 1: escritura
		; push  dword rec_one          ; Dirección en memoria para escribir o leer los datos
		; push  dword 0                 ; dirección LBA48 (bytes 6,3)
		; push  dword 0                 ; dirección LBA48 (bytes 5,2)
		; push  dword 2                 ; dirección LBA48 (bytes 4,1)
		; push  dword 1                 ; Cantidad de sectores
		; call  accessHDD

		ret


	print_game_over:
		; Pintar en el medio de la pantalla el Texto
		mov edi,0xa0000+(TAM_X*8)			; Nos colocamos en el extremo con una altura de 8
		sub	edi,(TAM_X/2)+8*4

		mov	ebx,8*'P'
		call print_char
		mov	ebx,8*'E'
		call print_char
		mov	ebx,8*'R'
		call print_char
		mov	ebx,8*'D'
		call print_char
		mov	ebx,8*'I'
		call print_char
		mov	ebx,8*'S'
		call print_char
		mov	ebx,8*'T'
		call print_char
		mov	ebx,8*'E'
		call print_char


		ret
		
		
	check_record:
		pusha
		mov eax, [three]
		cmp eax, [rec_three]
		ja	.change_three
		jb	.exit
		mov eax, [two]
		cmp eax, [rec_two]
		ja	.change_two
		jb	.exit
		mov eax, [one]
		cmp eax, [rec_one]
		ja	.change_one
		jmp .exit
		
		.change_three:
		mov [rec_three], eax
		
		.change_two:
		mov eax, [two]
		mov [rec_two], eax
		
		.change_one:
		mov eax, [one]
		mov [rec_one], eax
		
		.exit:
		popa
		ret	


	show_statistics:
		pusha
		; Pintar en el medio de la pantalla el Texto
		mov edi,0xa0000+(TAM_X*75)			
		sub	edi,(TAM_X/2)+14*4

		mov	ebx,8*'T'
		call print_char
		mov	ebx,8*'u'
		call print_char
		mov	ebx,8*' '
		call print_char
		mov	ebx,8*'t'
		call print_char
		mov	ebx,8*'i'
		call print_char
		mov	ebx,8*'e'
		call print_char
		mov	ebx,8*'m'
		call print_char
		mov	ebx,8*'p'
		call print_char 
		mov	ebx,8*'o'
		call print_char
		mov	ebx,8*':'
		call print_char 
		mov	ebx,8*' '
		call print_char 
		mov	esi, three
		call print_num	
		mov	esi, two
		call print_num	
		mov	esi, one
		call print_num	
		
		mov edi,0xa0000+(TAM_X*90)
		sub	edi,(TAM_X/2)+14*4

		mov	ebx,8*' '
		call print_char
		mov	ebx,8*' '
		call print_char
		mov	ebx,8*' '
		call print_char
		mov	ebx,8*'R'
		call print_char
		mov	ebx,8*'E'
		call print_char
		mov	ebx,8*'C'
		call print_char
		mov	ebx,8*'O'
		call print_char
		mov	ebx,8*'R'
		call print_char 
		mov	ebx,8*'D'
		call print_char
		mov	ebx,8*':'
		call print_char 
		mov	ebx,8*' '
		call print_char 
		mov	esi, rec_three
		call print_num	
		mov	esi, rec_two
		call print_num	
		mov	esi, rec_one
		call print_num		
		
		popa
		ret



		
	
	print_you:
		mov edi,0xa0000 	; Preparar Pincel en 0x0
		add edi,[pos_you]
		mov	ecx,[you_tam]
		.col:
		push ecx
		mov	ecx,[you_tam]
		.fil:			; Hago un desplazamiento a las izquierda de un bit y se va completando con cero, ese bit que se mueve para al acarreo
		mov	[edi],byte BLUE
		inc	edi
		loop .fil		; Repito FILa hasta que pasen los 8 PIXEL
		add	edi,TAM_X		; Sumo a la posicion para ubicarme en la siguiente fila pero le resto 8 para ubicarme debajo del primer PIXEL que dibuje.
		sub edi,[you_tam]
		inc	esi			; Incremento ESI para leer el siguiente valor de la variable FiguraX que representa los otros 8 PIXEL de la Fila que voy a visualizar
		pop	ecx			; Saco de la Pila en valor de contrador de Lazo
		loop .col		; Salta a Sig_Fila hasta que se representen las 8 filas
	ret	
	
	

	
	erase_you:
		mov edi,0xa0000 	; Preparar Pincel en 0x0
		add edi,[pos_you]
		mov	ecx,[you_tam]
		.col:
		push ecx
		mov	ecx,[you_tam]
		.fil:			; Hago un desplazamiento a las izquierda de un bit y se va completando con cero, ese bit que se mueve para al acarreo
		mov	[edi],byte 0
		inc	edi
		loop .fil		; Repito FILa hasta que pasen los 8 PIXEL
		add	edi,TAM_X		; Sumo a la posicion para ubicarme en la siguiente fila pero le resto 8 para ubicarme debajo del primer PIXEL que dibuje.
		sub edi,[you_tam]
		inc	esi			; Incremento ESI para leer el siguiente valor de la variable FiguraX que representa los otros 8 PIXEL de la Fila que voy a visualizar
		pop	ecx			; Saco de la Pila en valor de contrador de Lazo
		loop .col		; Salta a Sig_Fila hasta que se representen las 8 filas
	ret
	
	print_enviroment:
		mov edi,0xa0000 			; Preparar Pincel en 0x0
		; Pintar raya Izquirda
		mov	ecx,TAM_Y				; Al Registro Contador le colocamos 200 para que tome 200 filas
		add	edi,100 				; Posicionamos el Pincel, en la posicion 100 de la pantalla
		call print_enviroment_area
		; Pintar raya Derecha
		mov	ecx,TAM_Y				; Al Registro Contador le colocamos 200 para que tome 200 filas
		mov	edi,0xa0000
		add	edi,216 			   ; Posicionamos el Indice que Pintara, en la posicion 216
		call print_enviroment_area
		
		; Pintar Texto Segundos         
		call timer_text
		; Pintar Texto Record           
		call timer_record_text
		
	ret
	
	print_enviroment_area:
		.col:
		push ecx
		mov	ecx,2
		.fil:				; Hago un desplazamiento a las izquierda de un bit y se va completando con cero, ese bit que se mueve para al acarreo
		mov	[edi],byte WHITE
		inc	edi
		loop .fil			; Repito FILa hasta que pasen los 8 PIXEL
		add	edi,TAM_X-2			; Sumo a la posicion para ubicarme en la siguiente fila pero le resto 8 para ubicarme debajo del primer PIXEL que dibuje.
		inc	esi				; Incremento ESI para leer el siguiente valor de la variable FiguraX que representa los otros 8 PIXEL de la Fila que voy a visualizar
		pop	ecx				; Saco de la Pila en valor de contrador de Lazo
		loop .col			; Salta a Sig_Fila hasta que se representen las 8 filas
	ret

	timer_text:
		mov edi,0xa0000
		; Agregar Temporizador  
		
		add	edi,28			; Espaciado
		; Agregar palabra 'segundos' detras del numero
		mov	ebx,8*'s'
		call print_char
		mov	ebx,8*'e'
		call print_char
		mov	ebx,8*'g'
		call print_char
		mov	ebx,8*'u'
		call print_char
		mov	ebx,8*'n'
		call print_char
		mov	ebx,8*'d'
		call print_char
		mov	ebx,8*'o'
		call print_char
		mov	ebx,8*'s'
		call print_char
	ret
	
	show_dig:
		mov edi,0xa0000
		; Distribuir numeros
		cmp [one],10
		jb .more
		mov [one],0		; Reponer valor del 1er Num
		inc [two]
		cmp [two],10
		jb .more
		mov [two],0		; Reponer valor del 2do Num
		inc [three]
		cmp [three],10
		jb .more
		mov [three],0	; Reponer valor del 3er Num
		.more:
		; Pintar 3er Num
		mov esi,three
		call print_num
		; Pintar 2do Num
		mov esi,two
		call print_num
		; Pintar 1er Num
		mov esi,one
		call print_num
	ret

	timer_record_text:
		mov edi,0xa0000
		add	edi,220+4	; Posicionarme cerca del area derecha
		; Pintar Texto
		mov	ebx,8*'R'
		call print_char
		mov	ebx,8*'e'
		call print_char
		mov	ebx,8*'c'
		call print_char
		mov	ebx,8*'o'
		call print_char
		mov	ebx,8*'r'
		call print_char
		mov	ebx,8*'d'
		call print_char
		mov	ebx,8*':'
		call print_char
		
		; Pintar Segundos guardados en el Disco Duro
		mov	esi, rec_three
		call print_num
		mov	esi, rec_two
		call print_num
		mov	esi, rec_one
		call print_num
		
		; Agregando el 's' de segundos
		mov	ebx,8*' '
		call print_char
		mov	ebx,8*'s'
		call print_char
	ret
	
	print_num:
		; Posicionarme en el '0'
		mov	ebx,8*48
		mov cx, 8		; Un ciclo para *8 bit
		.ciclo3:
		add ebx,[esi]	; El numero que se va a mostrar
		loop .ciclo3
		call print_char
	ret
	
	print_char:
		xor	eax,eax
		mov	ax,es
		shl	eax,4
		add	eax,ebp
		mov	esi,eax
		mov	ecx,8
		.next_row:
		push ecx
		mov	ecx,8
		mov	al,[esi+ebx]
		.same_row:
		mov	[edi],byte 0		; Fondo Negro
		shl	al,1
		jnc	.not_a_dot
		mov	[edi],byte WHITE	; Color Blanco
		.not_a_dot:
		inc	edi
		loop .same_row
		add	edi,TAM_X-8
		inc	ebx
		pop	ecx
		loop .next_row
		sub	edi,TAM_X*8-8
	ret
	
	reset_timer:
		mov [one],0
		mov [two],0
		mov [three],0
	ret 
	
	
	
; Rutina para obtener n´umeros aleatorios
; estos quedan almacenados en eax.
random: push	edx
		push	ecx
		mov	ecx,[rlimite]		;Limite superior
		repetir_random:
		mov	eax,ecx 		    ;l´imite
		xor	edx, edx		    ;para modificar el patron del random
		imul	edx,[fs:046ch],08088405H    ;08088405h una constante, algunas cifras se pueden cambiar, otras no
		inc	edx
		mov	[fs:046ch],edx
		mul	edx
		mov	eax, edx
		add	eax,[rbase]			  ;Limite inferior
		cmp	eax,ecx
		ja	repetir_random
		pop	ecx
		pop	edx
		ret

		
accessHDD:	push	ebp
		;push    ebx
		mov	ebp,esp 		; Utilizar ebp como puntero para los parÃ¡metros

		mov	dx,1f7h 		; Leer el registro de control
	    @@: in	al,dx			
		and	al,0e0h 		
		or	al,40h						
		jz	@b			; Y esperar que el controlador del disco esté listo

		mov	dx,1f6h 		
		mov	al,40h			; Activar el primer disco duro maestro          
		out	dx,al			

		mov	ecx,[ebp+8]
		mov	al,ch
		mov	dx,1f2h
		out	dx,al			; Enviar la parte alta de la cantidad de sectores

		mov	ebx,[ebp+12]
		mov	al,bh	
		mov	dx,1f3h
		out	dx,al			; Enviar el byte 4 de la dirección LBA

		mov	ebx,[ebp+16]
		mov	al,bh
		mov	dx,1f4h
		out	dx,al			; Enviar el byte 5 de la dirección LBA

		mov	ebx,[ebp+20]
		mov	al,bh
		mov	dx,1f5h
		out	dx,al			; Enviar el byte 6 de la dirección LBA

		mov	ecx,[ebp+8]
		mov	al,cl
		mov	dx,1f2h
		out	dx,al			; Enviar la parte baja de la cantidad de sectores               

		mov	ebx,[ebp+12]
		mov	al,bl	
		mov	dx,1f3h
		out	dx,al			; Enviar el byte 1 de la dirección LBA

		mov	ebx,[ebp+16]
		mov	al,bl
		mov	dx,1f4h
		out	dx,al			; Enviar el byte 2 de la dirección LBA

		mov	ebx,[ebp+20]
		mov	al,bl
		mov	dx,1f5h
		out	dx,al			; Enviar el byte 3 de la dirección LBA

		mov	eax,[ebp+28]
		cmp	al,0
		jne	.write
		mov	al,24h
		mov	dx,1f7h
		out	dx,al			; Enviar el comando de lectura. Para escritura se usa 34h

	    @@: in	al,dx
		test	al,8			
		jz	@b			; Esperar a que el controlador indique que están listos los datos

		mov	ax,ds
		mov	es,ax			

		mov	edi,[ebp+24]
		shl	ecx,7			
		mov	dx,1f0h
		repz	insd			; Escribir en RAM los datos que proporciona el controlador
		jmp	.exit

	.write: mov	al,34h
		mov	dx,1f7h
		out	dx,al			; Enviar el comando de lectura. Para escritura se usa 34h

	    @@: in	al,dx
		test	al,8			
		jz	@b			; Esperar a que el controlador indique que están listos los datos

		mov	ax,ds
		mov	es,ax			

		mov	esi,[ebp+24]
		shl	ecx,7			
		mov	dx,1f0h
		repz	outsd			; Escribir en RAM los datos que proporciona el controlador

	 .exit: ;pop     ebx
		pop	ebp
		ret


		