
; float __mul_callee (float left, float right)

SECTION code_clib
SECTION code_fp_am9511

PUBLIC _am9511_mul_callee
PUBLIC cam32_sdcc_mul_callee

EXTERN cam32_sdcc_readr_callee, asm_am9511_mul_callee

DEFC _am9511_mul_callee = cam32_sdcc_mul_callee

.cam32_sdcc_mul_callee

    ; multiply two sdcc floats
    ;
    ; enter : stack = sdcc_float right, sdcc_float left, ret
    ;
    ; exit  : DEHL = sdcc_float(left*right)
    ;
    ; uses  : af, bc, de, hl, af', bc', de', hl'

    call cam32_sdcc_readr_callee
    jp asm_am9511_mul_callee    ; enter stack = sdcc_float left, ret
                                ;        DEHL = sdcc_float right
                                ; return DEHL = sdcc_float
