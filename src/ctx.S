#include "asmh.inc"

ASM_HEADER

#define OFFSET_RBX 8
#define OFFSET_RBP 16
#define OFFSET_R12 24
#define OFFSET_R13 32
#define OFFSET_R14 40
#define OFFSET_R15 48
#define OFFSET_RIP 56
#define OFFSET_RSP 64


# func _ctx_prepare(buffer: UnsafeMutableRawPointer,
#                   stack: UnsafeMutableRawPointer:
#                   running fn: ()->Void)
EXPORTED_FUNCTION(__ctx_prepare)
    # load stack ptr into rax
    movq    %rdi, %rax
    # move addr into lower word
    andq    $-16, %rax
    # store stack ptr, for newly heap alloced stack
    movq    %rsi, OFFSET_RSP(%rax)
    # store function ptr to run in this context
    movq    %rdx, OFFSET_RIP(%rax)
    # clear return value
    xorq    %rax, %rax
    ret
END_FUNCTION


# func _ctx_switch(from prevBuf: UnsafeMutableRawPointer, 
#                  to newBuf: UnsafeMutableRawPointer)
EXPORTED_FUNCTION(__ctx_switch)
	# save current context into ctx_buffer ptr in %rdi
	movq	%rbx, OFFSET_RBX(%rdi)
	movq	%rbp, OFFSET_RBP(%rdi)
	movq	%r12, OFFSET_R12(%rdi)
	movq	%r13, OFFSET_R13(%rdi)
	movq	%r14, OFFSET_R14(%rdi)
	movq	%r15, OFFSET_R15(%rdi)
    # top of the stack is the return address that called the switch
    # this will be the ip to restore to when you decide to switch back 
    movq    (%rsp), %rcx
    movq    %rcx, OFFSET_RIP(%rdi)
    # compute the rsp at the time this func was called
    # stack gets dec by 8 to store rip, before jumping into function
    # this is the "error" correction for that
    leaq    8(%rsp), %rcx
    movq    %rcx,   OFFSET_RSP(%rdi)  

    # load new stack ptr
	movq    OFFSET_RSP(%rsi), %rsp
    
    # load context to switch into
	movq	OFFSET_R15(%rsi), %r15
	movq	OFFSET_R14(%rsi), %r14
	movq	OFFSET_R13(%rsi), %r13
	movq	OFFSET_R12(%rsi), %r12
	movq	OFFSET_RBP(%rsi), %rbp
	movq	OFFSET_RBX(%rsi), %rbx

    # load back %rip 
    movq    OFFSET_RIP(%rsi), %r8
    # jmp to continue execution
	xorq     %rax, %rax
    jmp     *%r8
END_FUNCTION


# pushing and popping off a heap allocated stack is another way to do it, much simples
# and doesnt require seperate buffer space and stack space.
# this way is an alternative but is currently not being used
# func _ctx_switch(from oldBuf: UnsafeMutableRawPointer, to newBuf: UnsafeMutableRawPointer)
EXPORTED_FUNCTION(__ctx_switch_beta)
    movq    %rsp, %rax
    movq    %rdi, %rsp

    pushq   %rbx
    pushq   %rbp
    pushq   %r12
    pushq   %r13
    pushq   %r14
    pushq   %r15

    movq    %rsi, %rsp

    popq    %r15
    popq    %r14
    popq    %r13
    popq    %r12
    popq    %rbp
    popq    %rbx
END_FUNCTION
