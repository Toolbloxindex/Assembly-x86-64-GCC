.text
.include "helloWorld.s"
values: .asciz "%c"

.global main # add main to symbol table

# ************************************************************
# Subroutine: decode                                         *
# Description: decodes message as defined in Assignment 3    *
#   - 2 byte unknown                                         *
#   - 4 byte index                                           *
#   - 1 byte amount                                          *
#   - 1 byte character                                       *
# Parameters:                                                *
#   first: the address of the message to read                *
#   return: no return value                                  *
# ************************************************************
decode:
	# prologue
	pushq %rbp 			# push the base pointer (and align the stack)
	movq %rsp, %rbp		# copy stack pointer value to base pointer
	
	subq $16, %rsp #reserve 16 bytes of space for storage and stack aligment
	#NEXT INDEX
	movl 2(%rdi), %eax #offset of 2 from msb, store next index into eax
	movl %eax, -4(%rbp) # store  next index in stack
	#AMOUNT OF PRINTS
	movb 1(%rdi), %al #offset of 6 from msb, amount of prints
	movb %al, -8(%rbp) #store amount of prints in stack
	#CHAR
	movb 0(%rdi), %al #offset of 7 from msb, char
	movb %al, -16(%rbp) #store char in stack


	printloop:
	cmpb $0, -8(%rbp)
	jg	ifcode

	elsecode:
		#get new address
		movl -4(%rbp), %eax

		#Check next index, if 0 then stop.
		cmp $0, %eax
		je end

		movq $MESSAGE, %rcx
		leaq (%rcx, %rax, 8), %rdi #pass new address calculated adding index to base address to rdi as parameter to new call, rax value is multiplied by 8 since addresses are organized per 8 bytes
		call decode #recurse, calling next address
		#epilogue
		movq %rbp, %rsp		# clear local variables from stack
		popq %rbp # restore base pointer location 
		ret #return 
 
	ifcode:
		movq $0, %rax #0 vector registers 
		movq $values, %rdi #put in format string for print
		movzbq -16(%rbp), %rsi #Meanns mov 1 byte (the character) and extend zero bytes for for storage in quadword register

		call printf
	
		decb -8(%rbp) #Decrease amount of prints
		jmp printloop #loop it

main:
	pushq %rbp 			# push the base pointer (and align the stack)
	movq %rsp, %rbp		# copy stack pointer value to base pointer

	movq $MESSAGE, %rdi	# first parameter: address of the message
	movl $0, %esi   #First index for displacement calculation
	call decode		# call decode

end:
	movq %rbp, %rsp
	popq %rbp			# restore base pointer location 
	movq $0, %rdi		# load program exit code
	call exit			# exit the program
