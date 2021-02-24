align 4
	gdt:
		dq 0000000000000000h		; descriptor nulo 
		dq 00cf9a000000ffffh		; código con máximos privilegios
		dq 00cf92000000ffffh		; datos con máximos privilegios
	.end:

	gdtr: 
		dw (gdt.end-gdt)
		dd gdt

	irq0: 
		dw timer and 0ffffh			; int 32 (IRQ0)
		dw 8
		dw 8e00h
		dw timer shr 16
		
	irq1: 
		dw keyboard and 0ffffh			; int 33 (IRQ1)
		dw 8
		dw 8e00h
		dw keyboard shr 16
		
	 ; irq8: 
		; dw rtc and 0ffffh                      ; int 40 (IRQ8)
		; dw 8
		; dw 8e00h
		; dw rtc shr 16
		
	 ; irq12: 
		; dw mouse and 0ffffh                   ; int 44 (IRQ12)
		; dw 8
		; dw 8e00h
		; dw mouse shr 16

	irq14: 
		dw hdd and 0ffffh                     ; int 46 (IRQ14)
		dw 8
		dw 8e00h
		dw hdd shr 16
		
	idtr: 
		dw 256*8
		dd 0