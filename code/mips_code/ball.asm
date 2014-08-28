.text

main:
    addi    $sp,    $zero,  SP
    addi    $sp,    $sp,    -16
    sw      $zero,  12($sp)     # row
    sw      $zero,  8($sp)      # column
    sw      $zero,  4($sp)      # speed
    sw      $zero,  0($sp)      # count

    addi    $t0,    $t0,    BALL
    li      $t1,    VGA_A
    sw      $t0,    0($t1)

polling:
    add     $a1,    $zero,  $sp         # save address of row, column, speed, count data
    # keybord
    li      $t0,    PS2_A
    lw      $s0,    0($t0) 
    andi    $t0,    $s0,    256     
    beq     $t0,    $zero,  2           # $s0[8] != ready
    move    $a0,    $s0
    jal     print_keybord
    # timer 
    lw      $t0,    TIMER($zero)
    bne     $t0,    $zero,  1
    jal     timer_step
    #others
    j       polling

timer:
# $a1 : address of row, column, speed, count data
    



print_keybord:
# $a0 : data form keybord 0x0000_01XX
# $a1 : address of row, column data
    addi    $sp,    $sp,    -4
    sw      $ra,    0($sp)
    addi    $t0,    $zero,  F0_done     # $t0 = addr(F0_done)
    lw      $t1,    0($t0)      # $t1 = F0_done
    bne     $t1,    $zero,  print_keybord_f0before  # F0_done != 0
    li      $t1,    0x000001F0
    beq     $t1,    $a0,    print_keybord_thisf0    # $a0 == 0x00001f0
    andi    $a0,    $a0,    0xFF    # $a0 = 0x0000_00XX

    addi    $t2,    $zero,  0x74
    beq     $t2,    $a0,    print_keybord_right
    j       print_keybord_exit


print_keybord_right:
    addi    $sp,    $sp,    -8
    sw      $a0,    0($sp)
    sw      $a1,    4($sp)

    move    $t0,    $a1     # address of row, column data

    lw      $a0,    0($t0)  # row
    lw      $a1,    4($t0)  # column
    jal     move_right

    lw      $a0,    0($sp)
    lw      $a1,    4($sp)
    addi    $sp,    $sp,    8

    sw      $v0,    0($a1)
    sw      $v1,    4($a1)

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



move_right:
# $a0:  row
# $a1:  column
# $v0:  new row
# $v1:  new column
    sll     $t0,    $a0,    6       # $t0 = (char_row<<6) + (char_row<<4) + char_col
    sll     $t1,    $a0,    4
    add     $t0,    $t0,    $t1
    add     $t0,    $t0,    $a1
    sll     $t0,    $t0,    2
    li      $t1,    VGA_A           # $t1 = $t0 + VGA_A
    add     $t1,    $t1,    $t0
    lw      $t2,    0($t1)          # $t2 = ascii
#addi    $t2,$zero,BALL
    sw      $t2,    SEG_A($zero)

    sw      $zero,  0($t1)          # clear the original position
    addi    $v0,    $a0,    0       # CHANGE! new row
    addi    $v1,    $a1,    1       # CHANGE! new column
    addi    $t1,    $t1,    4       # CHANGE! move position
    sw      $t2,    0($t1)          # redraw
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
`define     TIMER       0x00001008
`define     BALL        0x1f