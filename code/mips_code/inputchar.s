.text

main:
    addi    $sp,    $zero,  SP
    #input_char
input_char:
    li      $t0,    PS2_A
    lw      $s0,    0($t0) 
    andi    $t0,    $s0,    256     
    beq     $t0,    $zero,  input_char  # $s0[8] != ready
    # srl     $a0,    $s0,    4
    # jal     print_hex_digit
    # move    $a0,    $s0
    # jal     print_hex_digit
    move    $a0,    $s0
    jal     print_keybord
    j       input_char

print_keybord:
# $a0 : data form keybord 0x0000_01XX
    addi    $sp,    $sp,    -4
    sw      $ra,    0($sp)
    addi    $t0,    $zero,  F0_done     # $t0 = addr(F0_done)
    lw      $t1,    0($t0)      # $t1 = F0_done
    bne     $t1,    $zero,  print_keybord_f0before  # F0_done != 0
    li      $t1,    0x000001F0
    beq     $t1,    $a0,    print_keybord_thisf0    # $a0 == 0x00001f0
    andi    $a0,    $a0,    0xFF    # $a0 = 0x0000_00XX

    la      $t0,    SCAN_CODE       # $t0 = scan code base row
    move    $t1,    $t0             # $t1 = scan code row
print_keybord_next_line:
    la      $t2,    SCAN_CODE_END
    beq     $t2,    $t1,    print_keybord_exit  # find nothing, pass
    lw      $t2,    0($t1)          # $t2 = data this row
    add     $t3,    $zero,  $zero   # $t3 = scan code column
print_keybord_next_colume:
    sll     $t4,    $t3,    3       # $t4 = column * 8
    sllv    $t4,    $t2,    $t4     # $t4 = data << column * 8    0xA2B6CDEF colume=2 -> 0xCDEF00000
    srl     $t4,    $t4,    24      # 0xCDEF00000 -> 0x000000CD
    beq     $a0,    $t4,    print_keybord_find
    slti    $t5,    $t3,    3       # $t5 = column < 3
    beq     $t5,    $zero,  print_keybord_line_finish
    addi    $t3,    $t3,    1       # $t3 ++
    j       print_keybord_next_colume
print_keybord_line_finish:
    addi    $t1,    $t1,    4       # $t1 + 4
    j       print_keybord_next_line

print_keybord_find:
# $t0 = scan code base row
# $t1 = scan code row
# $t3 = scan code column
    sub     $t0,    $t1,    $t0
    add     $t0,    $t0,    $t3     # $t0 = position of the letter
    slti    $t1,    $t0,    26
    bne     $t1,    $zero,  print_keybord_alpha # $t0 < 26
    slti    $t1,    $t0,    36
    bne     $t1,    $zero,  print_keybord_digit # 26 <= $t0 < 36    
    slti    $t1,    $t0,    37
    bne     $t1,    $zero,  print_keybord_space         # $t0 == 36
    slti    $t1,    $t0,    38
    bne     $t1,    $zero,  print_keybord_backspace     # $t0 == 37
    slti    $t1,    $t0,    39
    bne     $t1,    $zero,  print_keybord_enter         # $t0 == 38
    slti    $t1,    $t0,    40
    bne     $t1,    $zero,  print_keybord_shift         # $t0 == 39
    slti    $t1,    $t0,    41
    bne     $t1,    $zero,  print_keybord_up            # $t0 == 40
    slti    $t1,    $t0,    41
    bne     $t1,    $zero,  print_keybord_left          # $t0 == 41
    slti    $t1,    $t0,    43
    bne     $t1,    $zero,  print_keybord_down          # $t0 == 41
    slti    $t1,    $t0,    44
    bne     $t1,    $zero,  print_keybord_right         # $t0 == 43

print_keybord_alpha:
    addi    $a0,    $t0,    97      # $a0 = position + 'a'(97)
    j       print_keybord_visiable

print_keybord_digit:
    addi    $a0,    $t0,    22      # $a0 = position - 26 + '0'(48)
    j       print_keybord_visiable

print_keybord_space:
    addi    $a0,    $zero,  32
    j       print_keybord_visiable

print_keybord_backspace:
    lw      $t0,    CURSOR_COL($zero)   # $t0 = cursor_column
    lw      $t1,    CURSOR_ROW($zero)   # $t1 = cursor_row    
    bne     $t0,    $zero,  print_keybord_backspace_regular
    beq     $t1,    $zero,  print_keybord_exit
    addi    $t1,    $t1,    -1
    sw      $t1,    CURSOR_ROW($zero)
    addi    $t0,    $zero,  80
