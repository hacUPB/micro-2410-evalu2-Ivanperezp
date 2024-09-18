# Actividad corrección código semáforo

mov r2, #0                 // Resetea el contador de tiempo a 0.
str r2, [r4, entrada_tiempo_M0] // Almacena el valor reseteado en entrada_tiempo_M0.
pop {lr}                   // Restaura el valor original del registro de enlace (lr) desde la pila.
bx lr                      // Retorna de la subrutina al llamador.

.thumb_func                // Indica que la siguiente función (estado_amarillo) está en modo Thumb.

estado_amarillo:
    ldr r4, =Base_maquina_0   // Carga la dirección base de la estructura de la máquina de estados en r4.
    ldr r0, [r4, #entrada_tiempo_M0] // Carga el tiempo transcurrido en el estado actual en r0.
    ldr r5, =TIEMPO_AMARILLO   // Carga el valor de TIEMPO_AMARILLO en r5, que representa el tiempo máximo para el estado amarillo.
    cmp r0, r5                 // Compara el tiempo transcurrido (r0) con el tiempo máximo permitido (r5).
    blt fin_estado             // Si el tiempo transcurrido es menor que el tiempo máximo, salta a fin_estado.

    // Configurar salida
    ldr r0, =GPIOB_PCOR        // Carga la dirección del registro de borrado de salida (PCOR) de GPIOB en r0.
    mov r1, #(1 << LED_AMARILLO) // Prepara el valor para apagar el LED amarillo en r1.
    str r1, [r0]               // Escribe el valor en PCOR para apagar el LED amarillo.

    ldr r0, =GPIOB_PCOR        // Carga la dirección del registro de borrado de salida (PCOR) de GPIOB en r0.
    mov r1, #(1 << LED_ROJO)   // Prepara el valor para apagar el LED rojo en r1.
    str r1, [r0]               // Escribe el valor en PCOR para apagar el LED rojo.
    mov r1, #(1 << LED_VERDE)  // Prepara el valor para apagar el LED verde en r1.
    str r1, [r0]               // Escribe el valor en PCOR para apagar el LED verde.

    // Cambiar al siguiente estado
    mov r1, #ROJO              // Carga el valor correspondiente al estado ROJO en r1.
    str r1, [r4, #var_estado_M0] // Almacena el nuevo estado en la variable var_estado_M0.
    mov r2, #0                 // Resetea el contador de tiempo a 0.
    str r2, [r4, entrada_tiempo_M0] // Almacena el valor reseteado en entrada_tiempo_M0.
    pop {lr}                   // Restaura el valor original del registro de enlace (lr) desde la pila.
    bx lr                      // Retorna de la subrutina al llamador.

fin_estado:                   // Etiqueta fin_estado para saltar en caso de que el tiempo no haya expirado.
    pop {lr}                   // Restaura el valor original del registro de enlace (lr) desde la pila.
    bx lr                      // Retorna de la subrutina al llamador.

 Assembly
#include "definitions.h"    // Incluye las definiciones necesarias, como registros y valores constantes.

.syntax unified             // Establece la sintaxis unificada de ARM para soportar tanto instrucciones ARM como Thumb.
.global estado_semaforo     // Define la etiqueta estado_semaforo como global, permitiendo que sea visible para el vinculador.

.text                       // Inicia la sección de código (instrucciones) en la memoria.

.align 2                    // Alinea la tabla de direcciones a 4 bytes (2^2 = 4), asegurando que las direcciones de las etiquetas estén alineadas correctamente.
// Lista de direcciones de los estados
dir_tabla_estados:
  .long estado_rojo           // Dirección de la subrutina estado_rojo.
  .long estado_rojo_amarillo  // Dirección de la subrutina estado_rojo_amarillo.
  .long estado_verde          // Dirección de la subrutina estado_verde.
  .long estado_amarillo       // Dirección de la subrutina estado_amarillo.

.thumb_func                   // Indica que la siguiente función (estado_semaforo) está en modo Thumb.

estado_semaforo:
    push {lr}                 // Guarda el registro de enlace (lr) en la pila para preservar el valor de retorno.
    ldr r4, =Base_maquina_0   // Carga la dirección base de la estructura de la máquina de estados en el registro r4.
    ldr r0, [r4, #var_estado_M0] // Carga el valor actual del estado de la máquina de estados en el registro r0.
    lsl r0, #2                // Desplaza a la izquierda el valor en r0 por 2 bits, multiplicándolo por 4 (tamaño de palabra).
    ldr r4, =dir_tabla_estados // Carga la dirección de la tabla de estados en el registro r4.
    ldr r1, [r4, r0]          // Carga la dirección de la subrutina correspondiente al estado actual en r1.
    bx r1                     // Salta a la dirección almacenada en r1 para ejecutar la subrutina del estado.

.thumb_func                   // Indica que la siguiente función (estado_rojo) está en modo Thumb.

estado_rojo:
    ldr r4, =Base_maquina_0   // Carga la dirección base de la estructura de la máquina de estados en r4.
    ldr r0, [r4, #entrada_tiempo_M0] // Carga el tiempo transcurrido en el estado actual en r0.
    ldr r5, =TIEMPO_ROJO       // Carga el valor de TIEMPO_ROJO en r5, que representa el tiempo máximo para el estado rojo.
    cmp r0, r5                 // Compara el tiempo transcurrido (r0) con el tiempo máximo permitido (r5).
    blt fin_estado             // Si el tiempo transcurrido es menor que el tiempo máximo, salta a fin_estado.

    // Salidas
    ldr r0, =GPIOB_PCOR        // Carga la dirección del registro de borrado de salida (PCOR) de GPIOB en r0.
    mov r1, #(1 << LED_ROJO)   // Prepara el valor para apagar el LED rojo en r1.
    orr r1, #(1 << LED_AMARILLO) // Combina el valor para apagar también el LED amarillo.
    str r1, [r0]               // Escribe el valor en PCOR para apagar el LED rojo y amarillo.
    mov r1, #0                 // Prepara un valor de 0 en r1.
    str r1, [r0]               // Escribe 0 en PCOR para asegurarse de que no haya más LEDs encendidos.

    ldr r0, =GPIOB_PSOR        // Carga la dirección del registro de establecimiento de salida (PSOR) de GPIOB en r0.
    mov r1, #(1 << LED_VERDE)  // Prepara el valor para encender el LED verde en r1.
    str r1, [r0]               // Escribe el valor en PSOR para encender el LED verde.
    mov r1, #0                 // Prepara un valor de 0 en r1.
    str r1, [r0]               // Escribe 0 en PSOR para asegurarse de que no haya más LEDs afectados.

    // Cambiar al siguiente estado
    mov r1, #ROJO_AMARILLO     // Carga el valor correspondiente al estado ROJO_AMARILLO en r1.
    str r1, [r4, #var_estado_M0] // Almacena el nuevo estado en la variable var_estado_M0.
    mov r2, #0                 // Resetea el contador de tiempo a 0.
    str r2, [r4, #entrada_tiempo_M0] // Almacena el valor reseteado en entrada_tiempo_M0.
    pop {lr}                   // Restaura el valor original del registro de enlace (lr) desde la pila.
    bx lr                      // Retorna de la subrutina al llamador.

.thumb_func                   // Indica que la siguiente función (estado_rojo_amarillo) está en modo Thumb.

estado_rojo_amarillo:
    ldr r4, =Base_maquina_0   // Carga la dirección base de la estructura de la máquina de estados en r4.
    ldr r0, [r4, #entrada_tiempo_M0] // Carga el tiempo transcurrido en el estado actual en r0.
    ldr r5, =TIEMPO_ROJO_AMARILLO // Carga el valor de TIEMPO_ROJO_AMARILLO en r5, que representa el tiempo máximo para el estado rojo-amarillo.
    cmp r0, r5                 // Compara el tiempo transcurrido (r0) con el tiempo máximo permitido (r5).
    blt fin_estado             // Si el tiempo transcurrido es menor que el tiempo máximo, salta a fin_estado.

    // Configura la salida
    ldr r0, =GPIOB_PCOR        // Carga la dirección del registro de borrado de salida (PCOR) de GPIOB en r0.
    mov r1, #(1 << LED_VERDE)  // Prepara el valor para apagar el LED verde en r1.
    str r1, [r0]               // Escribe el valor en PCOR para apagar el LED verde.
    mov r1, #0                 // Prepara un valor de 0 en r1.
    str r1, [r0]               // Escribe 0 en PCOR para asegurarse de que no haya más LEDs encendidos.

    ldr r0, =GPIOB_PSOR        // Carga la dirección del registro de establecimiento de salida (PSOR) de GPIOB en r0.
    mov r1, #(1 << LED_ROJO) | (1 << LED_AMARILLO) // Prepara el valor para encender los LEDs rojo y amarillo en r1.
    str r1, [r0]               // Escribe el valor en PSOR para encender los LEDs rojo y amarillo.
    mov r1, #0                 // Prepara un valor de 0 en r1.
    str r1, [r0]               // Escribe 0 en PSOR para asegurarse de que no haya más LEDs afectados.

    // Cambiar al siguiente estado
    mov r1, #VERDE             // Carga el valor correspondiente al estado VERDE en r1.
    str r1, [r4, #var_estado_M0] // Almacena el nuevo estado en la variable var_estado_M0.
    mov r2, #0                 // Resetea el contador de tiempo a 0.
    str r2, [r4, #entrada_tiempo_M0] // Almacena el valor reseteado en entrada_tiempo_M0.
    pop {lr}                   // Restaura el valor original del registro de enlace (lr) desde la pila.
    bx lr                      // Retorna de la subrutina al llamador.

.thumb_func                   // Indica que la siguiente función (estado_verde) está en modo Thumb.

estado_verde:
    ldr r4, =Base_maquina_0   // Carga la dirección base de la estructura de la máquina de estados en r4.
    ldr r0, [r4, #entrada_tiempo_M0] // Carga el tiempo transcurrido en el estado actual en r0.
    ldr r5, =TIEMPO_VERDE      // Carga el valor de TIEMPO_VERDE en r5, que representa el tiempo máximo para el estado verde.
    cmp r0, r5                 // Compara el tiempo transcurrido (r0) con el tiempo máximo permitido (r5).
    blt fin_estado             // Si el tiempo transcurrido es menor que el tiempo máximo, salta a fin_estado.

    // Configura salida
    ldr r0, =GPIOB_PCOR        // Carga la dirección del registro de borrado de salida (PCOR) de GPIOB en r0.
    mov r1, #(1 << LED_AMARILLO) // Prepara el valor para apagar el LED amarillo en r1.
    str r1, [r0]               // Escribe el valor en PCOR para apagar el LED amarillo.
    mov r1, #0                 // Prepara un valor de 0 en r1.
    str r1, [r0]               // Escribe 0 en PCOR para asegurarse de que no haya más LEDs encendidos.

    ldr r0, =GPIOB_PSOR        // Carga la dirección del registro de establecimiento de salida (PSOR) de GPIOB en r0.
    mov r1, #(1 << LED_VERDE) | (1 << LED_ROJO) // Prepara el valor para encender los LEDs verde y rojo en r1.
    str r1, [r0]               // Escribe el valor en PSOR para encender los LEDs verde y rojo.
    mov r1, #0                 // Prepara un valor de 0 en r1.
    str r1, [r0]               // Escribe 0 en PSOR para asegurarse de que no haya más LEDs afectados.

    // Cambiar al siguiente estado
    mov r1, #AMARILLO          // Carga el valor correspondiente al estado AMARILLO en r1.
    str r1, [r4, #var_estado_M0] // Almacena el nuevo estado en la variable var_estado_M0.
    mov r2, #0                 // Resetea el contador de tiempo a 0.
    str r2, [r4, #entrada_tiempo_M0] // Almacena el valor reseteado en entrada_tiempo_M0.
    pop {lr}                   // Restaura el valor original del registro de enlace (lr) desde la pila.
    bx lr                      // Retorna de la subrutina al llamador.

.thumb_func                   // Indica que la siguiente función (estado_amarillo) está en modo Thumb.

estado_amarillo:
    ldr r4, =Base_maquina_0   // Carga la dirección base de la estructura de la máquina de estados en r4.
    ldr r0, [r4, #entrada_tiempo_M0] // Carga el tiempo transcurrido en el estado actual en r0.
    ldr r5, =TIEMPO_AMARILLO   // Carga el valor de TIEMPO_AMARILLO en r5, que representa el tiempo máximo para el estado amarillo.
    cmp r0, r5                 // Compara el tiempo transcurrido (r0) con el tiempo máximo permitido (r5).
    blt fin_estado             // Si el tiempo transcurrido es menor que el tiempo máximo, salta a fin_estado.

    // Configurar salida
    ldr r0, =GPIOB_PCOR        // Carga la dirección del registro de borrado de salida (PCOR) de GPIOB en r0.
    mov r1, #(1 << LED_ROJO)   // Prepara el valor para apagar el LED rojo en r1.
    str r1, [r0]               // Escribe el valor en PCOR para apagar el LED rojo.
    mov r1, #0                 // Prepara un valor de 0 en r1.
    str r1, [r0]               // Escribe 0 en PCOR para asegurarse de que no haya más LEDs encendidos.

    ldr r0, =GPIOB_PSOR        // Carga la dirección del registro de establecimiento de salida (PSOR) de GPIOB en r0.
    mov r1, #(1 << LED_AMARILLO) | (1 << LED_VERDE) // Prepara el valor para encender los LEDs amarillo y verde en r1.
    str r1, [r0]               // Escribe el valor en PSOR para encender los LEDs amarillo y verde.
    mov r1, #0                 // Prepara un valor de 0 en r1.
    str r1, [r0]               // Escribe 0 en PSOR para asegurarse de que no haya más LEDs afectados.

    // Cambiar al siguiente estado
    mov r1, #ROJO              // Carga el valor correspondiente al estado ROJO en r1.
    str r1, [r4, #var_estado_M0] // Almacena el nuevo estado en la variable var_estado_M0.
    mov r2, #0                 // Resetea el contador de tiempo a 0.
    str r2, [r4, #entrada_tiempo_M0] // Almacena el valor reseteado en entrada_tiempo_M0.
    pop {lr}                   // Restaura el valor original del registro de enlace (lr) desde la pila.
    bx lr                      // Retorna de la subrutina al llamador.

fin_estado:                   // Etiqueta fin_estado para saltar en caso de que el tiempo no haya expirado.
    pop {lr}                   // Restaura el valor original del registro de enlace (lr) desde la pila.
    bx lr                      // Retorna de la subrutina al llamador.

 Assembly
.syntax unified                 // Establece la sintaxis unificada de ARM para soportar tanto instrucciones ARM como Thumb.
.global SysTick_Handler         // Define la etiqueta SysTick_Handler como global, permitiendo que sea visible para el vinculador.
.text                           // Inicia la sección de código (instrucciones) en la memoria.

.equ Base_maquina_0, 0x20001000 // Define la dirección base de la estructura de la máquina de estados en la RAM (0x20001000).
.equ entrada_tiempo_M0, 4       // Define un desplazamiento (offset) de 4 bytes desde la base para la variable entrada_tiempo_M0.

.thumb_func                     // Indica que la siguiente función (SysTick_Handler) está en modo Thumb.

SysTick_Handler:                // Inicio del manejador de la interrupción SysTick.
    push {r4}                   // Guarda el valor del registro r4 en la pila para preservar su valor durante la interrupción.
    ldr r4, =Base_maquina_0     // Carga la dirección base de la estructura de la máquina de estados en el registro r4.
    ldr r0, [r4, #entrada_tiempo_M0] // Lee el valor actual del tiempo transcurrido desde la dirección [Base_maquina_0 + entrada_tiempo_M0].
    add r0, r0, #1              // Incrementa el valor de r0 en 1, representando un incremento de 1 ms.
    str r0, [r4, #entrada_tiempo_M0] // Almacena el valor incrementado de nuevo en la variable entrada_tiempo_M0.
    pop {r4}                    // Restaura el valor original del registro r4 desde la pila.
    bx lr                       // Retorna de la interrupción, saltando a la dirección almacenada en el registro de enlace (lr).

 Assembly
.text

// Direcciones de los registros SysTick
.equ SYSTICK_BASE, 0xE000E010        // Base del SysTick: Punto de partida para acceder a los registros del temporizador SysTick.
.equ SYST_CSR, (SYSTICK_BASE + 0x0)  // SysTick Control and Status Register: Registro de control y estado para gestionar el temporizador SysTick.
.equ SYST_RVR, (SYSTICK_BASE + 0x4)  // SysTick Reload Value Register: Registro que define el valor de recarga del contador.
.equ SYST_CVR, (SYSTICK_BASE + 0x8)  // SysTick Current Value Register: Registro que contiene el valor actual del contador.

.equ SYSTICK_ENABLE, 0x1             // Bit para habilitar el SysTick: Activa el temporizador SysTick.
.equ SYSTICK_TICKINT, 0x2            // Bit para habilitar la interrupción del SysTick: Permite la generación de una interrupción cuando el contador llega a 0.
.equ SYSTICK_CLKSOURCE, 0x4          // Bit para seleccionar el reloj del procesador: Selecciona el reloj principal del procesador como fuente de reloj para SysTick.

.equ SYSTICK_RELOAD_1MS, 48000 - 1   // Valor para recargar el SysTick cada 1 ms: Establece el valor de recarga para generar una interrupción cada milisegundo, suponiendo una frecuencia de 48 MHz.

.equ Base_maquina_0, 0x20001000      // Dirección base compartida: Dirección base en la RAM para la estructura de la máquina de estados.
.equ var_estado_M0, 0                // Offset para la variable de estado: Desplazamiento en la estructura para acceder a la variable que almacena el estado actual.
.equ entrada_tiempo_M0, 4            // Offset para la entrada de tiempo transcurrido: Desplazamiento en la estructura para acceder a la variable que almacena el tiempo transcurrido.


// Direcciones de los registros GPIO (Ejemplo para Kinetis K64)
.equ GPIOB_PDDR, 0x400FF054          // Registro de dirección de datos del puerto B: Controla la dirección de los pines del puerto B (entrada/salida).
.equ GPIOB_PDOR, 0x400FF040          // Registro de salida de datos del puerto B: Contiene los valores que se enviarán a los pines del puerto B.
.equ GPIOB_PTOR, 0x400FF04C          // Registro de alternancia de datos del puerto B: Permite alternar el estado de los pines del puerto B.
.equ GPIOB_PSOR, 0x400FF044          // Registro de establecer bits de salida en puerto B: Permite establecer en alto (1) los pines específicos del puerto B.
.equ GPIOB_PCOR, 0x400FF048          // Registro de limpiar bits de salida en puerto B: Permite limpiar (poner en bajo) los pines específicos del puerto B.


// Definición de los registros y valores
.equ PCC_BASE, 0x40065000              // Base del PCC (Peripheral Clock Control): Punto de partida para acceder a los registros del controlador de reloj de los periféricos.
.equ PCC_PORTB, (PCC_BASE + 0x128)     // Offset para el PCC del puerto B: Registro específico para controlar el reloj del puerto B.
.equ PORTB_BASE, 0x4004A000            // Base del PORTB: Punto de partida para acceder a los registros del puerto B.
.equ PORTB_PCR12, (PORTB_BASE + 0x30)  // PCR para PTB12: Registro de control de pin para el pin 12 del puerto B.
.equ PORTB_PCR13, (PORTB_BASE + 0x34)  // PCR para PTB13: Registro de control de pin para el pin 13 del puerto B.
.equ PORTB_PCR14, (PORTB_BASE + 0x38)  // PCR para PTB14: Registro de control de pin para el pin 14 del puerto B.
.equ MUX_GPIO, 0x1                     // Configuración Mux para GPIO (Alternativa 1): Configura el pin para funcionar como GPIO (Entrada/Salida general).
.equ PCC_PORTB_CGC, (1 << 30)          // Bit para habilitar el reloj del puerto B: Activa el reloj para el puerto B en el registro PCC_PORTB.


// Bits correspondientes a los LEDs
.equ LED_ROJO, 12                    // LED Rojo conectado a PTB12: El LED rojo está conectado al pin 12 del puerto B.
.equ LED_AMARILLO, 13                // LED Amarillo conectado a PTB13: El LED amarillo está conectado al pin 13 del puerto B.
.equ LED_VERDE, 14                   // LED Verde conectado a PTB14: El LED verde está conectado al pin 14 del puerto B.


// Definición de los tiempos en ciclos de reloj (ajustar según la frecuencia del microcontrolador)
.equ TIEMPO_ROJO, 5000               // Tiempo en ciclos de reloj para el estado ROJO.
.equ TIEMPO_ROJO_AMARILLO, 3000      // Tiempo en ciclos de reloj para el estado ROJO_AMARILLO.
.equ TIEMPO_VERDE, 5000              // Tiempo en ciclos de reloj para el estado VERDE.
.equ TIEMPO_AMARILLO, 2000           // Tiempo en ciclos de reloj para el estado AMARILLO.


// Definición de los estados
.equ ROJO, 0                         // Estado ROJO: Código de estado para el semáforo en ROJO.
.equ ROJO_AMARILLO, 1                // Estado ROJO_AMARILLO: Código de estado para el semáforo en ROJO_AMARILLO.
.equ VERDE, 2                        // Estado VERDE: Código de estado para el semáforo en VERDE.
.equ AMARILLO, 3                     // Estado AMARILLO: Código de estado para el semáforo en AMARILLO.

