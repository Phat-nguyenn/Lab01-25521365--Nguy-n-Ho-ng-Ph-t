.data
pitch:   .word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 64, 62, 62
len:     .word  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  3,  1,  4
n_notes: .word 15
sp:      .asciiz " "
nl:      .asciiz "\n"
msg_exp: .asciiz "Tong du kien (ms): "
msg_mea: .asciiz "Thoi gian do duoc (ms): "

        .text
        .globl main
main:
        la   $s0, pitch
        la   $s1, len
        lw   $s2, n_notes
        li   $s3, 0
        li   $s4, 0

        li   $v0, 30# moc thoi gian dau
        syscall
        move $s5, $a0

note_loop:
        beq  $s3, $s2, done
        sll  $t0, $s3, 2
        addu $t1, $s0, $t0
        lw   $s6, 0($t1)
        addiu $s6, $s6, 5 # cao do + a
        addu $t1, $s1, $t0
        lw   $t2, 0($t1)
        li   $t3, 210 # 150 + 10*b
        mul  $s7, $t2, $t3# thoi luong (ms)
        addu $s4, $s4, $s7# cong don tong du kien

        move $a0, $s6# in "<cao do> <ms>"
        li   $v0, 1
        syscall
        la   $a0, sp
        li   $v0, 4
        syscall
        move $a0, $s7
        li   $v0, 1
        syscall
        la   $a0, nl
        li   $v0, 4
        syscall

        move $a0, $s6# phat not
        move $a1, $s7
        li   $a2, 40
        li   $a3, 100
        li   $v0, 33# cau hinh A: 33
        syscall

        addiu $s3, $s3, 1
        j    note_loop

done:
        li   $v0, 30# moc thoi gian cuoi
        syscall
        subu $s5, $a0, $s5# thoi gian do duoc

        la   $a0, msg_exp
        li   $v0, 4
        syscall
        move $a0, $s4
        li   $v0, 1
        syscall
        la   $a0, nl
        li   $v0, 4
        syscall
        la   $a0, msg_mea
        li   $v0, 4
        syscall
        move $a0, $s5
        li   $v0, 1
        syscall
        la   $a0, nl
        li   $v0, 4
        syscall
        li   $v0, 10
        syscall