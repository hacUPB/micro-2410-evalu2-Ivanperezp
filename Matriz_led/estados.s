 #include "definitions.h"

  .syntax unified
  .global estado_columna
  .text


  .align 2                   // Alinear la tabla de direcciones a 4 bytes (2^2 = 4)

dir_tabla_estados:           // Lista de direcciones de los estados
    .long es_col1            //0
    .long es_col2            //1
    .long es_col3            //2
    .long es_col4            //3
    .long es_col5            //4
    .long es_col6            //5
    .long es_col7            //6   
    .long es_col8            //7
    .thumb_func


estado_columna:                    //estado intermedio
    push {lr}
    ldr r4, =Base_maquina_0        //carga en r4 la dirección base
    ldr r0, [r4, #var_estado_M0]   
    lsl r0, #2                     
    ldr r4, =dir_tabla_estados     
    ldr r1, [r4, r0]               
    bx r1
    .thumb_func

es_col1:
    ldr r4, =Base_maquina_0           //Verifica si el tiempo entre estados se cumplió
    ldr r0, [r4, #entrada_tiempo_M0]  
    ldr r5, =TIEMPO_COL              
    cmp r0, r5
    blt fin_estado    
                    //Finaliza el estado
    ldr r0, =GPIOC_PDOR               //Apaga los leds del estado anterior          
    mov r1, #(reset << 8)
    str r1, [r0]
    ldr r0, =GPIOB_PDOR
    mov r1, #(0 << COL_8)
    str r1, [r0]




    ldrb r3, =dir_imagen              //Carga en el registro R2 los bits correspondientes a la columna
    ldr r2, [r3, ECOL1]

    // Salidas
    ldr r0, =GPIOB_PDOR               //Enciende la columna correspondiente colocando..
    mov r1, #(1 << COL_1)             //.. un 1 en el lugar indicado del registro PDOR
    str r1, [r0]                      

    ldr r0, =GPIOC_PDOR               //Enciende la fila correspondiente colocando..
    lsl r2, #8                        //.. un 0 en el lugar indicado del registro PDOR
    mvn r1, r2                        //niega la fila almacenada para colocar ceros.
    str r1, [r0]

    // Cambiar al siguiente estado 
    mov r1, #ECOL2
    str r1, [r4, #var_estado_M0]
    mov r0, #0
    str r0, [r4, #entrada_tiempo_M0]
    pop {lr}
    bx lr

    .thumb_func
    //Este mismo procedimiento se repite en todos los estados.
es_col2:


    ldr r4, =Base_maquina_0
    ldr r0, [r4, #entrada_tiempo_M0]  
    ldr r5, =TIEMPO_COL              
    cmp r0, r5
    blt fin_estado    

    ldr r0, =GPIOC_PDOR
    mov r1, #(reset << 8)
    str r1, [r0]
    ldr r0, =GPIOB_PDOR
    mov r1, #(0 << COL_1)
    str r1, [r0]
    
    ldrb r3, =dir_imagen
    ldr r2, [r3, ECOL2]                //Offset para cambiar de fila   
                 
    //salidas
    ldr r0, =GPIOB_PDOR
    mov r1, #(1 << COL_2)
    str r1, [r0]                     
                  
    ldr r0, =GPIOC_PDOR
    lsl r2, #8
    mvn r1, r2    
    str r1, [r0]           


    // Cambiar al siguiente estado 
    mov r1, #ECOL3
    str r1, [r4, #var_estado_M0]
    mov r0, #0
    str r0, [r4, #entrada_tiempo_M0]
    pop {lr}
    bx lr

    .thumb_func

es_col3:

    ldr r4, =Base_maquina_0
    ldr r0, [r4, #entrada_tiempo_M0]  
    ldr r5, =TIEMPO_COL              
    cmp r0, r5
    blt fin_estado 
    
    ldr r0, =GPIOC_PDOR
    mov r1, #(reset << 8)
    str r1, [r0]
    ldr r0, =GPIOB_PDOR
    mov r1, #(0 << COL_2)
    str r1, [r0]


    ldrb r3, =dir_imagen
    ldr r2, [r3, ECOL3]                  

    // Salidas
    ldr r0, =GPIOB_PDOR
    mov r1, #(1 << COL_3)
    str r1, [r0]                    
                  
    ldr r0, =GPIOC_PDOR
    lsl r2, #8
    mvn r1, r2    
    str r1, [r0]                    


    // Cambiar al siguiente estado 
    mov r1, #ECOL4
    str r1, [r4, #var_estado_M0]
        mov r0, #0
    str r0, [r4, #entrada_tiempo_M0]
    pop {lr}
    bx lr

    .thumb_func

es_col4:


    ldr r4, =Base_maquina_0
    ldr r0, [r4, #entrada_tiempo_M0]  
    ldr r5, =TIEMPO_COL              
    cmp r0, r5
    blt fin_estado 
    
    ldr r0, =GPIOC_PDOR
    mov r1, #(reset << 8)
    str r1, [r0]
    ldr r0, =GPIOB_PDOR
    mov r1, #(0 << COL_3)
    str r1, [r0]

    ldrb r3, =dir_imagen
    ldr r2, [r3, ECOL4]                   

    // Salidas
    ldr r0, =GPIOB_PDOR
    mov r1, #(1 << COL_4)
    str r1, [r0]                    
                  
    ldr r0, =GPIOC_PDOR
    lsl r2, #8
    mvn r1, r2    
    str r1, [r0]                   


    // Cambiar al siguiente estado 
    mov r1, #ECOL5
    str r1, [r4, #var_estado_M0]
        mov r0, #0
    str r0, [r4, #entrada_tiempo_M0]
    pop {lr}
    bx lr

    .thumb_func

es_col5:


    ldr r4, =Base_maquina_0
    ldr r0, [r4, #entrada_tiempo_M0]  
    ldr r5, =TIEMPO_COL              
    cmp r0, r5
    blt fin_estado                    

    ldr r0, =GPIOC_PDOR
    mov r1, #(reset << 8)
    str r1, [r0]
    ldr r0, =GPIOB_PDOR
    mov r1, #(0 << COL_4)
    str r1, [r0]

    ldrb r3, =dir_imagen
    ldr r2, [r3, ECOL5]

    // Salidas
    ldr r0, =GPIOB_PDOR
    mov r1, #(1 << COL_5)
    str r1, [r0]                      
                  
    ldr r0, =GPIOC_PDOR
    lsl r2, #8
    mvn r1, r2    
    str r1, [r0]                   
 

    // Cambiar al siguiente estado 
    mov r1, #ECOL6
    str r1, [r4, #var_estado_M0]
        mov r0, #0
    str r0, [r4, #entrada_tiempo_M0]
    pop {lr}
    bx lr

    .thumb_func

es_col6:

    ldr r4, =Base_maquina_0
    ldr r0, [r4, #entrada_tiempo_M0]  
    ldr r5, =TIEMPO_COL              
    cmp r0, r5
    blt fin_estado                    

    ldr r0, =GPIOC_PDOR
    mov r1, #(reset << 8)
    str r1, [r0]
    ldr r0, =GPIOB_PDOR
    mov r1, #(0 << COL_5)
    str r1, [r0]


    ldrb r3, =dir_imagen
    ldr r2, [r3, ECOL6]

    // Salidas
    ldr r0, =GPIOB_PDOR
    mov r1, #(1 << COL_6)
    str r1, [r0]                     
                  
    ldr r0, =GPIOC_PDOR
    lsl r2, #8
    mvn r1, r2    
    str r1, [r0]                   

    // Cambiar al siguiente estado 
    mov r1, #ECOL7
    str r1, [r4, #var_estado_M0]
        mov r0, #0
    str r0, [r4, #entrada_tiempo_M0]
    pop {lr}
    bx lr

    .thumb_func

es_col7:


    ldr r4, =Base_maquina_0
    ldr r0, [r4, #entrada_tiempo_M0]  
    ldr r5, =TIEMPO_COL              
    cmp r0, r5
    blt fin_estado                    

    ldr r0, =GPIOC_PDOR
    mov r1, #(reset << 8)
    str r1, [r0]
    ldr r0, =GPIOB_PDOR
    mov r1, #(0 << COL_6)
    str r1, [r0]

    ldrb r3, =dir_imagen
    ldr r2, [r3, ECOL7]

    // Salidas
    ldr r0, =GPIOB_PDOR
    mov r1, #(1 << COL_7)
    str r1, [r0]                      
                  
    ldr r0, =GPIOC_PDOR
    lsl r2, #8
    mvn r1, r2    
    str r1, [r0]                   

    // Cambiar al siguiente estado 
    mov r1, #ECOL8
    str r1, [r4, #var_estado_M0]
        mov r0, #0
    str r0, [r4, #entrada_tiempo_M0]
    pop {lr}
    bx lr

    .thumb_func

es_col8:


    ldr r4, =Base_maquina_0
    ldr r0, [r4, #entrada_tiempo_M0]  
    ldr r5, =TIEMPO_COL              
    cmp r0, r5
    blt fin_estado                    

    ldr r0, =GPIOC_PDOR
    mov r1, #(reset << 8)
    str r1, [r0]
    ldr r0, =GPIOB_PDOR
    mov r1, #(0 << COL_7)
    str r1, [r0]

    ldrb r3, =dir_imagen
    ldr r2, [r3, ECOL8]

    // Salidas
    ldr r0, =GPIOB_PDOR
    mov r1, #(1 << COL_8)
    str r1, [r0]                  
                  
    ldr r0, =GPIOC_PDOR
    lsl r2, #8
    mvn r1, r2    
    str r1, [r0]                   

    // Cambiar al siguiente estado 
    mov r1, #ECOL1
    str r1, [r4, #var_estado_M0]
        mov r0, #0
    str r0, [r4, #entrada_tiempo_M0]
    pop {lr}
    bx lr

    .thumb_func

fin_estado:
    pop {lr}
    bx lr

