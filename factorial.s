.text #constants assembly directive
formatString: .asciz "%lu" #format string for C func
printString: .asciz "%lu\n" #Format string printf func

.global main # Add main label to symbol table for OS to know where to start

main:
    #Prologue
    pushq %rbp #pushing base pointer to stack
    movq %rsp, %rbp #copy stack pointer value to base pointer

    #get input
    subq $16, %rsp #Reserve space

    movq $0, %rax # 0 vector registers
    movq $formatString, %rdi #load format string into scanf 
    leaq -8(%rbp), %rsi #load stack address for input 1 to RSI
    call scanf #call scan func
    movq -8(%rbp), %rdi #store input into RDI


    #Recursion
    movq $1, %rax #This is the answer variable, will be modified by the factorial fuc
    call factorial #call factorial function
    
    movq $printString, %rdi #Use format string as first argument to printf
    movq %rax, %rsi #Second argument printf, answer stored in RAX
    movq $0, %rax #0 vector registers
    call printf #call printf function


    jmp end #end program

factorial:
    #prologue
    pushq %rbp
    movq %rsp, %rbp
    
    #Test base case
    cmpq $1, %rdi #See if n == 1
    jle ifcode #jump to if condition
    #Else block (first to run)
    elsecode: 
        mulq %rdi #multiply n (RDI) variable with answer var (RAX)
        decq %rdi #Decrese n value
        call factorial #Recurse
        #Epilogue 
        movq %rbp, %rsp
        popq %rbp
        ret #return function
    #Base case, return final value
    ifcode:
        #Epilogue
        movq %rbp, %rsp
        popq %rbp
        ret

end:
    movq $0, %rdi # Add error code 0 to rdi register as argument to exit func
    call exit # Finish program



