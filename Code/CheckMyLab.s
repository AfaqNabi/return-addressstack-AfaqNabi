.data
stackSpace:	.space 	1023
stack:		.byte 0
input:		.space	1024
noFileStr:	.asciz "Couldn't open specified file.\n"

.align 2

.text 

main:
lw	a0, 0(a1)	# Put the filename pointer into a0
li	a1, 0		# Flag: Read Only
li	a7, 1024	# Service: Open File
        		
ecall			# File descriptor gets saved in a0 unless an error happens
bltz	a0, main_err    # Negative means open failed
    
la	a1, input	# write into my binary space
li	a2, 2048        # read a file of at max 2kb
li	a7, 63          # Read File Syscall
ecall
    
la	a0, input	# supply pointers as arguments
la      a1, stack

jal	rsa	# call the student subroutine/jump to code under the label 'rsa'
j	main_done
    
main_err:
la	a0, noFileStr   # print error message in the event of an error when trying to read a file                       
li	a7, 4           # the number of a system call is specified in a7
ecall             	# Print string whose address is in a0
    
main_done:
   
li      a7, 10          # ecall 10 exits the program with code 0
ecall


.data
open:	.byte  0x28 # 0x28 is the hex ascii table value for open paren
close:	.byte  0x29 # 0x29 is the hex ascii table value for close paren
.text

#----------------------------------
#        STUDENT SOLUTION
#---------------------------------

# t3 is the adress of the base of the atring 
# a1 is the stack
rsa: # this function initializez the variables and brackets needed for the program
la	s2, open # store the open paren in s2
la	s3, close # store the close paren in s3
lbu	s2, 0(s2) # the "(" char (open)
lbu	s3, 0(s3) # the ")" char (close)

add	t3, zero, a0 # store a0 into t3 b/c a0 is required later for printing
lbu	t0, 0(t3) # stores the base of the string address in t0
beq	t0, s2, push # checks if the char is equal to to the open paren
beq	t0, s3, pop # checks if the char is equal to the close paren
j	loop # go to the main loop

loop: # this loops through the string 
addi	t3, t3, 1 # get the next char in the string 
lbu	t0, 0(t3) # stores the base of the string address in t0
beq	t0, s2, push # checks if the char is equal to to the open paren.
beq	t0, s3, pop # checks if the char is equal to the close paren.
beq	t0, zero, exit # branch for null char
j	loop # if no condtions are true keep running the loop


push: # push the character to be printed into the artificial stack
addi	a1, a1, -1 # increment the top of the stack to go down
addi	t3, t3, 1 # increment to the next char in str
lbu	t1, 0(t3) # stores current t3 into t1
sb	t1, 0(a1) # store the byte from t1 to a1
j	loop # go back the main loop


pop: #om the stack pop and print the charecter from the stack upon close parenthesis
lb	a0, 0(a1) # load the char to be printed into a0
li	a7, 11 # print char 11 is the code for printing
ecall # reads the code in a7 and does it 
addi	a1, a1, 1 # decrement the stack to go up
j	loop # go back to the main loop after popping

exit: # terminate program
jr	ra # terminate program