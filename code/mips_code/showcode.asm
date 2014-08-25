.text      
lui $v1, 49152 #C000 VGA
#lui $a0, 40960 #A000 IO

#addi $t0,$zero,32528 #7F10 segment address
#add $t1,$zero,$zero
#lw $t1,0($t1)
#sw $t1,0($t0)

addi $s2,$zero,892
#sw $t1,0($t0)
jal showhex

#j end

addi $a1,$zero,419

andi $a2,$a1,255
srl $a1,$a2,4 # high 4 bits
addi $a3,$a1,-10
srl $a3,$a3,31
beq $a3,$zero,2 # >A branch
addi $a1,$a1,48 # +'0'
j L13
addi $a1,$a1,55 # +'A'-10
L13:
jal print# 13
andi $a1,$a2,15 # low 4 bits
addi $a3,$a1,-10
srl $a3,$a3,31
beq $a3,$zero,2 # >A branch
addi $a1,$a1,48 # +'0'
j L21
addi $a1,$a1,55 # +'A'-10
L21:
jal print
addi $a1,$zero,32
jal print
j end

showhex: # number (32 bits) in $s2
add $s3,$ra,$s3
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