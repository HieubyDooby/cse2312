.global main
.func main
   
main:

    BL  _divide

  _divide:
    BL  _prompt             @ branch to prompt procedure with return
    BL  _scanf              @ branch to scan procedure with return
    MOV R4, R0              @ store n in R4
    BL  _scanf              @ branch to scan procedure with return
    MOV R5, R0              @ store m in R5
    
    MOV R1, R4              @ load the numerator
    MOV R2, R5              @ load the denominator
    BL _printf_result
    VMOV S0, R0             @ move the numerator to floating point register
    VMOV S1, R1             @ move the denominator to floating point register
    VCVT.F32.U32 S0, S0     @ convert unsigned bit representation to single float
    VCVT.F32.U32 S1, S1     @ convert unsigned bit representation to single float
	
    VDIV.F32 S2, S0, S1     @ compute S2 = S0 * S1
    
    VCVT.F64.F32 D4, S2     @ covert the result to double precision for printing
    VMOV R1, R2, D4         @ split the double VFP register into two ARM registers
    BL _printf_result1

   _scanf:
    PUSH {LR}               @ store the return address
    PUSH {R1}               @ backup regsiter value
    LDR R0, =format_str     @ R0 contains address of format string
    SUB SP, SP, #4          @ make room on stack
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ remove value from stack
    POP {R1}                @ restore register value
    POP {PC}                @ restore the stack pointer and return

  _prompt:
    PUSH {LR}               @ push LR to stack
    LDR R0, =prompt_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ pop LR from stack and return

  _printf_result:
    PUSH {LR}               @ push LR to stack
    LDR R0, =format_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC} 

    _printf_result1:
      PUSH {LR}               @ push LR to stack
      LDR R0, =formatz_str     @ R0 contains formatted string address
      BL printf               @ call printf
      POP {PC}  

.data
result_str:     .asciz      "%d/%d = "
format_str:     .asciz      "%d"
formatz_str:    .asciz     " %f\n"
prompt_str:     .asciz      "Enter two numbers: \n"
exit_str:       .ascii      "Terminating program.\n"
