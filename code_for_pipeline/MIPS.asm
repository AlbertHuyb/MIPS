	j Main
	j Inter
	j Xp
gcd: 	beq $a0 $a1 equal
	slt $t0 $a0 $a1
	beq $t0 $s0 small
	j large	
equal:  add $v0 $a0 $zero
	j end
small:  sub $a1 $a1 $a0
	j gcd
large:  sub $a0 $a0 $a1
	nop
	j gcd
Main:	lui $at 16384
	ori $at $at 32
	add $t0 $zero $at
while1:  lw $t1 0($t0)
	andi $t1 $t1 8
	beq $t1 $zero while1
	nop
	lui $at 16384
	ori $at $at 28
	add $a0 $zero $at
	lw $a0 0($a0)
	add $s1 $a0 $zero
	nop
	lui $at 16384
	ori $at $at 32
	add $t0 $zero $at
while2:  lw $t1 0($t0)
	andi $t1 $t1 8
	beq $t1 $zero while2
	nop
	lui $at 16384
	ori $at $at 28
	add $a1 $zero $at
	lw $a1 0($a1)
	add $s2 $a1 $zero
	nop
	lui $at 16384
	ori $t7 $at 0
	sw $zero 8($t7)
	addiu $t5 $zero -81
	sw $t5 0($t7)
	addiu $t5 $zero -1
	sw $t5 4($t7)
	addi $t5 $zero 3
	sw $t5 8($t7)
	nop
	addi $s0 $zero 1
	j gcd
Inter:	lw $t5 8($t7)
	lui $at -1
	ori $at $at 65529
	and $t5 $t5 $at
	sw $t5 8($t7)
	nop
	addi $sp $sp 100
	sw $at 0($sp)
	sw $t0 4($sp)
	addi $sp $sp 8
	nop
	srl $s3 $s1 4
	srl $s5 $s2 4
	andi $s4 $s1 15
	andi $s6 $s2 15
	addi $s7 $zero 64
	sw $s7 0($zero)
	addi $s7 $zero 121
	sw $s7 4($zero)
	addi $s7 $zero 36
	sw $s7 8($zero)
	addi $s7 $zero 48
	sw $s7 12($zero)
	addi $s7 $zero 25
	sw $s7 16($zero)
	addi $s7 $zero 18
	sw $s7 20($zero)
	addi $s7 $zero 2
	sw $s7 24($zero)
	addi $s7 $zero 120
	sw $s7 28($zero)
	addi $s7 $zero 0
	sw $s7 32($zero)
	addi $s7 $zero 16
	sw $s7 36($zero)
	addi $s7 $zero 8
	sw $s7 40($zero)
	addi $s7 $zero 3
	sw $s7 44($zero)
	addi $s7 $zero 134
	sw $s7 48($zero)
	addi $s7 $zero 33
	sw $s7 52($zero)
	addi $s7 $zero 6
	sw $s7 56($zero)
	addi $s7 $zero 14
	sw $s7 60(zero)
	lui $at 16384
	ori $t0 $at 20
	nop
	sll $s7 $s3 2
	lw $s7 0($s7)
	addi $s8 $zero 1
	sll $s8 $s8 8
	add $s7 $s8 $s7
	sw $s7 0($t0)
	sll $s7 $s4 2
	lw $s7 0($s7)
	addi $s8 $zero 2
	sll $s8 $s8 8
	add $s7 $s8 $s7
	sw $s7 0($t0)
	sll $s7 $s5 2
	lw $s7 0($s7)
	addi $s8 $zero 4
	sll $s8 $s8 8
	add $s7 $s8 $s7
	sw $s7 0($t0)
	sll $s7 $s6 2
	lw $s7 0($s7)
	addi $s8 $zero 8
	sll $s8 $s8 8
	add $s7 $s8 $s7
	sw $s7 0($t0)
	nop
	addi $sp $sp -8
	lw $at 0($sp)
	lw $t0 4($sp)
	addi $sp $zero 0
	nop
	ori $t5 $t5 2
	sw $t5 8($t7)
	jr $k0
Xp:
end:	add $v0 $v0 $zero
    lui $at 16384
	ori $at $at 24
	add $a2 $zero $at
	sw $v0 0($a2)
	sw $zero 8($a2)
	sw $v0 12(&t7)
end2:	j end2
