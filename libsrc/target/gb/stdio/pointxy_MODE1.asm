
        SECTION	code_driver

        PUBLIC	generic_console_pointxy

        GLOBAL	vpeek_read_screen
        GLOBAL  screendollar_no_inverse_with_count
        GLOBAL  generic_console_font32

        INCLUDE "target/gb/def/gb_globals.def"


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_pointxy:
        ld      hl,sp + -8
        ld      sp,hl
        push    hl              ;Save buffer
        call    vpeek_read_screen
        ld      hl,generic_console_font32
        ld      a,(hl+)
        ld      h,(hl)
        ld      l,a
        ; Gameboy fonts are in GBDK format.
        ld      a,(hl+) ;Font type
        inc     hl      ;Skips to the start of encoding table if present
        and     3
        ld      de,128
        cp      FONT_128ENCODING
        jr      z,add_offset
        ld      de,0
        cp      FONT_NOENCODING
        jr      z,add_offset
        ld      d,1
add_offset:
        add     hl,de               ;Now points to the font set
        ld      b,32
        pop     de              ;Get the buffer back
        call    screendollar_no_inverse_with_count
        push    af
        pop     bc
        ld      hl,sp+8
        ld      sp,hl
        push    bc
        pop     af
        ret