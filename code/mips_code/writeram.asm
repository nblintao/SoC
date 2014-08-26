.text
nop
nop
nop
addi $v1,$zero,0
addi $s4,$zero,62
sw $s4,0($v1)


lui $v1, 49152 #C000 VGA
#lui $a0, 40960 #A000 IO

#addi $t0,$zero,32528 #7F10 segment address
#add $t1,$zero,$zero
#lw $t1,0($t1)
#sw $t1,0($t0)

addi $s4,$zero,0
ret:
lw $s2,0($s4)
jal showhex
addi $s4,$s4,4
slti $s5,$s4,128
bne $s5,$zero,ret
#addi $s2,$zero,892


j end

showhex: # number (32 bits) in $s2
add $s3,$ra,$zero
addi $t0,$zero,32
showhex_for:
addi $t0,$t0,-4
srlv $a1,$s2,$t0
jal bigprint
slti $t1,$t0,4
beq $t1,$zero,showhex_for
addi $a1,$zero,32
jal print
jr $s3

bigprint: # digit (4 bits) in $a1
andi $a1,$a1,15
addi $a3,$a1,-10
srl $a3,$a3,31
beq $a3,$zero,2 # >A branch
addi $a1,$a1,48 # +'0'
j L133
addi $a1,$a1,55 # +'A'-10
L133:
sw $a1,0($v1)
addi $v1,$v1,4
jr $ra


print: 
sw $a1,0($v1)
addi $v1,$v1,4
jr $ra

end:
j end