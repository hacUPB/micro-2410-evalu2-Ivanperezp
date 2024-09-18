.syntax unified
.global _start
.text

.thumb_func
_start:
    bl  init
    bl  cargar_memoria
loop:
    bl  copiar_datos
    b   loop

init:
    mov   r0, #0
    mov   r1, #0
    mov   r2, #0
    bx    lr

cargar_memoria:
    ldr   r4, =#0x20000000
    mov   r0, #1
    mov   r1, #10
loop_carga:
    str   r0, [r4], #4
	  adds  r1, #-1
    beq   fin_carga
    b     loop_carga
fin_carga:
    bx    lr

copiar_datos:
    ldr   r4, =#0x20000000
loop_copia:
    ldr   r0, [r4]
    cmp   r0, #0
    beq   fin_copia
    str   r0, [r4, #0x100]
    add   r4, #4
    b     loop_copia
fin_copia:
    bx    lr
