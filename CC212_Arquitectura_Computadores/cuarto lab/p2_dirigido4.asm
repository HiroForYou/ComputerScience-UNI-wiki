;Hacer un programa que muestre un contador decimal de 0 a 9 cada segundo en el LCD y
;lo env�e tambi�n al terminal.
binasc  equ 109h
sdelay  equ 142h
sndchr  equ 148h
	org 8000h
	lcall inicioLCD
; localiza el cursor sobre la fila 1, posici�n 0 e imprime el mensaje en el LCD
repite:
 	mov a, #1 	; fila 1
 	mov b, #0 	; posici�n 0
 	lcall placeCur4  ; esta rutina fija la posici�n del cursor. La posici�n del cursor
                         ; es localizado en el registro B. La posici�n del cursor empieza
                         ; en 0. El acumulador da el n�mero de l�nea.
                         ; input : el acumulador indica el n�mero de l�nea (1, 2)
                         ; : el registro B contiene la posici�n del cursor
                         ; output : nada
 	mov R7,#10
 	mov R3,#0
 	mov R0,#offCur    ;desaparece el cursor
 	lcall wrLCDcom4   ;escribe una palabra de datos al LCD
                          ;dichos datos deben ser localizados en R0  
 
lazo:
 	mov A,R3
 	lcall binasc
 	mov 30h,R2
 	mov A,R2
 	mov R0,A
 	lcall wrLCDdata4
 	mov R0,#shLfCur	  ;desplaza el cursor a la izquierda
 	lcall wrLCDcom4
 	mov A,30h
 	lcall sndchr
 	mov A,#0dh
 	lcall sndchr
 	lcall sdelay
 	inc R3
 	djnz R7,lazo
 	ljmp 2F0h
$INCLUDE(subrutinasLCD.inc)
	end