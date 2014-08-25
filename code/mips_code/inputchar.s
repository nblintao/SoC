.text      
lui $v1, 49152 #C000 
lui $a0, 40960 #A000 

L2:
lw $a1,0($a0) 
andi $a2,$a1,256
beq $a2,$zero,-3 # ready

andi $a2,$a1,255 #$a2=

#a2


print: # disp num in $a1
sw $a1,0($v1)
addi $v1,$v1,4
jr $ra
nop
nop
nop
nop