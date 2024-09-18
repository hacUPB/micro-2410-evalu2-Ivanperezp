.syntax unified
.global _start
.text
.equ BASE_DIRECTION, 20000000
.thumb_func
_start:
    bl  guardar_datos
    bx  lr

guardar_datos:
    ldr   r4, =BASE_DIRECTION
    mov   r0, #50     // Inicializa el primer número a guardar
    mov   r1, #140    // Último número a guardar
loop_guardar:
    str   r0, [r4], #4 // Guarda el número en la memoria y avanza a la siguiente posición
    adds  r0, #10     // Incrementa el número en 100 para el siguiente ciclo
    cmp   r0, r1       // Compara si se ha alcanzado el último número
    ble   loop_guardar // Si no se ha alcanzado el último número, continuar guardando
    bx    lr           // Retorna