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
	addi $a0 $zero 125
	nop
	addi $a1 $zero 40
	addi $s0 $zero 1
	j gcd
Inter:
Xp:
end:	add $v0 $v0 $zero

