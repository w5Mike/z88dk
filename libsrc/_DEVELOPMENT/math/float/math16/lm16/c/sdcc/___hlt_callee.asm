
    SECTION code_fp_math16

    PUBLIC ___hlt_callee
    PUBLIC _m16_isless_callee

    EXTERN cm16_sdcc___lt_callee

    defc ___hlt_callee = cm16_sdcc___lt_callee
    defc _m16_isless_callee = cm16_sdcc___lt_callee
