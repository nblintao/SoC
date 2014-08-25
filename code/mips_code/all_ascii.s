.text
lui $v1, 49152 #C000 

addi $a1,$zero,0

for:
jal print
addi $a1,$a1,1
slti $v0,$a1,128
bne $v0,$zero,for

end:
j end

print: # disp num in $a1
sw $a1,0($v1)
addi $v1,$v1,4
jr $ra
nop
nop
nop
nop