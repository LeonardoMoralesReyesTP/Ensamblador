; PIC16F887 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
CONFIG FOSC = INTRC_CLKOUT ; Oscillator Selection bits (RC oscillator: CLKOUT function on RA6/OSC2/CLKOUT pin, RC on RA7/OSC1/CLKIN)
CONFIG WDTE = OFF ; Watchdog Timer Enable bit (WDT enabled)
CONFIG PWRTE = OFF ; Power-up Timer Enable bit (PWRT disabled)
CONFIG MCLRE = ON ; RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
CONFIG CP = OFF ; Code Protection bit (Program memory code protection is disabled)
CONFIG CPD = OFF ; Data Code Protection bit (Data memory code protection is disabled)
CONFIG BOREN = OFF ; Brown Out Reset Selection bits (BOR enabled)
CONFIG IESO = OFF ; Internal External Switchover bit (Internal/External Switchover mode is enabled)
CONFIG FCMEN = OFF ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is enabled)
CONFIG LVP = OFF ; Low Voltage Programming Enable bit (RB3/PGM pin has PGM function, low voltage programming enabled)

; CONFIG2
CONFIG BOR4V = BOR40V ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
CONFIG WRT = OFF ; Flash Program Memory Self Write Enable bits (Write protection off)

; Config statements should precede project file includes.
#include <xc.inc>

PSECT   MainCode, global, class = CODE, delta = 2

; Definición de constantes
COUNT_MAX EQU 5 ; Valor máximo del contador

; Definición de registros
count EQU 0x20 ; Registro para almacenar el valor del contador (5 bits)
temp EQU 0x21 ; Registro temporal

; Inicialización del programa
ORG 0x00
GOTO Main

Main:
    BANKSEL PORTC
    CLRF PORTC ; Limpiar PORTC
    BCF TRISC, 0 ; Configurar RC0 como entrada (Botón 1)
    BCF TRISC, 1 ; Configurar RC1 como entrada (Botón 2)
    
   BANKSEL PORTA
    CLRF PORTA ; Limpiar PORTA
    BANKSEL TRISA
    CLRF TRISA ; Configurar PORTA como salida
   ;BSF TRISA, 0 ; Configurar RA0 como salida (LED 1)
   ;BSF TRISA, 1 ; Configurar RA1 como salida (LED 2)
   ;BSF TRISA, 2 ; Configurar RA2 como salida (LED 3)
   ;BSF TRISA, 3 ; Configurar RA3 como salida (LED 4)
   ;BSF TRISA, 4 ; Configurar RA4 como salida (LED 5)

MainLoop:
    BANKSEL PORTC
    BTFSC PORTC, 0 ; Verificar si el botón 1 está presionado
    GOTO Boton1Presionado ; Si está presionado, saltar a Boton1Presionado

    BANKSEL PORTC
    BTFSC PORTC, 1 ; Verificar si el botón 2 está presionado
    GOTO Boton2Presionado ; Si está presionado, saltar a Boton2Presionado

    GOTO BotonNoPresionado ; Si no se presionaron botones, saltar a BotonNoPresionado

Boton1Presionado:
    CALL Incrementar ; Llamar a la rutina de incremento
    GOTO ActualizarLeds ; Saltar a ActualizarLeds

Boton2Presionado:
    CALL Decrementar ; Llamar a la rutina de decremento
    GOTO ActualizarLeds ; Saltar a ActualizarLeds

BotonNoPresionado:
    ; No se presionaron botones, continuar sin hacer nada
    GOTO ActualizarLeds ; Saltar a ActualizarLeds

    GOTO Delay
ActualizarLeds:
    ; Actualizar los LEDs
    BANKSEL count
    MOVF count, W ; Mover el valor del contador a W
    BANKSEL PORTA
    MOVWF PORTA ; Mostrar el valor del contador en los LEDs

    ; Retardo
    MOVLW 100 ; Valor de retardo (ajustar según sea necesario)
    ;call Delay ; Retardo de 100 ciclos

    GOTO MainLoop

; Rutina para incrementar el contador
Incrementar:
    BANKSEL count
    INCF count, F ; Incrementar el contador
    CALL VerificarLeds ; Verificar los LEDs
    RETURN

; Rutina para decrementar el contador
Decrementar:
    BANKSEL count
    DECF count, F ; Decrementar el contador
    CALL VerificarLeds ; Verificar los LEDs
    RETURN

; Rutina para verificar y controlar los LEDs
VerificarLeds:
    BANKSEL count
    MOVF count, W ; Mover el valor del contador a W

    ; Verificar si el contador es mayor a 5
    BANKSEL COUNT_MAX
    SUBWF count, W ; Restar el valor del contador a COUNT_MAX
    BTFSC STATUS, 0 ; Saltar si el resultado es cero (C = 0, el contador es mayor a COUNT_MAX)
    GOTO CercadelCinco ; Si es mayor, saltar al código para encender todos los LEDs

    ; Verificar si el contador es menor a 1
    BTFSS STATUS, 2 ; Saltar si el resultado es cero (Z = 1, el contador es menor a 1)
    GOTO MasCercaDelCero ; Si no es cero, saltar al código para apagar todos los LEDs
    ; Si no se cumplen las condiciones anteriores, el contador está entre 1 y 5
    BANKSEL PORTA
    MOVWF PORTA ; Mostrar el valor del contador en los LEDs
    RETURN

CercadelCinco:
    BANKSEL PORTA
    MOVLW (1 << COUNT_MAX) - 1 ; Cargar máscara para encender todos los LEDs
    MOVWF PORTA ; Mostrar la máscara en los LEDs
    RETURN

MasCercaDelCero:
    BANKSEL PORTA
    CLRF PORTA ; Apagar todos los LEDs
    RETURN
    
    ; Rutina de retardo
Delay:
   MOVLW 0xFF ; Valor inicial para el contador
   MOVWF temp ; Guardar el valor inicial en un registro temporal

DelayLoop:
   DECFSZ temp, F ; Decrementar el contador y verificar si es cero
   GOTO DelayLoop ; Si no es cero, repetir el bucle


