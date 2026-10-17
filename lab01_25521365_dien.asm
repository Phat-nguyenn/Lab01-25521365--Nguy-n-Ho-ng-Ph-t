.data
.eqv BONUS 100
.eqv a_value 5

limit_table: .word 50,100,200,300,400,9999
price_table: .word 1700, 1760, 2050, 2600, 2950, 3100

prompt:         .asciiz "Nhap so kWh (0..9999): "
err_msg:        .asciiz "Gia tri khong hop le, nhap lai.\n"
res_msg:        .asciiz "Tien dien: "
unit_msg:       .asciiz " dong\n"

.text
.globl main

main:

input_loop:
#in loi nhac nhap
li $v0,4
la $a0, prompt
syscall

li $v0,5 #in loi nhac nhap so nguyen
syscall
move $s0, $v0

#kiem tra mien gia tri
sltiu $t0, $s0, 10000
beq $t0, $zero, invalid_input

j calculate

invalid_input:
li $v0,4
la $a0,err_msg
syscall
j input_loop

calculate:
    li $s1, 0                   
    la $s2, limit_table         
    la $s3, price_table
    li $s4, 0                   
    li $s5, 0                   
    
calc_loop:
    bge $s4, 6, display_result
    
    sll $t1, $s4, 2             
    add $t2, $s2, $t1           
    lw $t3, 0($t2)              

    add $t2, $s3, $t1           
    lw $t4, 0($t2)              

    ble $s0, $s5, display_result

    
    move $t5, $s0               
    ble $t5, $t3, use_x
    move $t5, $t3               
use_x:
    sub $t5, $t5, $s5           

    mul $t6, $t5, $t4
    add $s1, $s1, $t6          

    # Cap nhat prev_limit = cur_limit
    move $s5, $t3

    # Tang chi so vong lap i++
    addi $s4, $s4, 1
    j calc_loop

display_result:
    # In "Tien dien: "
    li $v0, 4
    la $a0, res_msg
    syscall

    # In so tien ($s1)
    li $v0, 1
    move $a0, $s1
    syscall

    # In " dong\n"
    li $v0, 4
    la $a0, unit_msg
    syscall

    li $v0, 10
    syscall