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

@------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.text
Open:
  ldr r0,=infilename
  mov r1, #0 					@read mode
  swi SWI_Open  				@opening File
  ldr r1,=infilehandle
  str r0,[r1]
  mov r2, #0 					@count no. of int read

Read:
  ldr r0,=infilehandle
  mov r9,r0
  ldr r0,[r0]
  swi SWI_RdInt 				@read integer
  bcs readDone
  add r2,r2,#1 					@increment no. of integer read
  cmp r2,#1
  beq alloc_mem
  str r0,[r4]
  add r4,r4,#4

  b Read

alloc_mem:
  mov r4,#4
  mov r5,r0 					@r5 stores the total no. of elements
  mul r0,r4,r0
  swi SWI_MeAlloc
  mov r3,r0 					@r3 stores the beginning of the array
  mov r4,r3
  b Read



readDone:
  @ swi SWI_Exit
  ldr r0,=infilehandle
  ldr r0,[r0]
  swi SWI_Close
  mov r6,#0
  mov r4,r3
  b selection_sort

@---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
selection_sort:
mov r0, r5
mov r1, r5
mov r2, r1			@r1-->N
mov r10, r3
mov r11, r3

sub r2, r2, #1			@r2-->N-1
mov r3, #0			@Counter for OuterLoop i-->r3
mov r8, #4

OuterLoop:
add r4, r3, #1			@Counter for InnerLoop j-->r4
mov r5, r3			@minIndex-->r5
ldr r6,	[r11]			@MinData
add r12, r11, #4

InnerLoop:
cmp r4, r1
beq Exit			@InnerLoop to check 
ldr r7, [r12]
add r12, r12, #4
add r4, r4, #1
cmp r6, r7
blt InnerLoop
mov r5, r4
sub r5, r5, #1
sub r14, r5, r3
mul r14, r8, r14
add r14, r14, r11
ldr r6, [r14]
cmp r4, r1
blt InnerLoop

Exit:				@Exiting inner loop to go to outer Loop
sub r13, r5, r3
mul r9, r13, r8
add r14 , r11, r9
ldr r7, [r14]
ldr r9, [r11]
str r7, [r11]
str r9, [r14]
add r11, r11, #4
add r3, r3, #1
cmp r3, r2
blt OuterLoop			@OuterLoop

@-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

program_end:
  mov r4, r10
  mov r6,#0
  mov r5, r0
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
