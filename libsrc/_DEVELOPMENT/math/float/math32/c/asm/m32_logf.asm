;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.9.1 #11310 (Linux)
;--------------------------------------------------------
; Processed by Z88DK
;--------------------------------------------------------
	
	EXTERN __divschar
	EXTERN __divschar_callee
	EXTERN __divsint
	EXTERN __divsint_callee
	EXTERN __divslong
	EXTERN __divslong_callee
	EXTERN __divslonglong
	EXTERN __divslonglong_callee
	EXTERN __divsuchar
	EXTERN __divsuchar_callee
	EXTERN __divuchar
	EXTERN __divuchar_callee
	EXTERN __divuint
	EXTERN __divuint_callee
	EXTERN __divulong
	EXTERN __divulong_callee
	EXTERN __divulonglong
	EXTERN __divulonglong_callee
	EXTERN __divuschar
	EXTERN __divuschar_callee
	EXTERN __modschar
	EXTERN __modschar_callee
	EXTERN __modsint
	EXTERN __modsint_callee
	EXTERN __modslong
	EXTERN __modslong_callee
	EXTERN __modslonglong
	EXTERN __modslonglong_callee
	EXTERN __modsuchar
	EXTERN __modsuchar_callee
	EXTERN __moduchar
	EXTERN __moduchar_callee
	EXTERN __moduint
	EXTERN __moduint_callee
	EXTERN __modulong
	EXTERN __modulong_callee
	EXTERN __modulonglong
	EXTERN __modulonglong_callee
	EXTERN __moduschar
	EXTERN __moduschar_callee
	EXTERN __mulint
	EXTERN __mulint_callee
	EXTERN __mullong
	EXTERN __mullong_callee
	EXTERN __mullonglong
	EXTERN __mullonglong_callee
	EXTERN __mulschar
	EXTERN __mulschar_callee
	EXTERN __mulsuchar
	EXTERN __mulsuchar_callee
	EXTERN __muluschar
	EXTERN __muluschar_callee
	EXTERN __rlslonglong
	EXTERN __rlslonglong_callee
	EXTERN __rlulonglong
	EXTERN __rlulonglong_callee
	EXTERN __rrslonglong
	EXTERN __rrslonglong_callee
	EXTERN __rrulonglong
	EXTERN __rrulonglong_callee
	EXTERN ___sdcc_call_hl
	EXTERN ___sdcc_call_iy
	EXTERN ___sdcc_enter_ix
	EXTERN _banked_call
	EXTERN _banked_ret
	EXTERN ___fs2schar
	EXTERN ___fs2schar_callee
	EXTERN ___fs2sint
	EXTERN ___fs2sint_callee
	EXTERN ___fs2slong
	EXTERN ___fs2slong_callee
	EXTERN ___fs2slonglong
	EXTERN ___fs2slonglong_callee
	EXTERN ___fs2uchar
	EXTERN ___fs2uchar_callee
	EXTERN ___fs2uint
	EXTERN ___fs2uint_callee
	EXTERN ___fs2ulong
	EXTERN ___fs2ulong_callee
	EXTERN ___fs2ulonglong
	EXTERN ___fs2ulonglong_callee
	EXTERN ___fsadd
	EXTERN ___fsadd_callee
	EXTERN ___fsdiv
	EXTERN ___fsdiv_callee
	EXTERN ___fseq
	EXTERN ___fseq_callee
	EXTERN ___fsgt
	EXTERN ___fsgt_callee
	EXTERN ___fslt
	EXTERN ___fslt_callee
	EXTERN ___fsmul
	EXTERN ___fsmul_callee
	EXTERN ___fsneq
	EXTERN ___fsneq_callee
	EXTERN ___fssub
	EXTERN ___fssub_callee
	EXTERN ___schar2fs
	EXTERN ___schar2fs_callee
	EXTERN ___sint2fs
	EXTERN ___sint2fs_callee
	EXTERN ___slong2fs
	EXTERN ___slong2fs_callee
	EXTERN ___slonglong2fs
	EXTERN ___slonglong2fs_callee
	EXTERN ___uchar2fs
	EXTERN ___uchar2fs_callee
	EXTERN ___uint2fs
	EXTERN ___uint2fs_callee
	EXTERN ___ulong2fs
	EXTERN ___ulong2fs_callee
	EXTERN ___ulonglong2fs
	EXTERN ___ulonglong2fs_callee
	EXTERN ____sdcc_2_copy_src_mhl_dst_deix
	EXTERN ____sdcc_2_copy_src_mhl_dst_bcix
	EXTERN ____sdcc_4_copy_src_mhl_dst_deix
	EXTERN ____sdcc_4_copy_src_mhl_dst_bcix
	EXTERN ____sdcc_4_copy_src_mhl_dst_mbc
	EXTERN ____sdcc_4_ldi_nosave_bc
	EXTERN ____sdcc_4_ldi_save_bc
	EXTERN ____sdcc_4_push_hlix
	EXTERN ____sdcc_4_push_mhl
	EXTERN ____sdcc_lib_setmem_hl
	EXTERN ____sdcc_ll_add_de_bc_hl
	EXTERN ____sdcc_ll_add_de_bc_hlix
	EXTERN ____sdcc_ll_add_de_hlix_bc
	EXTERN ____sdcc_ll_add_de_hlix_bcix
	EXTERN ____sdcc_ll_add_deix_bc_hl
	EXTERN ____sdcc_ll_add_deix_hlix
	EXTERN ____sdcc_ll_add_hlix_bc_deix
	EXTERN ____sdcc_ll_add_hlix_deix_bc
	EXTERN ____sdcc_ll_add_hlix_deix_bcix
	EXTERN ____sdcc_ll_asr_hlix_a
	EXTERN ____sdcc_ll_asr_mbc_a
	EXTERN ____sdcc_ll_copy_src_de_dst_hlix
	EXTERN ____sdcc_ll_copy_src_de_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_deix_dst_hl
	EXTERN ____sdcc_ll_copy_src_deix_dst_hlix
	EXTERN ____sdcc_ll_copy_src_deixm_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_desp_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_hl_dst_de
	EXTERN ____sdcc_ll_copy_src_hlsp_dst_de
	EXTERN ____sdcc_ll_copy_src_hlsp_dst_deixm
	EXTERN ____sdcc_ll_lsl_hlix_a
	EXTERN ____sdcc_ll_lsl_mbc_a
	EXTERN ____sdcc_ll_lsr_hlix_a
	EXTERN ____sdcc_ll_lsr_mbc_a
	EXTERN ____sdcc_ll_push_hlix
	EXTERN ____sdcc_ll_push_mhl
	EXTERN ____sdcc_ll_sub_de_bc_hl
	EXTERN ____sdcc_ll_sub_de_bc_hlix
	EXTERN ____sdcc_ll_sub_de_hlix_bc
	EXTERN ____sdcc_ll_sub_de_hlix_bcix
	EXTERN ____sdcc_ll_sub_deix_bc_hl
	EXTERN ____sdcc_ll_sub_deix_hlix
	EXTERN ____sdcc_ll_sub_hlix_bc_deix
	EXTERN ____sdcc_ll_sub_hlix_deix_bc
	EXTERN ____sdcc_ll_sub_hlix_deix_bcix
	EXTERN ____sdcc_load_debc_deix
	EXTERN ____sdcc_load_dehl_deix
	EXTERN ____sdcc_load_debc_mhl
	EXTERN ____sdcc_load_hlde_mhl
	EXTERN ____sdcc_store_dehl_bcix
	EXTERN ____sdcc_store_debc_hlix
	EXTERN ____sdcc_store_debc_mhl
	EXTERN ____sdcc_cpu_pop_ei
	EXTERN ____sdcc_cpu_pop_ei_jp
	EXTERN ____sdcc_cpu_push_di
	EXTERN ____sdcc_outi
	EXTERN ____sdcc_outi_128
	EXTERN ____sdcc_outi_256
	EXTERN ____sdcc_ldi
	EXTERN ____sdcc_ldi_128
	EXTERN ____sdcc_ldi_256
	EXTERN ____sdcc_4_copy_srcd_hlix_dst_deix
	EXTERN ____sdcc_4_and_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_or_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_xor_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_or_src_dehl_dst_bcix
	EXTERN ____sdcc_4_xor_src_dehl_dst_bcix
	EXTERN ____sdcc_4_and_src_dehl_dst_bcix
	EXTERN ____sdcc_4_xor_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_or_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_cpl_src_mhl_dst_debc
	EXTERN ____sdcc_4_xor_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_or_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_debc_hlix_dst_debc
	EXTERN ____sdcc_4_or_src_debc_hlix_dst_debc
	EXTERN ____sdcc_4_xor_src_debc_hlix_dst_debc

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	GLOBAL _m32_logf
;--------------------------------------------------------
; Externals used
;--------------------------------------------------------
	GLOBAL _m32_polyf
	GLOBAL _m32_hypotf
	GLOBAL _m32_ldexpf
	GLOBAL _m32_frexpf
	GLOBAL _m32_invsqrtf
	GLOBAL _m32_sqrtf
	GLOBAL _m32_invf
	GLOBAL _m32_sqrf
	GLOBAL _m32_div2f
	GLOBAL _m32_mul2f
	GLOBAL _m32_modff
	GLOBAL _m32_fmodf
	GLOBAL _m32_roundf
	GLOBAL _m32_floorf
	GLOBAL _m32_fabsf
	GLOBAL _m32_ceilf
	GLOBAL _m32_powf
	GLOBAL _m32_log10f
	GLOBAL _m32_log2f
	GLOBAL _m32_exp10f
	GLOBAL _m32_exp2f
	GLOBAL _m32_expf
	GLOBAL _m32_atanhf
	GLOBAL _m32_acoshf
	GLOBAL _m32_asinhf
	GLOBAL _m32_tanhf
	GLOBAL _m32_coshf
	GLOBAL _m32_sinhf
	GLOBAL _m32_atan2f
	GLOBAL _m32_atanf
	GLOBAL _m32_acosf
	GLOBAL _m32_asinf
	GLOBAL _m32_tanf
	GLOBAL _m32_cosf
	GLOBAL _m32_sinf
	GLOBAL _m32_coeff_logf
	GLOBAL __MAX_OPEN
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION bss_compiler
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	
IF 0
	
