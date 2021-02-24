
init_choose:
	; Comprobar los pasos del Choose
	call del_all
	mov byte [pausa], 1
	cmp [start],1
	je @f
	call you_choose
	jmp .exit
	@@:
	call enemy_choose
	.exit:
	call show_text_title
	call show_text_next
ret

know_choose:
	; Conocer cual esta seleccionado
	cmp [one],1
	je .one
	cmp [two],1
	je .two
	cmp [three],1
	je .three
	jmp .exit
	
	; Enviar dato a esi del tamano
	.one:
	mov esi,BLOCK_4x4
	jmp .exit
	.two:
	mov esi,BLOCK_6x6
	jmp .exit
	.three:
	mov esi,BLOCK_8x8
	.exit:
ret

tam_enemy_choose:
	cmp esi,BLOCK_4x4
	je	.tam_4x4
	cmp esi,BLOCK_6x6
	je	.tam_6x6
	cmp esi,BLOCK_8x8
	je	.tam_8x8
	jmp @f
	; Asignar Tamano
	.tam_4x4:
	mov [enemy_tam],BLOCK_4x4
	mov [rlimite], 206
	jmp @f
	.tam_6x6:
	mov [enemy_tam],BLOCK_6x6
	mov [rlimite], 202
	jmp @f
	.tam_8x8:
	mov [enemy_tam],BLOCK_8x8
	mov [rlimite], 198
	@@:
ret

tam_you_choose:
	cmp esi,BLOCK_4x4
	je	.tam_4x4
	cmp esi,BLOCK_6x6
	je	.tam_6x6
	cmp esi,BLOCK_8x8
	je	.tam_8x8
	jmp .exit
	; Asignar Tamano
	.tam_4x4:
	mov [you_tam],BLOCK_4x4
	mov [pos_you],(TAM_X*TAM_Y)-160-(BLOCK_4x4*TAM_X)-(BLOCK_4x4/2)
	mov [pos_you_x],160-BLOCK_4x4/2
	mov [lim_inf],TAM_X*(TAM_Y-(2+BLOCK_4x4))
	
	jmp .exit
	.tam_6x6:
	mov [you_tam],BLOCK_6x6
	mov [pos_you],(TAM_X*TAM_Y)-160-(BLOCK_6x6*TAM_X)-(BLOCK_6x6/2)
	mov [pos_you_x],160-BLOCK_6x6/2
	mov [lim_inf],TAM_X*(TAM_Y-(2+BLOCK_6x6))
	
	jmp .exit
	.tam_8x8:
	mov [you_tam],BLOCK_8x8
	mov [pos_you],(TAM_X*TAM_Y)-160-(BLOCK_8x8*TAM_X)-(BLOCK_8x8/2)
	mov [pos_you_x],160-BLOCK_8x8/2
	mov [lim_inf],TAM_X*(TAM_Y-(2+BLOCK_8x8))
	
	.exit:
ret

you_choose:
	; Agregar Seleccionador del Jugador
	mov [start],0
	mov edi,0xa0000+(TAM_X*20)			; Nos colocamos en el extremo con una altura de 20 cerca del titulo
	sub	edi,(TAM_X/2)+7*4				; Restamos el medo y le agregamos el medio de las letras (7 letras * 4 que es el medio de 8)
	
	; Agregar palabra JUGADOR para identificar el Seleccionador
	mov	ebx,8*'J'
	call print_char
	mov	ebx,8*'U'
	call print_char
	mov	ebx,8*'G'
	call print_char
	mov	ebx,8*'A'
	call print_char
	mov	ebx,8*'D'
	call print_char
	mov	ebx,8*'O'
	call print_char
	mov	ebx,8*'R'
	call print_char
	
	call choose
ret

enemy_choose:
	; Agregar Seleccionador del Jugador
	mov [start],1
	mov edi,0xa0000+(TAM_X*20)			; Nos colocamos en el extremo con una altura de 20 cerca del titulo
	sub	edi,(TAM_X/2)+8*4				; Restamos el medo y le agregamos el medio de las letras (7 letras * 4 que es el medio de 8)
	
	; Agregar palabra JUGADOR para identificar el Seleccionador
	mov	ebx,8*'E'
	call print_char
	mov	ebx,8*'N'
	call print_char
	mov	ebx,8*'E'
	call print_char
	mov	ebx,8*'M'
	call print_char
	mov	ebx,8*'I'
	call print_char
	mov	ebx,8*'G'
	call print_char
	mov	ebx,8*'O'
	call print_char
	mov	ebx,8*'S'
	call print_char
	
	call choose
ret

