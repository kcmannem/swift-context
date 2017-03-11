#define ASM_HEADER \
    .text

#define EXPORTED_FUNCTION(_Name) \
    .cfi_startproc ; \
    .globl _Name ; \
    .align 16 ; \
    _Name:

#define END_FUNCTION \
    .cfi_endproc
