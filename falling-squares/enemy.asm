; Generar Varios Enemigos
generat_enemy:
	; Generar N enemigos para completar el juego
	call comprove_active_enemy
	call activate_enemy
	call velocity
ret

print_enemy:
	pusha
	xor ecx, ecx
	xor eax, eax
	xor ebx, ebx
	
	mov edi,0xa0000 	; Preparar Pincel en 0x0
	add edi, [current_enemy]
	
	
	mov	ecx,[enemy_tam]
	.col:
	push ecx
	mov	ecx,[enemy_tam]
	.fil:					; Hago un desplazamiento a las izquierda de un bit y se va completando con cero, ese bit que se mueve para al acarreo
	cmp [edi],byte BLUE
	jne @f
	mov [looser],1
	@@:
	mov	[edi],byte RED
	inc	edi
	loop .fil		; Repito FILa hasta que pasen los 8 PIXEL
	sub edi,[enemy_tam]
	add	edi,TAM_X		; Sumo a la posicion para ubicarme en la siguiente fila pero le resto 8 para ubicarme debajo del primer PIXEL que dibuje.
	pop	ecx			; Saco de la Pila en valor de contrador de Lazo
	loop .col		; Salta a Sig_Fila hasta que se representen las 8 filas
	popa
	ret
	
erase_enemy:
	pusha
	xor ecx, ecx
	xor eax, eax
	xor ebx, ebx
	
	mov edi,0xa0000 	; Preparar Pincel en 0x0
	add edi, [current_enemy]
	sub edi, [old_pos_enemy]
	
	mov	ecx,[vel_enemy]
	.col:
	push ecx
	mov	ecx,[enemy_tam]
	.fil:					; Hago un desplazamiento a las izquierda de un bit y se va completando con cero, ese bit que se mueve para al acarreo
	mov	[edi],byte 0
	inc	edi
	loop .fil		; Repito FILa hasta que pasen los 8 PIXEL
	sub edi,[enemy_tam]
	add	edi,TAM_X		; Sumo a la posicion para ubicarme en la siguiente fila pero le resto 8 para ubicarme debajo del primer PIXEL que dibuje.
	pop	ecx			; Saco de la Pila en valor de contrador de Lazo
	loop .col		; Salta a Sig_Fila hasta que se representen las 8 filas
	popa
	ret

	
	
velocity:
	push eax
	mov eax, [count_10second]
	cmp eax, 10*SEGUNDO
	jne @f
	mov eax, [vel_enemy]
	cmp eax, 8
	je .continue
	inc [vel_enemy]
	.continue:
	mov eax, [density]
	cmp eax, 5
	je	@f
	sub eax, 10
	mov [density], eax
	mov [count_10second], 0
	jmp .exit
	@@:	
	inc [count_10second]
	.exit:
	pop eax
	ret


down_enemy:	
	pusha
	xor ecx, ecx
	xor eax, eax
	xor ebx, ebx
	
	mov ecx, [vel_enemy]			;Preparo el registro EAX
	.mult:
	add eax, TAM_X
	loop .mult
	mov [old_pos_enemy], eax
	add [current_enemy], eax		;Me muevo a la siguiente fila
	mov ebx, [current_enemy]		;Preparo el registro EBX
	cmp ebx, PANTALLA				;Compruevo si se ha salido de la pantalla
	jna @f
	call erase_enemy
	xor ebx, ebx					;Si se salio de la pantalla     
	mov [current_enemy], ebx		;Reinicio este enemigo
	@@:
	popa
ret


activate_enemy:
	pusha
    mov ebx, [count_3second]		;Preparo el registro EAX con el conrtador de interrupciones del TIMER
	cmp ebx, [density]				;Compruebo si ya han pasado 3 segundos
	jne .continue					
	mov esi, pos_enemys_dinamic		;Preparo el registro ESI con la pocicion del arreglo de los enemigos
	add esi, [next_enemy]			;Me desplazo hacia el enemigo siguiente a activar
	call random
	mov [esi], eax					;Activo el enemigo con la posicion cargada en EBX
	mov [count_3second], 0			;Reinicio el contador de interrupciones
	mov edx, 4						;Me muevo a la direccion del siguiente enemigo
	add [next_enemy], edx			
	mov eax, [next_enemy]			;Compruebo si es una direccion valida dentro del arreglo
	cmp eax, 40
	jne .continue
	xor eax, eax					;Si no lo es me muevo a la primera direccion del arreglo
	mov [next_enemy], eax
	jmp @f							;Salto para comenzar a contar interrupciones en la siguiente
	.continue:
	inc [count_3second]
    @@: 
	popa
	ret

comprove_active_enemy:
	pusha
	xor ecx, ecx
	xor eax, eax
	xor ebx, ebx
	
	
	mov ecx, 10							;Preparo el registro ECX para 10 iteraciones
	;Ciclo
	@@:	
	mov esi, pos_enemys_dinamic			;Preparo el registro ESI con la direccion del arreglo de los enemigos 
	add esi, ebx						;Le sumo el desplazamiento al registro ESI                              
	xor eax, eax						;Borro el registro EAX
	cmp [esi], eax						;Verifico si el enemigo esta activo (si es mayor que 0)
	jna .continue
	mov eax, [esi]						;Si esta activo muevo su direccion al enemigo actual a procesar
	mov [current_enemy], eax	
	call erase_enemy	
	call print_enemy					;Pinto el enemigo en pantalla
	call down_enemy 					;Desplazo el enemigo hacia abajo
	mov eax, [current_enemy]			;Actualizo el arreglo con la pocicion modificada del enemigo    
	mov [esi], eax					
	.continue:
	add ebx, 4							;Me muevo hacia la direccion en la que comienza el siguiente enemigo
	loop @b 
	popa
    ret

