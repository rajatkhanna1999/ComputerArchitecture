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

mov r1,#1000						@ Moving head address
mov r2,r1    						@ i, iteration for the Outer Loop in Linked List
mov r13,#0
mov r14,#1000					        @ head address of the LinkedList

Outer_Loop:						@ OuterLoop for SelectionSort
cmp r2,#0 					        @ end of the list
beq Escape
mov r9,r2 
ldr r3,[r2] 						@ j = i + 1
ldr r4,[r2,#4] 						@ value at node i let it be maximum
mov r11,#0
Inner_Loop:
cmp r3,#0 						@ End of the LinkedList
beq swap
ldr r5,[r3,#4] 						@ Value at node j
cmp r5,r4
bgt greater
mov r9,r3    						@ Update previous node
ldr r3,[r3]  						@ Update current node
b Inner_Loop

greater:
mov r4,r5    						@ Update the maximum element
mov r11,#1   						@ Flag to check if we have to change the links or not
mov r6,r3 						@ Current node
ldr r7,[r3]						@ Next node
mov r8, r9 						@ Previous node
mov r9, r3
ldr r3,[r3]
b Inner_Loop

swap:
cmp r11,#0 						@ If no links to change
beq Flag						
cmp r13,#0					        @ If head is not changed
beq Head
str r7,[r8]   						@ Change links in linked List
str r2,[r6]
str r6,[r12]
mov r12,r6
ldr r2,[r6]
b Outer_Loop

Head:
mov r13,#1  						@ flag to check that head is changed
str r7,[r8]						
str r2,[r6] 						@ channge links
mov r12,r6
mov r14,r6
ldr r2,[r6]
b Outer_Loop

Flag:
mov r12,r2
ldr r2,[r2]  						@ update i
mov r13,#1   						@ maximum element is at head 
b Outer_Loop

Escape:
mov r7,r14  						@ starting address
mov r6,#0

label:
ldr r1,[r7,#4]
ldr r7,[r7]
add r6,r6,#1
cmp r6,#3
bne label

mov r2, #1000
Iteration:
ldr r3, [r2]			       	
ldr r0, [r2,#4]			       @ R0 Contains the Data of teh Current Node	
mov r2, r3			       @ Updating the Pointer	
cmp r2, #0
bne Iteration

swi SWI_Exit			      			@ Exiting                                                                             

@-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@ data used by the program including read only variables/constants
.data
N: .word 3
Array: .word 2,5,3
