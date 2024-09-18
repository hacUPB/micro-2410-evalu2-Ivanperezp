
.text

    // Direcciones de los registros SysTick
    .equ SYSTICK_BASE, 0xE000E010        // Base del SysTick
    .equ SYST_CSR, (SYSTICK_BASE + 0x0)  // SysTick Control and Status Register
    .equ SYST_RVR, (SYSTICK_BASE + 0x4)  // SysTick Reload Value Register
    .equ SYST_CVR, (SYSTICK_BASE + 0x8)  // SysTick Current Value Register

    .equ SYSTICK_ENABLE, 0x1             // Bit para habilitar el SysTick
    .equ SYSTICK_TICKINT, 0x2            // Bit para habilitar la interrupción del SysTick
    .equ SYSTICK_CLKSOURCE, 0x4          // Bit para seleccionar el reloj del procesador

    .equ SYSTICK_RELOAD_1MS, 48000-1     // Valor para recargar el SysTick cada 1 ms (suponiendo un reloj de 48 MHz)

    .equ Base_maquina_0, 0x20001000      // Dirección base compartida
    .equ var_estado_M0, 0                // Offset para la variable de estado
    .equ entrada_tiempo_M0, 4            // Offset para la entrada de tiempo transcurrido

   // Direcciones de los registros GPIO (Ejemplo para Kinetis K64)
    .equ GPIOB_PDDR, 0x400FF054              // Registro de dirección de datos del puerto B
    .equ GPIOB_PDOR, 0x400FF040              // Registro de salida de datos del puerto B
    .equ GPIOB_PSOR, 0x400FF044              // Registro de establecer bits de salida en puerto B
    .equ GPIOB_PCOR, 0x400FF048              // Registro de limpiar bits de salida en puerto B
    .equ GPIOB_PTOR, 0x400FF04C              // Registro de alternancia de datos del puerto B

    .equ GPIOC_PDDR, 0x400FF094              // Registro de dirección de datos del puerto C
    .equ GPIOC_PDOR, 0x400FF080              // Registro de salida de datos del puerto C
    .equ GPIOC_PSOR, 0x400FF084              // Registro de establecer bits de salida en puerto C
    .equ GPIOC_PCOR, 0x400FF088              // Registro de limpiar bits de salida en puerto C
    .equ GPIOC_PTOR, 0x400FF08C              // Registro de alternancia de datos del puerto C

    //dir tabla
    .equ dir_imagen, 0x20000000


    // Definición de los registros y valores
    .equ PCC_BASE, 0x40065000                // Base del PCC (Peripheral Clock Control)
    .equ PCC_PORTB, (PCC_BASE + 0x128)       // Offset para el PCC del puerto B
    .equ PCC_PORTC, (PCC_BASE + 0x12C)       // Offset para el PCC del puerto C
    .equ PORTB_BASE, 0x4004A000              // Base del PORTB
    .equ PORTC_BASE, 0x4004B000              // Base del PORTC
    .equ PORTB_PCR10, (PORTB_BASE + 0x28)    // PCR para PTB10
    .equ PORTB_PCR17, (PORTB_BASE + 0x44)    // PCR para PTB17
    .equ PORTC_PCR8, (PORTC_BASE + 0x20)     // PCR para PTC7
    .equ PORTC_PCR15, (PORTC_BASE + 0x3C)    // PCR para PTC15
    .equ MUX_GPIO, 0x1                       // Configuración Mux para GPIO (Alternativa 1)
    .equ PCC_PORT_CGC, (1 << 30)             // Bit para habilitar el reloj del puerto

    // Bits correspondientes a los LEDs
    .equ COL_1, 10                           // PIN columna 1 conectado a PTB10
    .equ COL_2, 11                           // PIN columna 2 conectado a PTB11
    .equ COL_3, 12                           // PIN columna 3 conectado a PTB12
    .equ COL_4, 13                           // PIN columna 4 conectado a PTB13
    .equ COL_5, 14                           // PIN columna 5 conectado a PTB14
    .equ COL_6, 15                           // PIN columna 6 conectado a PTB15
    .equ COL_7, 16                           // PIN columna 7 conectado a PTB16
    .equ COL_8, 17                           // PIN columna 8 conectado a PTB17
    
    // Definición de los tiempos en ciclos de reloj (ajustar según la frecuencia del microcontrolador)
    .equ TIEMPO_COL, 4

    .equ reset, 0b11111111                   // Reset que apaga las filas

    .equ ROW1, 8                             // Fila 1 (PTC8)
    .equ ROW2, 9                             // Fila 2 (PTC9)
    .equ ROW3, 10                            // Fila 3 (PTC10)
    .equ ROW4, 11                            // Fila 4 (PTC11)
    .equ ROW5, 12                            // Fila 5 (PTC12)
    .equ ROW6, 13                            // Fila 6 (PTC13)
    .equ ROW7, 14                            // Fila 7 (PTC14)
    .equ ROW8, 15                            // Fila 8 (PTC15)

    // Definición de los estados
    .equ ECOL1, 0
    .equ ECOL2, 1
    .equ ECOL3, 2
    .equ ECOL4, 3
    .equ ECOL5, 4
    .equ ECOL6, 5
    .equ ECOL7, 6
    .equ ECOL8, 7