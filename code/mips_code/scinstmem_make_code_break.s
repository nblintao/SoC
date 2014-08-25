.text      
lui $v1, 49152 #C000 
lui $a0, 40960 #A000 

addi $t0,$zero,32528 #7F10 segment address
add $t1,$zero,$zero
lw $t1,0($t1)
sw $t1,0($t0)

L2:
lw $a1,0($a0) 
andi $a2,$a1,256
beq $a2,$zero,-3 # ready

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
j L2

print: # disp num in $a1
sw $a1,0($v1)
addi $v1,$v1,4
jr $ra
nop
nop
nop
nop