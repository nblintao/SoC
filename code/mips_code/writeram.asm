.text

main:
    addi    $sp,    $zero,  512     # 0000_0200   ram_depth = 7
    # display codes
    addi    $s0,    $zero,  0
main_ret:
    lw      $a0,    0($s0)
    jal     print_word
    addi    $s0,    $s0,    4
    slti    $t0,    $s0,    128
    bne     $t0,    $zero,  main_ret
    j   end

print_word:
#  $a0 : word (32 bits)
    addi    $sp,    $sp,    -12
    sw      $ra,    0($sp)
    sw      $s0,    4($sp)
    sw      $s1,    8($sp)
    addi    $s0,    $zero,  32      # $s0 = 32
    add     $s1,    $zero,  $a0     # $s1 = $a0
print_word_for:
    addi    $s0,    $s0,    -4      # $s0 -= 4
    srlv    $a0,    $s1,    $s0
    jal     print_hex_digit
    slti    $t0,    $s0,    4
    beq     $t0,    $zero,  print_word_for
    addi    $a0,    $zero,  32
    jal     print_char
    lw      $s1,    8($sp)
    lw      $s0,    4($sp)
    lw      $ra,    0($sp)
    addi    $sp,    $sp,    12
    jr      $ra

print_hex_digit:
# $a0 : hex digit (4 bits), left bits will be ignored
    andi    $a0,    $a0,    15
    slti    $t0,    $a0,    10
    beq     $t0,    $zero,  2       # >=A branch
    addi    $a0,    $a0,    48      # +'0'
    j       print_hex_digit_j
    addi    $a0,    $a0,    55      # +'A'-10
print_hex_digit_j:
    addi    $sp,    $sp,    -4
    sw      $ra,    0($sp)
    jal     print_char
    lw      $ra,    0($sp)
    addi    $sp,    $sp,    4
    jr $ra

print_char:
# $a0 : ascii code (7 bits)
    la      $t0,    VGA_A
    lw      $t1,    0($t0)
    sw      $a0,    0($t1)
    addi    $t1,    $t1,    4
    sw      $t1,    0($t0)
    jr      $ra

end:
    j       end


.data

VGA_A:
    .word   3221225472  # C000_0000
    #.word   61440       # 0000_F000
PS2_A:
    .word   2684354560  # A000_0000
SEG_A:
    .word   32528       # 0000_7F10
