##################################################################
# The program performs insertion sort and statistical operations.
# Only $s registers have been used.
##################################################################

#######################
# Text Segment
#######################
.text
.globl main
main:
    jal interact

    li $v0, 10
    syscall
interact:
    addi $sp, $sp, -8
    sw $s0, 4($sp)
    sw $ra, ($sp)
    la $a0, display
    li $v0, 4
    syscall

    la $a0, displaya
    li $v0, 4
    syscall

    la $a0, displayb
    li $v0, 4
    syscall

    la $a0, displayc
    li $v0, 4
    syscall

    la $a0, displayd
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    sw $v0, opcode

    lw $s0, opcode
    beq $s0, 1, readArray
    beq $s0, 2, insertionSort
    beq $s0, 3, medianMode
    beq $s0, 4, cont
    
    cont:
        addi, $sp, $sp, 8
        jr $ra

readArray:
    # Get number of array elements
    la $a0, introString
    li $v0, 4
    syscall

    addi $sp, $sp, -24
    sw $ra, ($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)

    li $v0, 5
    syscall
    move $s0, $v0
    sw $s0, size

    sll	$s3, $s0, 2						

    # Create dynamic array
    move $a0, $s3
    li $v0, 9
    syscall
    sw $v0, array
    
    la $s1, array
    # Get the elements
    li $s4, 100
    for:
        li $v0, 5
        syscall
        bgt $v0, $zero, go1
        blt $v0, $zero, go3
        beq $v0, $zero, go3
        go1:
            blt $v0, $s4, go2
            bgt $v0, $s4, go3
            beq $v0, $s4, go3
        go2:
            move $s2, $v0
            sw $s2, ($s1)
            addi $s1, $s1, 4
            addi $s0, $s0, -1
        go3:
            bgt $s0, $zero, for

    lw $s1, size # length
    la $s2, array
    forPrint3:
        lw $a0, ($s2)
        li $v0, 1
        syscall

        la $a0, tab
        li $v0, 4
        syscall

        addi $s2, $s2, 4
        addi $s1, $s1, -1
        bgt $s1, $zero, forPrint3

    la $a0, endLine
    li $v0, 4
    syscall
    addi $sp, $sp, 24

    j main

insertionSort:
    addi $sp, $sp, -28

    li $s0, 1 # i
    lw $s2, size # length
    la $s3, array
    la $s6, array
    while:
        move $s1, $s0 # j

        move $s3, $s6
        move $t6, $s1
        addi $s3, $s3, -4

        for2:
            addi $s3, $s3, 4
            addi $t6, $t6, -1
            bgt $t6, 0, for2

        lw $s4, ($s3) # load 0th index value
        lw $s5, 4($s3) # load 1st index value

        sw $s0, ($sp)
        sw $s1, 4($sp)
        sw $s2, 8($sp)
        sw $s3, 12($sp)
        sw $s4, 16($sp)
        sw $s5, 20($sp)
        sw $s6, 24($sp)

        blt $s1, 1, cont3 
        bgt $s1, 0, cont2
        while2:
            move $a0, $s1
            jal swap

            # Restore saved registers
            lw $s0, ($sp)
            lw $s1, 4($sp)
            lw $s2, 8($sp)
            lw $s3, 12($sp)
            lw $s4, 16($sp)
            lw $s5, 20($sp)
            lw $s6, 24($sp)

            addi $s1, $s1, -1 # decrement j
            addi $s3, $s3, -4 # get next index values
            lw $s4, ($s3)
            lw $s5, 4($s3)

            sw $s0, ($sp)
            sw $s1, 4($sp)
            sw $s2, 8($sp)
            sw $s3, 12($sp)
            sw $s4, 16($sp)
            sw $s5, 20($sp)
            sw $s6, 24($sp)

            blt $s1, 1, cont3 # j greater than 0 
            cont2:
                bgt $s4, $s5, while2 # prev value greater than next value
            cont3:
        
        

        addi $s0, $s0, 1 # increment i
        blt $s0, $s2, while # i less than length go to while

    lw $s2, size # length
    la $s3, array
    forPrint2:
        lw $a0, ($s3)
        li $v0, 1
        syscall

        la $a0, tab
        li $v0, 4
        syscall

        addi $s3, $s3, 4
        addi $s2, $s2, -1
        bgt $s2, $zero, forPrint2

    la $a0, endLine
    li $v0, 4
    syscall

    addi $sp, $sp, 28
    j main

