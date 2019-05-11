@ give symbolic names to numeric constants
.equ SWI_PrChr, 0x00
.equ SWI_DpStr, 0x02
.equ SWI_Exit, 0x11
.equ SWI_MeAlloc, 0x12
.equ SWI_DAlloc, 0x13
.equ SWI_Open, 0x66
.equ SWI_Close, 0x68
.equ SWI_PrStr, 0x69
.equ SWI_RdStr, 0x6a
.equ SWI_PrInt, 0x6b
.equ SWI_RdInt, 0x6c
.equ SWI_Timer, 0x6d

@-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.text
@Maintaining Size and the Start address of Array
mov r1, #1000   			@ R1 is maintained as the head of the LinkedList
mov r0, #0
ldr r5, =N				 
ldr r5, [r5]				@ R5 Cointains the number of elements , N
ldr r3, =Array				@ R3 contains the starting address of the Array
str r0, [r1]				@ Initializing The data and Address of First Node as Zero
str r0, [r1,#4]

@Counter for iterating the LinkedList
mov r4, #0

LOOP:
mov r0, #8    			       @ 8 bytes  of Memory
swi SWI_MeAlloc 	               @ Dynamically allocates Memory and store its address in register r0
str r0, [r1] 			       @ Stores address of next node in the current node
ldr r7, [r3]
str r7, [r1,#4]			       @ Stores The Data in the Current Node
add r3, r3, #4			       @ Moving to next element in input array	
add r4, r4, #1			       @ Incrementing the counter for iterating the LinkedList
cmp r4, r5			       @ Comparing no of iterations to N
beq Exit
mov r1, r0			       @ The Current Pointer is Shifted to the Next New Node
b LOOP

Exit:
mov r8,#0
str r8,[r1]			       @ The final pointer in the last node of the list is set to 0 (the null pointer)

mov r1, #1000			       @ Register r1 stores the head of the LinkedList 

@-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

mov r2, r1			       @ Making Copy of the Head of the Linked List for Iteration/Traversal of the LinkedList
ldr r0, [r2,#4]			       @ R0 Contains the maximum element in the Linkedlist	

Iteration:
ldr r4, [r2]				
ldr r5, [r2,#4]			       @ R5 Contains the data of the current Node
cmp r5, r0
movgt r0, r5			       @ Comparing and Moving the maximum element into R0	
mov r2, r4
cmp r2, #0
bne Iteration

swi SWI_Exit			       @ Exiting

@-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@ data used by the program including read only variables/constants
.data
N: .word 3
Array: .word 2,5,3
