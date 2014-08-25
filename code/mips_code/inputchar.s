.text      
lui $v1, 49152 #C000 
lui $a0, 40960 #A000 


polling:
lw $a1,0($a0) 
andi $a2,$a1,256 # $a2[8] = ready
beq $a2,$zero,-3 




end:
j end


print: # disp num in $a1
sw $a1,0($v1)
addi $v1,$v1,4
jr $ra