; .area _INITIALIZED removed by z88dk
	
	
ENDIF
	
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	SECTION IGNORE
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	SECTION code_crt_init
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	SECTION IGNORE
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION code_compiler
;	---------------------------------
; Function m32_logf
; ---------------------------------
_m32_logf:
	push	ix
	ld	ix,0
	add	ix,sp
	ld	c, l
	ld	b, h
	ld	hl, -18
	add	hl, sp
	ld	sp, hl
	ld	(ix-6),c
	ld	(ix-5),b
	ld	(ix-4),e
	ld	l, e
	ld	(ix-3),d
	ld	h,d
	push	hl
	ld	l,(ix-6)
	ld	h,(ix-5)
	push	hl
	ld	hl,0x0000
	push	hl
	push	hl
	call	___fslt_callee
	bit	0,l
	jr	NZ,l_m32_logf_00102
	ld	de,0xc2b1
	ld	hl,0x7218
	jp	l_m32_logf_00110
l_m32_logf_00102:
	ld	hl,16
	add	hl, sp
	push	hl
	ld	l,(ix-4)
	ld	h,(ix-3)
	push	hl
	ld	l,(ix-6)
	ld	h,(ix-5)
	push	hl
	call	_m32_frexpf
	push	hl
	ld	c,l
	ld	b,h
	push	de
	ld	hl,0x3f35
	push	hl
	ld	hl,0x04f3
	push	hl
	push	de
	push	bc
	call	___fslt_callee
	pop	de
	pop	bc
	ld	a,l
	or	a, a
	jr	Z,l_m32_logf_00104
	ld	l,(ix-2)
	ld	h,(ix-1)
	dec	hl
	ld	(ix-2),l
	ld	(ix-1),h
	ld	l, c
	ld	h, b
	call	_m32_mul2f
	ld	bc,0x3f80
	push	bc
	ld	bc,0x0000
	push	bc
	push	de
	push	hl
	call	___fssub_callee
	ld	(ix-18),l
	ld	(ix-17),h
	ld	(ix-16),e
	ld	(ix-15),d
	jr	l_m32_logf_00105
