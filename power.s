.text #constants assembly directive

formatString: .asciz "%lu %lu" #format string for C func
printString: .asciz "Base: %lu Exponent: %lu \n" #format string for C func
outputString: .asciz "%lu" #format string for C func

.global main # Add main label to symbol table for OS to know where to start

main:
    #Prologue
    pushq %rbp #pushing base pointer to stack
    movq %rsp, %rbp #copy stack pointer value to base pointer
    #print
    movq $0, %rax # 0 vector registers
    movq $string, %rdi #load 1st argument
    call printf

    #get input
    subq $16, %rsp #Reserve Space for inputs and 16 byte aligned

    movq $0, %rax # 0 vector registers
    movq $formatString, %rdi #load format string into scanf 
    leaq -8(%rbp), %rsi #load stack address for input 1 to RSI
    leaq -16(%rbp), %rdx # load stack address for input 2 to RSI
    call scanf #call scan func
    movq -8(%rbp), %rdi #store base
    movq -16(%rbp), %rsi #store exponent


    /* movq $0, %rax #0 vector registers
    movq $printString, %rdi #Format string
    movq -8(%rbp), %rsi #Input base into string
    movq -16(%rbp), %rdx #Input exponent into string
    call printf #call print func */

    call pow #call pow func

    movq %rax, %rsi  #second input printf, output pow
    movq $0, %rax #0 vector regiters
    movq $outputString, %rdi #first input printf, format string
    call printf #call print func

    jmp end #jump end function

pow:
    #Prologue
    pushq %rbp 
    movq %rsp, %rbp
    movq $0, %rcx #move temp value for loop comparisons to r12
    movq $1, %rax #default value
    loop:
        cmpq %rsi, %rcx #compare temp  to exponent 
        jl ifcode #if condition
        
        elsecode: 
            #Epilogue
            movq %rbp, %rsp 
            popq %rbp
            ret #return to main
        ifcode:
            incq %rcx #increment temp variable
            mulq %rdi #multiply with rax
            jmp loop #iterate

end:
    movq $0, %rdi # Add error code 0 to rdi register as argument to exit func
    call exit # Finish program



