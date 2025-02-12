

    SECTION code_graphics

    PUBLIC  pixeladdress_MODE2
    EXTERN  SCREEN_BASE


; Entry: h = y
;        l = x
; Exit: hl = addr
;        a = pixel offset
;        z = pixel @1000000
pixeladdress_MODE2:
    ld      a,l
    ld      l,h
    ld      h,0
    add     hl,hl	;x32
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    ld      c,a
    srl     c
    srl     c
    srl     c
    ld      b,+(SCREEN_BASE / 256)
    add     hl,bc
    and     7
    ret	
