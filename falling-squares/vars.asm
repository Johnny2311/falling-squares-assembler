; Variables Bloques Tamano
you_tam 		dd 0	;BLOCK_4x4              ; Guarda la Config del Tamano del Jugador (Valor de las Constntes)
enemy_tam		dd 0	;BLOCK_4x4              ; Guarda la Config del Tamano del Enemigo (Valor de las Constntes)

; Variables Bloques Posiciones
pos_you 		dd 0		;(TAM_X*TAM_Y)-160-(BLOCK_4x4*TAM_X)-(BLOCK_4x4/2)
pos_you_x		dd 0		;160-BLOCK_4x4

; Variables Enemigos ( Cant max de enemios )
pos_enemys_dinamic	dd 106, 0, 0, 0, 0, 0, 0, 0, 0, 0
current_enemy	dd 0
next_enemy		dd 4
count_3second	dd 0
vel_enemy		dd 1
count_10second	dd 0
count			dd 0
density			dd 0
fall_enemy		dd 0
old_pos_enemy	dd 106


; Variables Banderas
first			db 0
start			db 0
looser			db 0
pausa			db 0


; Variables Contadoras & Selector
one			    dd 0
two			    dd 0
three			dd 0
rec_one 		dd 0
rec_two			dd 0
rec_three		dd 0
records			dd 0


; Variables Temporales
count_time_temp dd 0
count_time		dd 0
count_della 	dd 0

; Variables Utils
lim_inf 		dd 0		;TAM_X*(TAM_Y-(2+BLOCK_4x4))
cal_pos_enemy	dd 0		;TAM_X*(BLOCK_4x4-1)
tmp				dd 0
tmp2			dd 0
rbase			dd 102
rlimite			dd 197
