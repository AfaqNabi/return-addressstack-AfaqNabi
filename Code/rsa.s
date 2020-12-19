#
# CMPUT 229 Student Submission License
# Version 1.0
#
# Copyright 2019 <Afaq Nabi>
#
# Redistribution is forbidden in all circumstances. Use of this
# software without explicit authorization from the author or CMPUT 229
# Teaching Staff is prohibited.
#
# This software was produced as a solution for an assignment in the course
# CMPUT 229 - Computer Organization and Architecture I at the University of
# Alberta, Canada. This solution is confidential and remains confidential 
# after it is submitted for grading.
#
# Copying any part of this solution without including this copyright notice
# is illegal.
#
# If any portion of this software is included in a solution submitted for
# grading at an educational institution, the submitter will be subject to
# the sanctions for plagiarism at that institution.
#
# If this software is found in any public website or public repository, the
# person finding it is kindly requested to immediately report, including 
# the URL or other repository locating information, to the following email
# address:
#
#          cmput229@ualberta.ca
#
#---------------------------------------------------------------
# CCID:                 nabi1@ualberta.ca
# Lecture Section:      A2
# Instructor:           J. Nelson Amaral
# Lab Section:          D06
# Teaching Assistant:   Quinn Phan
#---------------------------------------------------------------
# 


.include "common.s" # initializes the string to be processed
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















