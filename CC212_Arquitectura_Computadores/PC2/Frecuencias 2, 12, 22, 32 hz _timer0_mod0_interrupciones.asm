;Hacer un programa para el TMC51 para seleccionar una frecuencia de 2hz, 12hz, 22hz y
;32h de tal manera que enviando un �01� por el puerto serie seleccione una frecuencia de
;2 hertz, enviando un �02� seleccione 12 hertz, enviando �03� seleccione 22 hertz y
;enviando �04� seleccione 32 hertz. La se�al saldr� por el pin P1.0 del Puerto 1.
;Usar el Timer 0 en modo 0.

;Para una frecuencia de 2hz, usamos:
;Periodo=0.5s, SemiPeriodo=0.25s
;kx8192x(12/11.0592x10^6)s=0.25s -->k=28

;Para una frecuencia de 12hz, usamos:
;Periodo=0.083s, SemiPeriodo=0.04s
;kx8192x(12/11.0592x10^6)s=0.04s-->k=4.5-->k=5

;Para una frecuencia de 22hz, usamos:
;Periodo=0.04545s, SemiPeriodo=0.0227s
;kx8192x(12/11.0592x10^6)s=0.0227s-->k=2.55-->k=3

;Para una frecuencia de 32hz, usamos:
;Periodo=0.03s, SemiPeriodo=0.0156s
;kx8192x(12/11.0592x10^6)s=0.0156s-->k=1.75-->k=2

;la interrupcion se genera de forma agutomatica sola
setintvec equ 145h
print equ 136h
getbyt equ 11Eh

	org 8000h
	mov TMOD,#20h
	mov A,#1
	mov dptr,#rutina_interrup_t0
	lcall setintvec
menu:
	lcall print
	db 0dh,0ah,"Menu de Frecuencias",0dh,0ah
	db "01)Frecuencia de 2hz",0dh,0ah
	db "02)Frecuencia de 12hz",0dh,0ah
	db "03)Frecuencia de 22hz",0dh,0ah
	db "04)Frecuencia de 32hz",0dh,0ah
	db "05)Salir",0dh,0ah
	db "Ingrese seleccion :",0ah,0
	lcall getbyt
	mov R6,A
	cjne A,#1,f12hz
f2hz:
	mov R7,#28	;La cantidad de overflows
	setb TR0
	setb ET0
	setb EA
	ajmp menu	;el menu se lanza de nuevo
f12hz:
	cjne A,#2,f22hz
	mov R7,#5	;de aca
	setb TR0
	setb ET0
	setb EA
	ajmp menu	;hasta aca esta generando 12 herz
f22hz:	
	cjne A,#3,f32hz
	mov R7,#3
	setb TR0
	setb ET0
	setb EA
	ajmp menu
f32hz:
	cjne A,#4,sale
	mov R7,#2
	setb TR0
	setb ET0
	setb EA
	ajmp menu
sale:
	clr EA
	clr TR0
	lcall print
	db 0dh, 0ah,"Hasta la proxima...",0dh,0ah,0
	ljmp 2F0h
	
rutina_interrup_t0:
	mov A,R6
	cjne A,#1,otro
frec2hz:
	dec R7
	cjne R7,#0,sale_interrupcion
	cpl P1.0
	mov R7,#28
	sjmp sale_interrupcion
otro:
	cjne A,#2,otro2
frec12hz:	;k=28
	dec R7 ;decremento k a 27 
	cjne R7,#0,sale_interrupcion ;cuando k=0 sale de la interrupcion
	cpl P1.0
	mov R7,#5
	sjmp sale_interrupcion
otro2:
	cjne A,#3,otro3
frec22hz:
	dec R7
	cjne R7,#0,sale_interrupcion
	cpl P1.0
	mov R7,#3
	sjmp sale_interrupcion
otro3:
	cjne A,#4,sale_interrupcion
frecc32hz:
	dec R7
	cjne R7,#0,sale_interrupcion
	cpl P1.0
	mov R7,#2
	sjmp sale_interrupcion
sale_interrupcion:
	reti
	end