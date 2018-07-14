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
	#为了测试，更改取数的地址
	#addi $a0 $zero 1073741852
	#lw $a0 0($a0)
	addi $a0 $zero 125
	nop
	#addi $a1 $zero 1073741852
	#lw $a1 0($a1)
	addi $a1 $zero 40
	addi $s0 $zero 1
	j gcd
Inter:
Xp:
end:	add $v0 $v0 $zero
    addi $a2 $zero 1073741848
	sw $v0 0($a2)
