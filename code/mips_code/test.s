.text

j   my_program     # jump to my proram
nop                # delay slot for pipelined cpu

int0:
j   kbd_handler  # deal with timer interrupt
nop                # delay slot for pipelined cpu
int1:
j   kbd_handler    # deal with keyboard interrupt
nop                # delay slot for pipelined cpu

my_program:
lui $v1, 49152 #C000 
lui $a0, 40960 #A000
j my_program

kbd_handler:
addi $t0,$zero,87
sw  $t0,0($v1)
addi $v1,$v1,4
eret

timer_handler:
eret



; Do not use the syscall functions provided in this simulator.
; single memory module:
memory_initialization_radix=2;
memory_initialization_vector=
00001000000000000000000000000110,
00000000000000000000000000000000,
00001000000000000000000000001001,
00000000000000000000000000000000,
00001000000000000000000000001001,
00000000000000000000000000000000,
00111100000000111100000000000000,
00111100000001001010000000000000,
00001000000000000000000000000110,
00100000000010000000000001010111,
10101100011010000000000000000000,
00100000011000110000000000000100,
01000010000000000000000000011000,
01000010000000000000000000011000,
00000000000000000000000000000000,
00000000000000000000000000000000;