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
Main:
	addi $a0 $zero 1073741852
	lw $a0 0($a0)
	nop
	addi $a1 $zero 1073741852
	lw Sa1 0($a1)
	addi $s0 $zero 1
	j gcd
Inter:
Xp:
end:	add $v0 $v0 $zero
    addi $a2 $zero 1073741848
	sw $v0 0($a2)
