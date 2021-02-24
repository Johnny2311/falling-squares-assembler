; Se implementan todas las rutinas de atención a interrupciones
; Acá es dónde se implementará la mayor parte de la lógica del código
; La programación será basada en eventos
; Noten que est fichero en particular es el que define aquello
; que hará que funcione toda la programación

	; Esta es la isr para la irq0
	timer:

		; Refrescar Pantalla
		;call del_all
		cmp byte [pausa], 1
		je	.exit
		
		cmp	[looser], byte 1
		jne	 .continue
		call	 finish_game
		mov [pausa], 1
		jmp	 .exit
		.continue:
		
		
		
		; Inicializar todo mis Variables
		cmp [first], 1
		je @f
		.start: 						; Etiqueta de Start para iniciar el juego cuando sea
		mov [first], 1
		mov [count_time_temp],0
		mov [count_time],0
		mov [start],0
		mov [looser],0
		call reset_timer
		mov [one],1						; Seleccionamos el Primero
		mov [current_enemy], 0
		mov [next_enemy], 4
		mov [count_3second], 0
		mov [pos_enemys_dinamic], 106
		mov [old_pos_enemy], 106
		mov [vel_enemy], 1
		mov [density], 55
		mov [count_10second], 0
		push ecx						;Guardando los valores de los registros en la pila
		push esi
		push eax
		xor eax, eax
		mov ecx, 9
		mov esi, pos_enemys_dinamic		;Inicializando los enemigos desde cero
		add esi, 4
		.ciclo_ini:
		mov [esi], eax
		add esi, 4
		loop .ciclo_ini
		pop eax
		pop esi
		pop ecx
		
		@@:
		; Comprobar si ya paso por el Choose
		cmp [start], 2
		jnb @f
		call init_choose
		jmp .exit
		
		@@:
		; Calcular Tiempo
		inc [count_time_temp]
		cmp [count_time_temp], 18
		jb	@f
		mov [count_time_temp], 0
		inc [count_time]
		inc [one]					; Aumentar contador de segundos del titulo
		call show_dig
		@@: 
		
		; Pintar Area y Textos
		call print_enviroment
		
		
		; Pintar a los enemigs
		call generat_enemy
		
		.exit: 
		mov	al,20h			; fin de interrupción hardware
		out	20h,al			; al pic maestro
	iret

	; Esta es la isr para la irq1
    keyboard: 
		in	al,60h

		cmp	[looser], byte 1
		jnz	.continue
		cmp	al, SPACE
		jnz	.exit
		mov	[looser], 0
		mov	[first], 0
		call del_all
		mov [pausa], 0
		jmp	.exit
		.continue:
		
		cmp [start],2		; Comprobar si ya esta en juego para no usar mas el SPACE
		je	.start
		cmp	al,SPACE
		jne .first
		
		; Seleccionar 
		cmp [start],0
		je .step_1
		cmp [start],1
		je .step_2
		
		.step_1:
		; Momento Guardar Datos jugador
		call know_choose	; Guardar en ESI el valor del tamanno
		call tam_you_choose	; Comprobamos resultado y redefinimos variables al jugador
		
		call reset_timer	; Borramos el selecionador anterior
		mov [one],1			; Seleccionamos el Primero
		call del_all		; Refrescar Pantalla
		jmp @f
		
		.step_2:
		; Momento Guardar Datos enemigos
		call know_choose	; Guardar en ESI el valor del tamao
		call tam_enemy_choose	; Comprobamos resultado y redefinimos variables al enemy
		call reset_timer	; Borramos el selecionador anterior
		call del_all
		; Pintar Area y Textos
		call print_enviroment
		;Pintar tiempo
		call show_dig
		;Pintar JUAGADOR
		call print_you

		; Fin del Momento
		
		@@:
		inc [start]
		mov [pausa], 0
		
		.first:
		; Comprobar si ya esta en juego para no usar mas el SPACE
		cmp [start],2
		je .start
		
		; Teclas Fuera del Juego
		
		cmp [one],0		; Si esta en el 1er puede bajar
		je	.finish_one
		; Comprobar teclas
		cmp al,DOWN
		jne .exit
		mov	[one],0
		mov	[two],1
		mov [pausa], 0
		jmp .exit
		.finish_one:
		
		cmp [two],0		; Si esta en el 2do puede bajar y subir
		je	.finish_two
		; Comprobar teclas Abajo
		cmp al,DOWN
		jne @f
		mov	[two],0
		mov	[three],1
		mov [pausa], 0
		jmp .exit
		; Comprobar teclas Arriba
		@@:
		cmp al,UP
		jne .finish_two
		mov	[two],0
		mov	[one],1
		mov [pausa], 0
		jmp .exit
		.finish_two:
		
		cmp [three],0		; Si esta en el 3er puede subir
		je	.exit
		; Comprobar teclas
		cmp al,UP
		jne .exit
		mov	[three],0
		mov	[two],1 	
		mov [pausa], 0
		jmp .exit
		; Teclas dentro del Juego
		
		.start:
		cmp al, SPACE		;Codigo para pausar el juego si se toca SPACE
		jne @f
		cmp [pausa], 1
		je .reanudar
		mov [pausa], 1
		jmp .exit
		.reanudar:
		mov [pausa], 0
		jmp .exit
		@@:
		cmp [pausa], 1
		je .exit
		
		call erase_you
		; Calculo Limite Superior
		cmp [pos_you],TAM_X*3
		jb	@f
		cmp al,UP
		jne @f
		sub	[pos_you],TAM_X*3
		
		@@:
		; Calculo Limite Inferior
		mov esi,[lim_inf]
		cmp [pos_you],esi
		ja	@f
		cmp al,DOWN
		jne @f
		add	[pos_you],TAM_X*3
		
		@@:
		; Calculo Limite Izquierdo
		cmp [pos_you_x],104
		jb	@f
		cmp al,LEFT
		jne @f
		sub	[pos_you],3
		sub	[pos_you_x],3
		
		@@:
		; Calculo Limite Derecho
		mov esi,214
		sub esi,[you_tam]
		
		cmp [pos_you_x],esi
		ja	.print
		cmp al,RIGHT
		jne .print
		add	[pos_you],3
		add	[pos_you_x],3
		

		.print:
		call print_you		
		.exit: 
		mov	al,20h			; fin de interrupción hardware
		out	20h,al			; al pic maestro
	iret

	; Esta es la isr para la irq14
    hdd: 
		; My Code

		.exit: 
		mov	al,20h			; fin de interrupción hardware
		out	0xA0,al 		; al pic maestro
		out 0x20,al			; al pic maestro
	iret
	
