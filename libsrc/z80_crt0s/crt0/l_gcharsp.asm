;       Z88 Small C+ Run time Library
;       l_gchar variant to be used sometimes by the peephole optimizer
;

XLIB l_gcharsp
.l_gcharsp
	add	hl,sp
	inc hl
	inc hl
	ld a,(hl)
	ld l,a
	sbc   a,a
	ld h,a
	ex	(sp),hl
	jp (hl)
