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