choose:
	; Seleccionador
	mov edi,0xa0000+(TAM_X*50)			; Nos colocamos en el extremo con una altura de 20 cerca del titulo
	sub	edi,(TAM_X/2)+13*4				; Restamos el medo y le agregamos el medio de las letras (7 letras * 4 que es el medio de 8)
	
	mov	ebx,8*'['
	call print_char
	; Marca de Seleccionado
	cmp [one],0
	je	@f
	mov	ebx,8*'*'
	jmp .finish_one
	@@:
	mov	ebx,8*' '
	.finish_one:
	call print_char
	; fin de Marcado
	mov	ebx,8*']'
	call print_char
	
	mov	ebx,8*' '
	call print_char
	mov	ebx,8*'4'
	call print_char
	mov	ebx,8*'x'
	call print_char
	mov	ebx,8*'4'
	call print_char
	mov	ebx,8*' '
	call print_char
	mov	ebx,8*'P'
	call print_char
	mov	ebx,8*'i'
	call print_char
	mov	ebx,8*'x'
	call print_char
	mov	ebx,8*'e'
	call print_char
	mov	ebx,8*'l'
	call print_char
	
	add edi,(TAM_X*10)-13*8 	; Desplazarme 10 de altura abajo y quitar el desplazamiento del otro texto
	
	mov	ebx,8*'['
	call print_char
	; Marca de Seleccionado
	cmp [two],0
	je	@f
	mov	ebx,8*'*'
	jmp .finish_two
	@@:
	mov	ebx,8*' '
	.finish_two:
	call print_char
	; fin de Marcado
	mov	ebx,8*']'
	call print_char
	
	mov	ebx,8*' '
	call print_char
	mov	ebx,8*'6'
	call print_char
	mov	ebx,8*'x'
	call print_char
	mov	ebx,8*'6'
	call print_char
	mov	ebx,8*' '
	call print_char
	mov	ebx,8*'P'
	call print_char
	mov	ebx,8*'i'
	call print_char
	mov	ebx,8*'x'
	call print_char
	mov	ebx,8*'e'
	call print_char
	mov	ebx,8*'l'
	call print_char
	
	add edi,(TAM_X*10)-13*8 	; Desplazarme 10 de altura abajo y quitar el desplazamiento del otro texto
	
	mov	ebx,8*'['
	call print_char
	; Marca de Seleccionado
	cmp [three],0
	je	@f
	mov	ebx,8*'*'
	jmp .finish_three
	@@:
	mov	ebx,8*' '
	.finish_three:
	call print_char
	; fin de Marcado
	mov	ebx,8*']'
	call print_char
	
	mov	ebx,8*' '
	call print_char
	mov	ebx,8*'8'
	call print_char
	mov	ebx,8*'x'
	call print_char
	mov	ebx,8*'8'
	call print_char
	mov	ebx,8*' '
	call print_char
	mov	ebx,8*'P'
	call print_char
	mov	ebx,8*'i'
	call print_char
	mov	ebx,8*'x'
	call print_char
	mov	ebx,8*'e'
	call print_char
	mov	ebx,8*'l'
	call print_char
ret

show_text_title:
	; Pintar en el medio de la pantalla el Texto
	mov edi,0xa0000+(TAM_X*8)			; Nos colocamos en el extremo con una altura de 8
	sub	edi,(TAM_X/2)+32*4				; Restamos el medo y le agregamos el medio de las letras (32 letras * 4 que es el medio de 8)
	
	; Agregar palabra
	mov	ebx,8*'S'
	call print_char
	mov	ebx,8*'e'
	call print_char
	mov	ebx,8*'l'
	call print_char
	mov	ebx,8*'e'
	call print_char
	mov	ebx,8*'c'
	call print_char
	mov	ebx,8*'i'
	call print_char
	mov	ebx,8*'o'
	call print_char
	mov	ebx,8*'n'
	call print_char
	mov	ebx,8*'e'
	call print_char
	mov	ebx,8*' '
	call print_char
	mov	ebx,8*'e'
	call print_char
	mov	ebx,8*'l'
	call print_char
	mov	ebx,8*' '
	call print_char
	mov	ebx,8*'t'
	call print_char
	mov	ebx,8*'a'
	call print_char
	mov	ebx,8*'m'
	call print_char
	mov	ebx,8*'a'
	call print_char
	mov	ebx,8*165		; 165 codigo ASCII de la ñ
	call print_char
	mov	ebx,8*'o'
	call print_char
	mov	ebx,8*' '
	call print_char
	mov	ebx,8*'d'
	call print_char
	mov	ebx,8*'e'
	call print_char
	mov	ebx,8*'l'
	call print_char
	mov	ebx,8*' '
	call print_char
	mov	ebx,8*'C'
	call print_char
	mov	ebx,8*'u'
	call print_char
	mov	ebx,8*'a'
	call print_char
	mov	ebx,8*'d'
	call print_char
	mov	ebx,8*'r'
	call print_char
	mov	ebx,8*'a'
	call print_char
	mov	ebx,8*'d'
	call print_char
	mov	ebx,8*'o'
	call print_char
ret

show_text_next:
	; Pintar en el medio de la pantalla el Texto
	mov edi,0xa0000+(TAM_X*(TAM_Y-8))	; Nos colocamos en el extremo inferior y le restamos 8 para que no ocupe el tamano de las letras (8x8)
	sub	edi,(TAM_X/2)+26*4				; Restamos el medo y le agregamos el medio de las letras (26 letras * 4 que es el medio de 8)
	
	; Agregar palabra
	mov	ebx,8*'T'
	call print_char
	mov	ebx,8*'o'
	call print_char
	mov	ebx,8*'q'
	call print_char
	mov	ebx,8*'u'
	call print_char
	mov	ebx,8*'e'
	call print_char
	mov	ebx,8*' '
	call print_char
	mov	ebx,8*'S'
	call print_char
	mov	ebx,8*'P'
	call print_char
	mov	ebx,8*'A'
	call print_char
	mov	ebx,8*'C'
	call print_char
	mov	ebx,8*'E'
	call print_char
	mov	ebx,8*' '
	call print_char
	mov	ebx,8*'p'
	call print_char
	mov	ebx,8*'a'
	call print_char
	mov	ebx,8*'r'
	call print_char
	mov	ebx,8*'a'
	call print_char
	mov	ebx,8*' '
	call print_char
	mov	ebx,8*'C'
	call print_char
	mov	ebx,8*'o'
	call print_char
	mov	ebx,8*'n'
	call print_char
	mov	ebx,8*'t'
	call print_char
	mov	ebx,8*'i'
	call print_char
	mov	ebx,8*'n'
	call print_char
	mov	ebx,8*'u'
	call print_char
	mov	ebx,8*'a'
	call print_char
	mov	ebx,8*'r'
	call print_char
ret