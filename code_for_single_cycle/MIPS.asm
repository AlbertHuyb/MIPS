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
	addi $s0 $zero 1
	j gcd
Inter:
Xp:
end:	add $v0 $v0 $zero
    lui $at 16384
	ori $at $at 24
	add $a2 $zero $at
	sw $v0 0($a2)
