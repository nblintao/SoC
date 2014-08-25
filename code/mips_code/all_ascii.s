.text
lui $v1, 49152 #C000 

addi $a1,$zero,33

for:
jal print
addi $a1,$a1,1
slti $v0,$a1,40
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












.text
start:
lui $v1, 49152 #C000
addi $v0, $zero, 65
loop:
sw $v0,0($v1)
addi $v1,$v1,4
addi $v0,$v0,1
slti $t0,$v0, 128
bne $t0,$zero,loop
j start


; Do not use the syscall functions provided in this simulator.
; single memory module:
memory_initialization_radix=2;
memory_initialization_vector=
00111100000000111100000000000000,
00000000000000000001000000100000,
10101100011000100000000000000000,
00100000011000110000000000000100,
00100000010000100000000000000001,
00101000010010000000000010000000,
00010101000000001111111111111011,
00001000000000000000000000000000;
