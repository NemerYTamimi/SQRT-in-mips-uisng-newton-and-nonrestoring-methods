.data
prompt0: .asciiz "Please choose algorith no.\n 1-Newton method \n2-simple_method \n3-non-restoring\n"
prompt1: .asciiz "Please enter the value of x to find sqrt(x):"
prompt2: .asciiz "The result is:"
prompt3: .asciiz "\nEnter 1 to restart or any key to end:"
error: .asciiz "YOUR CHOICE IS NOT SUPPORTED  :(  "
buffer: .space 4
.text 

#########################################
# choose algorithm to solve square root.
start:
printString0:  # welcome string 
	li $v0, 4 
	la $a0, prompt0
	syscall
readByte0:  # to choose method 
    	li $v0, 5
    	syscall
	move $3,$v0
	li $4,1
	li $5,2
	li $6,3
	beq  $3,$4,newton
	beq  $3,$5,sqrt
	beq  $3,$6,non_restoring
	jal error0
	j end
	

################################
# newton method
newton:
	jal  getNum
	move $2,$3
sqrt_loop:
    	move    $8, $2         	# save old x in $8
   	mul     $4, $2, $2     	# $4 = x^2
    	sub     $4, $4, $3     	# $4 = x^2 - D
    	add     $6, $2, $2     	# $6 = 2*x
    	div     $4, $4, $6     	# $4 = (x^2 - D) / (2*x)
    	sub     $2, $2, $4     	# $2 = x - (x^2 - D) / (2*x)
    	sub     $8, $8, $2     	# $8 = oldX - x
    	abs     $8, $8         	# $8 = | oldX - x |
    	bne 	$8,$0,sqrt_loop  	# oldX ?= x if no jmp to sqrt_loop
    	move	$3, $2         	#result = $3
    	subi	$3,$3,1		#floor(result)
	jal	result
	j	end
################################

non_restoring:
	jal getNum
	move $9,$3
	move $2, $0 #  return =0
	addi $8, $0, 1
	sll $8, $8, 6 # shift left bit reg by 8bits --- to be equal 0x40

sqr_bit:
	slt $10, $9, $8 # is num < bit reg
	beq $10, $0, sqr_loop

	srl $8, $8, 2 # shift bit reg by 2bits bit>>2
	j sqr_bit

sqr_loop:
	beq $8, $0,sqr_printResult

	add $11, $2, $8 # t3 = return + bit
	slt $10, $9, $11
	beq $10, $0, sqr_else

	srl $2, $2, 1 # return >> 1
	j sqr_end

sqr_else:
	sub $9, $9, $11 # x -= return + bit
	srl $2, $2, 1 # return >> 1
	add $2, $2, $8 # return + bit

sqr_end:
	srl $8, $8, 2 # bit >> 2
	j sqr_loop

sqr_printResult:
	move $3,$2
	jal result
	j end
#######################################
#here is an another algorithm instead of SRT Algorithm. (simple sqrt)
sqrt:
	jal getNum
	move $a0,$3
	jal simple_sqrt
	move $3,$v0
	jal result
	j end
#######################################
#------------------------------------------------------------------------------------------
# Subroutine:	simple_sqrt
# Usage:	v0 = sqrt(a0)
# Description:
# 	Takes a positive signed integer in $a0 and returns its integer square root
#	(i.e., the floor of its real square root) in $v0.
# Arguments:	$a0 - A positive signed integer to take the square root of.
# Result:	$v0 - The floor of the square root of the argument, as an integer.
# Side effects:	The previous contents of register $t0 are trashed.
# Local variables:	
#	$v0 - Number r currently being tested to see if it is the square root.
#	$t0 - Square of r.
#------------------------------------------------------------------------------------------
simple_sqrt:
	addi	$v0, $zero, 0			# r := 0
loop:	mul	$t0, $v0, $v0			# t0 := r*r
	bgt	$t0, $a0, end_simple_sqrt	# if (r*r > n) goto end
	addi	$v0, $v0, 1			# r := r + 1
	j	loop				# goto loop
end_simple_sqrt:	
	addi	$v0, $v0, -1			# r := r - 1
	jr	$ra				# return with r-1 in $v0

#######################################
getNum:

printString1:
	li $v0, 4
	la $a0, prompt1 
	syscall
readByte1:
    	li $v0, 5
    	syscall
	move $3,$v0
	xor $2,$2,$2
	xor $8,$8,$8
retrunFun:
	jr $ra
######################################
result:
	li $v0, 4
	la $a0, prompt2 
	syscall
    	move        $a0,$3	# print result
    	li          $v0,1
    	syscall
    	jr $ra
######################################
error0:
	li $v0, 4
	la $a0, error 
	syscall
	jr $ra
######################################
end:
	li $v0, 4
	la $a0, prompt3
	syscall
readByte:
    	li $v0, 5
    	syscall
	li $4,1
	beq  $v0,$4,start
	li      $v0,10		#end program
	syscall
######################################