l_m32_logf_00104:
	ld	hl,0x3f80
	push	hl
	ld	hl,0x0000
	push	hl
	push	de
	push	bc
	call	___fssub_callee
	ld	(ix-18),l
	ld	(ix-17),h
	ld	(ix-16),e
	ld	(ix-15),d
l_m32_logf_00105:
	pop	bc
	pop	de
	push	de
	ld	l,c
	ld	h,b
	push	hl
	call	_m32_sqrf
	ld	(ix-14),l
	ld	(ix-13),h
	ld	(ix-12),e
	ld	(ix-11),d
	ld	hl,0x0009
	push	hl
	ld	hl,_m32_coeff_logf
	push	hl
	ld	l,(ix-16)
	ld	h,(ix-15)
	push	hl
	ld	l,(ix-18)
	ld	h,(ix-17)
	push	hl
	call	_m32_polyf
	ld	c, l
	ld	l,(ix-12)
	ld	b,h
	ld	h,(ix-11)
	push	hl
	ld	l,(ix-14)
	ld	h,(ix-13)
	push	hl
	push	de
	push	bc
	call	___fsmul_callee
	ld	(ix-10),l
	ld	(ix-9),h
	ld	(ix-8),e
	ld	(ix-7),d
	ld	a,(ix-1)
	or	a,(ix-2)
	jr	Z,l_m32_logf_00107
	ld	l,(ix-2)
	ld	h,(ix-1)
	push	hl
	call	___sint2fs_callee
	ld	(ix-6),l
	ld	(ix-5),h
	ld	(ix-4),e
	ld	l, e
	ld	(ix-3),d
	ld	h,d
	push	hl
	ld	l,(ix-6)
	ld	h,(ix-5)
	push	hl
	ld	hl,0xb95e
	push	hl
	ld	hl,0x8083
	push	hl
	call	___fsmul_callee
	push	de
	push	hl
	ld	l,(ix-8)
	ld	h,(ix-7)
	push	hl
	ld	l,(ix-10)
	ld	h,(ix-9)
	push	hl
	call	___fsadd_callee
	ld	(ix-10),l
	ld	(ix-9),h
	ld	(ix-8),e
	ld	(ix-7),d
