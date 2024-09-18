
#include  "definitions.h"
.syntax unified

  .global _start
  .extern estado_columna  
  .text
  .thumb_func

_start:
    bl iniciar_clk
    bl gpioBC_ini    
    bl crear_tabla_leds   
    bl systick_conf

    // Máquina de estados
    ldr r4, =Base_maquina_0
    mov r1, #ECOL1                     
    str r1, [r4, #var_estado_M0]
    mov r2, #0
    str r2, [r4, entrada_tiempo_M0]
    
    loop_principal:
    bl estado_columna                
    b loop_principal
    
    //Subrutina configuración de GPIOs 
gpioBC_ini:    
    ldr r0, =GPIOB_PDDR           //Configuración como GPIO puerto B         
    ldr r1, [r0]
    orr r1, r1, #(1 << COL_1)      
    orr r1, r1, #(1 << COL_2)  
    orr r1, r1, #(1 << COL_3)
    orr r1, r1, #(1 << COL_4)
    orr r1, r1, #(1 << COL_5)      
    orr r1, r1, #(1 << COL_6)  
    orr r1, r1, #(1 << COL_7)
    orr r1, r1, #(1 << COL_8)     
    str r1, [r0]
    
    ldr r0, =GPIOC_PDDR           //Configuración como GPIO puerto C               
    ldr r1, [r0] 
    orr r1, r1, #(1 << ROW1)      
    orr r1, r1, #(1 << ROW2)  
    orr r1, r1, #(1 << ROW3)
    orr r1, r1, #(1 << ROW4)
    orr r1, r1, #(1 << ROW5)      
    orr r1, r1, #(1 << ROW6)  
    orr r1, r1, #(1 << ROW7)
    orr r1, r1, #(1 << ROW8)     
    str r1, [r0]                   
    bx lr

    // Subrutina de configuración de puertos
iniciar_clk:
    ldr r0, =PCC_PORTB               // Habilitar el reloj para el puerto B                 
    ldr r1, [r0]                       
    orr r1, r1, #PCC_PORT_CGC         
    str r1, [r0]

    ldr r0, =PCC_PORTC               // Habilitar el reloj para el puerto C
    ldr r1, [r0]
    orr r1, r1, #PCC_PORT_CGC
    str r1, [r0]                       

PTB_init:
    // Configurar los puertos B PCR(10-17)
    mov r2, #7
    ldr r0, =PORTB_PCR10
loop_PTB_init:    
    ldr r1, [r0]                       
    bic r1, r1, #(0x7 << 8)            
    orr r1, r1, #(MUX_GPIO << 8)       
    str r1, [r0]
    cmp r2, #0
    beq PTC_init
    subs r2, r2, #1
    add r0, r0, #4  
    b loop_PTB_init
                           
PTC_init:
    // Configurar los puertos C PCR(8-15)
    mov r2, #7
    ldr r0, =PORTC_PCR8
loop_PTC_init:              
    ldr r1, [r0]                       
    bic r1, r1, #(0x7 << 8)            
    orr r1, r1, #(MUX_GPIO << 8)       
    str r1, [r0]
    ldr r5, =PORTC_PCR15
    cmp r2, #0
    beq saltar
    sub r2, r2, #1
    add r0, r0, #4 
    b loop_PTC_init

    // Retornar de la subrutina
saltar:
    bx lr


systick_conf:
   // Configurar SysTick 
    ldr r0, =SYST_RVR
    ldr r1, =SYSTICK_RELOAD_1MS
    str r1, [r0]                      

    ldr r0, =SYST_CVR
    mov r1, #0
    str r1, [r0]                      

    ldr r0, =SYST_CSR
    mov r1, #(SYSTICK_ENABLE | SYSTICK_TICKINT | SYSTICK_CLKSOURCE)
    str r1, [r0]                      // Habilitar el SysTick, la interrupción y seleccionar el reloj del procesador
    bx  lr

crear_tabla_leds:
    ldr   r4, =#0x20000000            // Dirección inicial de memoria para guardar la tabla
    ldr   r1, =leds                   // Dirección de la tabla en la memoria de programa
    mov   r2, #8                      // Tamaño de la matriz (filas)
    mov   r3, #8                      // Tamaño de la matriz (columnas)
loop_filas:
    ldrb  r0, [r1], #1                // Carga el byte actual de la tabla de LED
    strb  r0, [r4], #1                // Guarda el byte en la dirección de memoria y avanza
    subs  r3, r3, #1                  // Decrementa el contador de columnas
    bne   loop_filas                  // Continúa el bucle si no se han procesado todas las columnas
    mov   r3, #8                      // Reinicia el contador de columnas para la siguiente fila
    subs  r2, r2, #1                  // Decrementa el contador de filas
    bne   loop_filas                  // Continúa el bucle si no se han procesado todas las filas
    bx    lr                          // Retorna
    
  //Almacenamiento de la imagen en la flash
.section .rodata
leds:
    .byte 0b10001000
    .byte 0b11111000
    .byte 0b10101000
    .byte 0b01110001
    .byte 0b00100001
    .byte 0b01111001
    .byte 0b01111101
    .byte 0b10111110