swap:
    la $s2, array
    #swap	
    li $s0, 0
    li $s1, 0
    li $s3, 0
    addi $s3, $a0, -1
    move	$s0, $s3
	move	$s1, $a0
	sll	$s0, $s0, 2  	# $t0= 4 * $t0
	sll	$s1, $s1, 2  	# $t1= 4 * $t1
	add	$s0, $s0, $s2	# $t0 points to the array element at index1
	add	$s1, $s1, $s2	# $t1 points to the array element at index2
    # Perform swap.
	lw	$s4, 0($s0)
	lw	$s5, 0($s1)	
	sw	$s4, 0($s1)
	sw	$s5, 0($s0)

    jr $ra

medianMode:
    # Median
    lw $s0, size
    la $s2, array
    # if size is odd then add
    li $s3, 2
    div		$s0, $s3			# $t0 / $t1
    mflo    $s4
    mfhi	$s0					# $t3 = $t0 mod $t1 

    beq $s0, 0, adder
    bne $s0, 0, cont4
    adder:
        sll $s4, $s4, 2
        li $s5, 0
        addi $s5, $s4, -4
        add $s4, $s4, $s2
        add $s5, $s5, $s2
        lw $s5, ($s5)
        lw $s4, ($s4)

        
        add $s5, $s5, $s4

        li $s4, 2
        div		$s5, $s4			# $s5 / $t1
        mflo	$s5				# $t2 = floor($s5 / $t1) 
        
        lw $s0, size
        move $a0, $s5
        li $v0, 1
        syscall

        j getGo
    cont4:  
        lw $s0, size
    
    srl $s0, $s0, 1
    sll $s0, $s0, 2
    add $s0, $s0, $s2

    lw $s1, ($s0)
    move $a0, $s1
    li $v0, 1
    syscall

    getGo:
    la $a0, endLine
    li $v0, 4
    syscall

    # Mode
    lw $s0, size
    la $s2, array
    # reg for number of times repeated
    li $s3, 0

    # reg for number repeated 
    lw $s4, ($s2)

    # counter
    li $s7, 0

    # Two values ahead

    forStat:
        lw $s5, ($s2)
        lw $s6, 4($s2) 
        beq $s5, $s6, go
        bne $s5, $s6, forget
        go:
            addi $s7, $s7, 1
            bgt $s7, $s3, check1
            beq $s7, $s3, check2
            j cont5
            check1:
                move $s4, $s5
                move $s3, $s7
                j cont5
            check2:
                blt $s5, $s4, check3
                j cont5
                check3:
                    move $s4, $s5
                    j cont5
                
        forget:
            li $s7, 0
        cont5: 
        addi $s2, $s2, 4
        addi $s0, $s0, -1
        bgt $s0, $zero, forStat

    move $a0, $s4
    li $v0, 1
    syscall

    la $a0, endLine
    li $v0, 4
    syscall


    j main

#######################
# Data Segment
#######################
    .data
.align 2
array: .space 1024
size: .word 0
opcode: .word 0
endLine: .asciiz "\n"
tab: .asciiz "\t"
display: .asciiz "Choose an option:\n" 
displaya: .asciiz "1 - Read an array\n" 
displayb: .asciiz "2 - Insertion Sort\n" 
displayc: .asciiz "3 - Find Median and Mode\n" 
displayd: .asciiz "4 - Quit\n" 
introString: .asciiz "Enter array size (Max. 256 elements):\n" 
elementString: .asciiz "Enter array elements:\n" 