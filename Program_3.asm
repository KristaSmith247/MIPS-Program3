# Author: Krista Smith
# Date: 10/27/23
# Description: The program will print assignment information, capture integer input,
#	and display a multiplication table.

# macros
.macro print_str(%info)
# print string
	li $v0, 4
	la $a0, %info
	syscall
.end_macro

.globl main, user_info, mult_table # Do not remove this line
# Data for the program goes here
.data
	#string constants
	info: .ascii "CS2810 MIPS Program 3\n"
	      .asciiz "Welcome to the multiplication table program\n"
	prompt0: .asciiz "Please enter your name: "
	prompt1: .asciiz "Up to what multiplication table do you want?\n"
	message: .asciiz "\nHello: "
	bye: .asciiz "\nBye."
	tab: .asciiz "\t"
	nl: .asciiz "\n"
	
	num: .word 0
	name: .space 80
	
	
# Code goes here
.text

# Program pseudocode: 
# print(info)
# print(prompt0)
# cin >> name
# print(name)
# print(prompt1)
# cin >> num
# print(table)
# # // Print Multiplication tables 1 to num
# for(i=1; i<num; i++)
#    for(j=1; j<num; j++)
#          print(i*j)
#          print("\t")
#     print("\n")
# print(bye)

###########
main:
	# Task 1: Call user_info procedure
	jal user_info

	# Task 2: Capture integer input
		
	print_str(prompt1) # print(prompt1)

	li $v0, 5 	# r = readInt()
	syscall
	sw $v0, num # move input into num
	
	li $v0, 4 # print newline
	la $a0, nl
	syscall
	
	# Task 3: Call mult_table procedure
	jal mult_table

exit_main:
	li $v0, 4 # print(bye)
	la $a0, bye
	syscall

	li $v0, 10 # 10 is the exit program syscall
	syscall # execute call

## end of ca.asm



###############################################################
# Display User information
#
# $a0 - input, None
# $a1 - input buffer
# $v0 - output, None
user_info:
	li $a1, 256 # set up input buffer
	
	# print(info)
	print_str(info)
	
	# print(prompt)
	print_str(prompt0)
	
	# name = readString()
	li $v0, 8	# read in a string
	la $a0, name	# store string in name
	syscall

	# print("hello" + name)
	print_str(message)
	print_str(name)

end_user_info:
	jr $ra
	
###############################################################
# Display Multiplication Table
#
# $a0 - input, None
# $v0 - output, None
# t0 - initialize table
# t1 - i (outer loop counter)
# t2 - j (inner loop counter)
# t3 - num
# t4 - i * j


# # Pseudocode for printing multiplication tables:
# // Print Multiplication tables 1 to num
# for(i=1; i<num; i++)
#    for(j=1; j<num; j++)
#          print(i*j)
#          print("\t")
#     print("\n")

mult_table:
######################## Begin Outer loop
	lw $t3, num # Load Word number 
	li $t0, 1 # Initialize beginning of multiplication table

	addi $t1, $t1, 1 # i = 1
	addi $t2, $t2, 1 # j = 1
	# start_loop_1:
	loop_1:
		# for (i = 1; i < num; i ++)
		bgt $t1, $t3 end_loop_1 # branch away from loop when i == num
			
			######################## Begin Inner loop
			# for (j = 1; j < num; j++)
			loop_2: # start_loop_2:
		
			bgt $t2, $t3, end_loop_2 # branch away when j == num
			
				mul $t4, $t1, $t2 # t4 = i * j
				
				li $v0, 1 # print i * j
				la $a0, ($t4) 
				syscall
			
				print_str(tab) # print space between numbers
			
				addi $t2, $t2, 1 # j += 1
				j loop_2 # jump back to inner loop
			
			end_loop_2: # end_loop_2:
		######################## End Inner loop
		addi $t1, $t1, 1 # increment i by 1
		print_str(nl)
		seq $t2, $t0, 1 # reset j = 1
		j loop_1
	# end_loop_1:
	end_loop_1:
######################## End Outer loop
end_mult_table:
	jr $ra
	