print_keybord_backspace_regular:
    addi    $t0,    $t0,    -4
    sw      $t0,    CURSOR_COL($zero)
    sll     $t2,    $t1,    6       # (char_row<<6) + (char_row<<4) + char_col
    add     $t0,    $t0,    $t2
    sll     $t2,    $t1,    4
    add     $t0,    $t0,    $t2
    # sll     $t0,    $t0,    2       # position * 4
    li      $t1,    VGA_A
    add     $t0,    $t0,    $t1
    add     $a0,    $zero,  $zero
    sw      $a0,    0($t0)    
    j       print_keybord_exit      



print_keybord_enter:
    j           print_keybord_exit
print_keybord_shift:
    j           print_keybord_exit
print_keybord_up:
    j           print_keybord_exit
print_keybord_left:
    j           print_keybord_exit
print_keybord_down:
    j           print_keybord_exit
print_keybord_right:
    j           print_keybord_exit






print_keybord_visiable:
        jal     print_char
        j       print_keybord_exit    




print_keybord_thisf0:
    sw      $t1,    0($t0)      # F0_done = 0x00001f0
    j print_keybord_exit
print_keybord_f0before:
    sw      $zero,  0($t0)      # F0_done = $zero
print_keybord_exit:
    lw      $ra,    0($sp)
    addi    $sp,    $sp,    4    
    jr      $ra



# print_word:
# #  $a0 : word (32 bits)
#     addi    $sp,    $sp,    -12
#     sw      $ra,    0($sp)
#     sw      $s0,    4($sp)
#     sw      $s1,    8($sp)
#     addi    $s0,    $zero,  32      # $s0 = 32
#     add     $s1,    $zero,  $a0     # $s1 = $a0
# print_word_for:
#     addi    $s0,    $s0,    -4      # $s0 -= 4
#     srlv    $a0,    $s1,    $s0
#     jal     print_hex_digit
#     slti    $t0,    $s0,    4
#     beq     $t0,    $zero,  print_word_for
#     addi    $a0,    $zero,  32
#     jal     print_char
#     lw      $s1,    8($sp)
#     lw      $s0,    4($sp)
#     lw      $ra,    0($sp)
#     addi    $sp,    $sp,    12
#     jr      $ra

# print_hex_digit:
# # $a0 : hex digit (4 bits), left bits will be ignored
#     andi    $a0,    $a0,    15
#     slti    $t0,    $a0,    10
#     beq     $t0,    $zero,  2       # >=A branch
#     addi    $a0,    $a0,    48      # +'0'
#     j       print_hex_digit_j
#     addi    $a0,    $a0,    55      # +'A'-10
# print_hex_digit_j:
#     addi    $sp,    $sp,    -4
#     sw      $ra,    0($sp)
#     jal     print_char
#     lw      $ra,    0($sp)
#     addi    $sp,    $sp,    4
#     jr $ra

print_char:
# $a0 : ascii code (7 bits)
    lw      $t0,    CURSOR_COL($zero)   # $t0 = cursor_column
    lw      $t1,    CURSOR_ROW($zero)   # $t1 = cursor_row

    sll     $t2,    $t1,    6       # $t3 = (char_row<<6) + (char_row<<4) + char_col
    move    $t3,    $t2
    sll     $t2,    $t1,    4
    add     $t3,    $t3,    $t2
    add     $t3,    $t3,    $t0
    # sll     $t3,    $t3,    2       # position * 4
    li      $t4,    VGA_A
    add     $t3,    $t3,    $t4
    sw      $a0,    0($t3)

    slti    $t2,    $t0,    79
    bne     $t2,    $zero,  print_char_regular
    slti    $t2,    $t1,    59
    beq     $t2,    $zero,  print_char_exit
    addi    $t1,    $t1,    1
    sw      $t1,    CURSOR_ROW($zero)
    addi    $t0,    $zero,  0
    j       print_char_exit

print_char_regular:
    addi    $t0,    $t0,    4

print_char_exit:
    sw      $t0,    CURSOR_COL($zero)
    jr      $ra

end:
    j       end

.data

SCAN_CODE:
    .word   0x1C322123  # A B C D
    .word   0x242B3433  # E F G H
    .word   0x433B424B  # I J K L
    .word   0x3A31444D  # M N O P
    .word   0x152D1B2C  # Q R S T
    .word   0x3C2A1D22  # U V W X
    .word   0x351A4516  # Y Z 0 1
    .word   0x1E26252E  # 2 3 4 5
    .word   0x363D3E46  # 6 7 8 9
    .word   0x29665A59  # space backspace enter shift(only right)
    .word   0x756B7274  # U L D R
    # .word   0x  # 
    # .word   0x  # 
SCAN_CODE_END:

`define     SP          0x00001000
`define     VGA_A       0xC0000000
# `define     VGA_A       0x0000F000
`define     PS2_A       0xA0000000
`define     SEG_A       0x00007F10
`define     CURSOR_ROW  0x00001000
`define     CURSOR_COL  0x00001001
`define     F0_done     0x00001002