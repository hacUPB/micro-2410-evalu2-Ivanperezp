.syntax unified
.global _start
.text

.equ v1, 0x20000100      // Define la dirección de memoria de inicio para el vector 1
.equ v2, 0x20000140      // Define la dirección de memoria de inicio para el vector 2
.equ vRes, 0x20000200    // Define la dirección de memoria donde se almacenará el resultado

// Definición de los datos de entrada (vectores)
lista1:
.hword 1,2,3,4,0         // Define el vector lista1 con valores 1, 2, 3, 4, y un 0 como fin de lista

lista2:
.hword 2,3,4,5,0         // Define el vector lista2 con valores 2, 3, 4, 5, y un 0 como fin de lista

.thumb_func
_start:
    bl    init           // Llama a la función init (inicialización)
    bl    vector1        // Llama a la función que copia el vector lista1 a la memoria
    bl    vector2        // Llama a la función que copia el vector lista2 a la memoria
loop:
    bl    mult_vect      // Llama a la función que multiplica los vectores
    b     loop           // Bucle infinito, sigue llamando a la función de multiplicación

// Función de inicialización
init:
  // Retorna inmediatamente, no hace nada
  bx    lr               // Retorno de la función (salir de init)

vector1:
  push  {lr}             // Guarda el valor de retorno en la pila
  ldr   r4, =#lista1     // Carga la dirección del vector lista1 en el registro r4
  ldr   r5, =#v1         // Carga la dirección base del vector 1 en la memoria en el registro r5
  bl    loop_store       // Llama a la función que copia los valores del vector a la memoria
  pop   {pc}             // Restaura el valor de retorno y regresa de la función

vector2:
  push  {lr}             // Guarda el valor de retorno en la pila
  ldr   r4, =#lista2     // Carga la dirección del vector lista2 en el registro r4
  ldr   r5, =#v2         // Carga la dirección base del vector 2 en la memoria en el registro r5
  bl    loop_store       // Llama a la función que copia los valores del vector a la memoria
  pop   {pc}             // Restaura el valor de retorno y regresa de la función

loop_store:               // Función para almacenar los valores de los vectores en memoria
  ldrh  r0, [r4], #2     // Carga un valor de 16 bits desde lista1 o lista2 a r0, y avanza 2 bytes (tamaño de una palabra media)
  cmp   r0, #0           // Compara el valor de r0 con 0
  beq   end_store        // Si el valor es 0 (final de la lista), salta a end_store
  strh  r0, [r5], #2     // Almacena el valor en la memoria de destino (v1 o v2) y avanza
  b     loop_store       // Vuelve al inicio de la función para copiar el siguiente valor
end_store:
  // Retorna de la función
  bx    lr               // Retorno de la función (salir de loop_store)

mult_vect:                // Función que multiplica los vectores
  ldr   r4, =#v1         // Carga la dirección del vector 1 en el registro r4
  ldr   r5, =#v2         // Carga la dirección del vector 2 en el registro r5
  ldr   r6, =#vRes       // Carga la dirección donde se almacenarán los resultados en el registro r6
  b     loop_mult        // Salta al bucle de multiplicación

loop_mult:                // Bucle de multiplicación
  ldrh  r0, [r4], #2     // Carga un valor de 16 bits del vector 1 en r0, y avanza
  ldrh  r1, [r5], #2     // Carga un valor de 16 bits del vector 2 en r1, y avanza
  cmp   r0, #0           // Compara el valor de r0 con 0 (indica fin del vector)
  beq   end_mult         // Si es 0, termina la multiplicación
  cmp   r1, #0           // Compara el valor de r1 con 0 (indica fin del vector)
  beq   end_mult         // Si es 0, termina la multiplicación
  mul   r0, r1           // Multiplica los valores de r0 y r1, resultado se guarda en r0
  str   r0, [r6], #4     // Almacena el resultado en la dirección vRes y avanza 4 bytes (tamaño de una palabra)
  b     loop_mult        // Repite el ciclo de multiplicación
end_mult:
  // Retorna de la función
  bx    lr               // Retorno de la función (salir de loop_mult)
