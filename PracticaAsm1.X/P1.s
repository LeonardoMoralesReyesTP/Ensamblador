; PIC16F887 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC = INTRC_NOCLKOUT ; Oscillator Selection bits (INTOSCIO oscillator: I/O function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
  CONFIG  WDTE = ON             ; Watchdog Timer Enable bit (WDT enabled)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON            ; RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN = OFF           ; Brown Out Reset Selection bits (BOR disabled)
  CONFIG  IESO = OFF            ; Internal External Switchover bit (Internal/External Switchover mode is disabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  BOR4V = BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

// config statements should precede project file includes.
#include <xc.inc>


PSECT   MainCode,local,class=CODE,delta=2 ; PIC10/12/16
  ;MainCode 
; psect   barfunc,local,class=CODE,reloc=2 ; PIC18

  MAIN: ;Marca el punto del programa inicial
  ;Configuracion de puertos de entrada y salida
 
  BANKSEL TRISB  ;Seleccionar el banco del puerto "B" 
  BCF TRISB,0 ;Se coloca como salida el pin """"3"""
  BANKSEL PORTB ;Envia la configuración del registro 
  
  BANKSEL TRISA  ;Seleccionar el banco del puerto "A" 
  BCF TRISA,1 ;Se coloca como salida el pin 
  BANKSEL PORTA ;Envia la configuración del registro 
  
  BANKSEL TRISC  ;Seleccionar el banco del puerto "C" 
  BSF TRISC,0 ;Se coloca como entrada el pin 0 del puerto C
  BANKSEL PORTC ;Envia la configuración del regitro
  
  BANKSEL TRISC  ;Seleccionar el banco del puerto "C" 
  BSF TRISC,1 ;Se coloca como entrada el pin 0 del puerto C
  BANKSEL PORTC ;Envia la configuración del registro
  
  

  
  MainLoop: ;Inicio de ciclo iterativo principal
;Apagar y encender LED 1
      BCF                  PORTB,0  ;Colocar a 0 el pin 0 del puesto B (apagar led)
 BSF                  PORTB,0  ;Colocar a 1 el pin 0 del puerto B (encender led)


   
   
BTFSS                 PORTA, 1   ;verifica si el bit 1 del registro PORTA esta en 1, de ser asi salta la 
 ;instruccion GOTO, de lo contrario continua con la siguiente instruccion
 GOTO                  REVISARBTN1 
 
BTFSS              PORTA, 1	;Nuevamente verifica si el bit 1 del registro PORTA esta en 1, de ser asi
 ;salta la isntruccion GOTO, de lo contrario continua con la siguiente instruccion
GOTO                  REVISARBTN2 
		
GOTO                 MainLoop	;Desvia el flujo del programa 
     
     
REVISARBTN1:
 BTFSC PORTC,0 ;revisar el pin 0 del puerto C
 BSF   PORTA,1  ;Si el pin es 0 logico saltar la instruccion BSF
 

 REVISARBTN2:
     ;Revisar si el boton 2 esta presionado		
 BTFSC PORTC,1 ;revisar el pin 0 del puerto C
 BCF   PORTA,1  ;Si el pin es 1 logico saltar la instruccion BSF
                ;Si el pin es 0 logico entrar la instruccion BSF
		
		
		

    movlw 3000   ;mueve el valor de una literal al registro de trabajo
    movwf 0x10 ;Mueve del registro de trabajo a la direccion del argumento
    movwf 0x11 ;Mover del registro del rabajo a la direccion del argumento
    

DELAY_LOOP:  
    decfsz 0x10, F  ;decrementa el registro F y checa si no es 0
    goto DELAY_LOOP ;Regresa el ciclo de espera hasta que este encuetre la condición
    decfsz 0x11, F  ; 
    goto DELAY_LOOP
   
    
      
END MAIN  ;Finaliza la ejecución ddel programa