l_m32_logf_00107:
	ld	e,(ix-12)
	ld	d,(ix-11)
	ld	l,(ix-14)
	ld	h,(ix-13)
	call	_m32_div2f
	push	de
	push	hl
	ld	l,(ix-8)
	ld	h,(ix-7)
	push	hl
	ld	l,(ix-10)
	ld	h,(ix-9)
	push	hl
	call	___fssub_callee
	push	de
	push	hl
	ld	l,(ix-16)
	ld	h,(ix-15)
	push	hl
	ld	l,(ix-18)
	ld	h,(ix-17)
	push	hl
	call	___fsadd_callee
	ld	a,(ix-1)
	ld	c,l
	ld	b,h
	or	a,(ix-2)
	jr	Z,l_m32_logf_00109
	push	bc
	push	de
	ld	l,(ix-4)
	ld	h,(ix-3)
	push	hl
	ld	l,(ix-6)
	ld	h,(ix-5)
	push	hl
	ld	hl,0x3f31
	push	hl
	ld	hl,0x8000
	push	hl
	call	___fsmul_callee
	ld	(ix-6),l
	ld	(ix-5),h
	ld	(ix-4),e
	ld	(ix-3),d
	pop	de
	pop	bc
	ld	l,(ix-4)
	ld	h,(ix-3)
	push	hl
	ld	l,(ix-6)
	ld	h,(ix-5)
	push	hl
	push	de
	push	bc
	call	___fsadd_callee
	ld	c, l
	ld	b, h
l_m32_logf_00109:
	ld	l, c
	ld	h, b
l_m32_logf_00110:
	ld	sp, ix
	pop	ix
	ret
	SECTION IGNORE
