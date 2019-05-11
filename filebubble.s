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

@------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.text
Open:
  ldr r0,=infilename
  mov r1, #0 							@read mode
  swi SWI_Open  						@opening File
  ldr r1,=infilehandle
  str r0,[r1]
  mov r2, #0 							@count no. of int read

Read:
  ldr r0,=infilehandle
  mov r9,r0
  ldr r0,[r0]
  swi SWI_RdInt 						@read integer
  bcs readDone
  add r2,r2,#1 							@increment no. of integer read
  cmp r2,#1
  beq alloc_mem
  str r0,[r4]
  add r4,r4,#4

  b Read

alloc_mem:
  mov r4,#4
  mov r5,r0 							@r5 stores the total no. of elements
  mul r0,r4,r0
  swi SWI_MeAlloc
  mov r3,r0 							@r3 stores the beginning of the array
  mov r4,r3
  b Read


readDone:
  @ swi SWI_Exit
  ldr r0,=infilehandle
  ldr r0,[r0]
  swi SWI_Close
  mov r6,#0
  mov r4,r3
  b bubble_sort

@----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

bubble_sort:
@Maintaining Size and the Start address of Array
mov r0, r3			@r3-->begining element index
mov r1, r5			@r1-->no of elements
mov r10, r1
mov r2, r3

@Counter for OuterLoop
mov r3, #0

OuterLoop:
mov r4, #0			@Counter for InnerLoop
sub r10, r10, #1
mov r5, r2

InnerLoop:
cmp r4, r10			@Exit Inner Loop
beq Exit
add r4, r4, #1
ldr r6, [r5]
ldr r7, [r5,#4]
add r5, r5, #4
cmp r6, r7			@Comparing, if small then continue else swap 
blt InnerLoop
sub r8, r5, #4
str r7, [r8]
str r6, [r8,#4]
cmp r4, r10
bne InnerLoop			@checking if InnerLooop is not equal to n-i-1

Exit:
add r3, r3, #1			@Exiting Inner Loop
cmp r3, r1
blt OuterLoop

@------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

program_end:
  mov r4,r0
  mov r6,#0
  mov r5,r1
  ldr r0,=outfilename
  mov r1, #1 						@write mode
  swi SWI_Open  					@opening File
  ldr r1,=outfilehandle
  str r0,[r1]
  b read_from_mem

read_from_mem:
    ldr r1,[r4]
    add r4,r4,#4
    ldr r0,=outfilehandle
    ldr r0,[r0]
    swi SWI_PrInt
    bcs operr
    ldr r1,=seperator
    swi SWI_PrStr
    add r6,r6,#1
    cmp r6,r5
    blo read_from_mem
    swi SWI_Close
    swi SWI_Exit

operr:
  swi SWI_Exit

@-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.data
infilename: .asciz "in.txt"
outfilename: .asciz "out.txt"
seperator: .asciz " "

.align
infilehandle: .word 0
outfilehandle: .word 0
