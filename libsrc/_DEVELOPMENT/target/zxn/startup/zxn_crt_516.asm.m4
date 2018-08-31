include(`z88dk.m4')

dnl############################################################
dnl##       ZXN_CRT_516.M4 - RAM MODEL DOTX COMMAND          ##
dnl############################################################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          zx spectrum esxdos extended dot command          ;;
;;       generated by target/zxn/startup/zxn_crt_516.m4      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GLOBAL SYMBOLS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "config_zxn_public.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT AND CLIB CONFIGURATION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "../crt_defaults.inc"
include "crt_config.inc"
include(`../crt_rules.inc')
include(`zxn_rules.inc')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SET UP MEMORY MODEL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include(`crt_memory_map.inc')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INSTANTIATE DRIVERS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifndef CRT_OTERM_FONT_4X8

   PUBLIC CRT_OTERM_FONT_4X8
   EXTERN _font_4x8_default
   defc CRT_OTERM_FONT_4X8 = _font_4x8_default

endif

include(`../clib_instantiate_begin.m4')

ifelse(eval(M4__CRT_INCLUDE_DRIVER_INSTANTIATION == 0), 1,
`
   include(`driver/terminal/zx_01_input_kbd_inkey.m4')dnl
   m4_zx_01_input_kbd_inkey(_stdin, __i_fcntl_fdstruct_1, CRT_ITERM_TERMINAL_FLAGS, M4__CRT_ITERM_EDIT_BUFFER_SIZE, CRT_ITERM_INKEY_DEBOUNCE, CRT_ITERM_INKEY_REPEAT_START, CRT_ITERM_INKEY_REPEAT_RATE)dnl

   include(`driver/terminal/zx_01_output_char_64.m4')dnl
   m4_zx_01_output_char_64(_stdout, CRT_OTERM_TERMINAL_FLAGS, 0, 0, CRT_OTERM_WINDOW_X*2, CRT_OTERM_WINDOW_WIDTH*2, CRT_OTERM_WINDOW_Y, CRT_OTERM_WINDOW_HEIGHT, 0, CRT_OTERM_FONT_4X8, CRT_OTERM_TEXT_COLOR, CRT_OTERM_TEXT_COLOR_MASK, CRT_OTERM_BACKGROUND_COLOR)dnl

   include(`../m4_file_dup.m4')dnl
   m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)dnl
',
`
   include(`crt_driver_instantiation.asm.m4')
')

include(`../clib_instantiate_end.m4')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STARTUP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION CODE

PUBLIC __Start, __Exit

EXTERN _main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__Start:

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; use full command line if nextos
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IF (__crt_enable_commandline_ex & 0x80) && (__NEXTOS_DOT_COMMAND || __NEXTOS_VERSION)
   
      ld l,c
      ld h,b
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; returning to basic
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   push iy
   exx
   push hl

   ld (__sp),sp

   ; hl' = command line

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; esxdos compliance
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IF __ESXDOS_VERSION

      ;; check for esxdos
      
      rst __ESX_RST_SYS
      defb __ESX_M_DOSVERSION

      ld hl,error_msg_esxdos
      jp nc, error_crt         ; if esxdos not present

   ENDIF
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; nextos compliance
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IF __NEXTOS_DOT_COMMAND || __NEXTOS_VERSION
   
      ;; check for nextos
      
      rst __ESX_RST_SYS
      defb __ESX_M_DOSVERSION

      ld hl,error_msg_nextos
      jp c, error_crt          ; if esxdos present

      IF __NEXTOS_DOT_COMMAND
      
         or a
         jp nz, error_crt      ; if nextos is in 48k mode
      
      ENDIF
      
      IF __NEXTOS_VERSION > 0

         ld hl,+(((__NEXTOS_VERSION / 1000) % 10) << 12) + (((__NEXTOS_VERSION / 100) % 10) << 8) + (((__NEXTOS_VERSION / 10) % 10) << 4) + (__NEXTOS_VERSION % 10)
         
         ex de,hl
         sbc hl,de

         ld hl,error_msg_nextos
         jp c, error_crt       ; if nextos version not met

      ENDIF
      
      ;; register basic error intercept
      
      EXTERN _esx_errh
      
      ld hl,__basic_error_intercept
      ld (_esx_errh),hl

      rst __ESX_RST_SYS
      defb __ESX_M_ERRH
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; core version check
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IF __CRT_CORE_VERSION
   
      ; check for emulator
      
      ld bc,__IO_NEXTREG_REG
      
      ld a,__REG_MACHINE_ID
      out (c),a
      
      inc b
      in a,(c)
      
      cp __RMI_EMULATORS
      jr z, core_pass
      
      ; check core version
      
      ld hl,error_msg_core_version
      dec b
      
      ld e,__REG_VERSION
      out (c),e
      
      inc b
      in e,(c)                 ; e = core version major minor
      
      ld a,+(((__CRT_CORE_VERSION / 100000) & 0xf) << 4) + (((__CRT_CORE_VERSION / 1000) % 100) & 0xf)
      
      cp e
      jr c, core_pass          ; if minimum < core version
      jp nz, error_crt         ; if minimum > core version
   
      ; core version = minimum
      
      dec b
      
      ld a,__REG_SUB_VERSION
      out (c),a
      
      inc b
      in a,(c)                 ; a = core sub version
      
      cp __CRT_CORE_VERSION % 1000
      jp c, error_crt          ; if core sub version < minimum

   core_pass:
   
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; load the rest of the dotx command
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   include "crt_load_esxdos_dotx.inc"

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; move stack to final position
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   include "../crt_init_sp.inc"

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; command line
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; hl' = command line
   
   IF __crt_enable_commandline >= 2

      exx

   ENDIF
   
   include "crt_cmdline_esxdos.inc"
   
   ; stack: argv/cmdline, argc/len
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; ram initialization
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; initialize data section

   include "../clib_init_data.inc"

   ; initialize bss section

   include "../clib_init_bss.inc"

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; interrupt mode
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; interrupt mode
   
   include "../crt_start_di.inc"

   include "../crt_set_interrupt_mode.inc"

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; main
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION code_crt_init          ; user and library initialization
SECTION code_crt_main

   include "../crt_start_ei.inc"

   ; call user program

IF __crt_enable_commandline >= 1

   pop bc                      ; bc = argc / length
   pop hl                      ; hl = argv / command line
   
   push hl
   push bc

ENDIF

   call _main                  ; hl = return status

   ; run exit stack

error_basic:

   IF __clib_exit_stack_size > 0
   
      EXTERN asm_exit
      jp asm_exit              ; exit function jumps to __Exit
   
   ENDIF

__Exit:

   push hl                     ; save return status
   
SECTION code_crt_exit          ; user and library cleanup
SECTION code_crt_return

   ; close files
   
   include "../clib_close.inc"

   ; return to basic

   pop hl

error_crt:

   ld sp,(__sp)
      
   exx
   pop hl
   exx
   pop iy

   include "../crt_exit_eidi.inc"
      
   ; If you exit with carry set and A<>0, the corresponding error code will be printed in BASIC.
   ; If carry set and A=0, HL should be pointing to a custom error message (with last char +$80 as END marker).
   ; If carry reset, exit cleanly to BASIC
      
   ld a,h
   or l
   ret z                       ; status == 0, no error
      
   scf
   ld a,l
      
   inc h
   dec h
      
   ret z                       ; status < 256, basic error code in status&0xff
      
   ld a,0                      ; status = & custom error message
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BASIC ERROR ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __NEXTOS_DOT_COMMAND || __NEXTOS_VERSION

   __basic_error_intercept:

      ; basic error has occurred during a rst $10 or rst $18
      ; must perform clean up
   
      ; enter :  a = basic error code - 1
      ;         de = return address to restart
      ;         (you can resume the program if you jump to this address)

      ld hl,error_msg_d_break
   
      cp __ERRB_D_BREAK_CONT_REPEATS - 1
      jp z, error_basic
   
      ld hl,__ESX_ENONSENSE
      jp error_basic

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; error messages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __CRT_CORE_VERSION

   error_msg_core_version:
   
      defm "Requires Core v"
      
      IF ((__CRT_CORE_VERSION / 1000000) % 10)
         defb (__CRT_CORE_VERSION / 1000000) % 10 + '0'
      ENDIF
      
         defb (__CRT_CORE_VERSION / 100000) % 10 + '0'
         defb '.'
      
      IF ((__CRT_CORE_VERSION / 10000) % 10)
         defb (__CRT_CORE_VERSION / 10000) % 10 + '0'
      ENDIF
      
         defb (__CRT_CORE_VERSION / 1000) % 10 + '0'
         defb '.'
      
      IF ((__CRT_CORE_VERSION / 100) % 10)
         defb (__CRT_CORE_VERSION / 100) % 10 + '0'
      ENDIF
      
      IF ((__CRT_CORE_VERSION / 100) % 10) || ((__CRT_CORE_VERSION / 10) % 10)
         defb (__CRT_CORE_VERSION / 10) % 10 + '0'
      ENDIF
      
      defb __CRT_CORE_VERSION % 10 + '0' + 0x80

ENDIF

IF __NEXTOS_DOT_COMMAND || __NEXTOS_VERSION

   IF __NEXTOS_VERSION > 0

      error_msg_nextos:
      
         IF __NEXTOS_DOT_COMMAND
         
            defm "Requires NextZXOS 128k "
         
         ELSE
         
            defm "Requires NextZXOS "
         
         ENDIF
      
         IF ((__NEXTOS_VERSION / 1000) % 10)
            defb (__NEXTOS_VERSION / 1000) % 10 + '0'
         ENDIF
      
         defb (__NEXTOS_VERSION / 100) % 10 + '0'
         defb '.'
         defb (__NEXTOS_VERSION / 10) % 10 + '0'
         defb __NEXTOS_VERSION % 10 + '0' + 0x80
   
   ELSE
   
      IF __NEXTOS_DOT_COMMAND
      
         error_msg_nextos:

            defm "Requires NextZXOS 128", 'k'+0x80
      
      ELSE
      
         error_msg_nextos:
         
            defm "Requires NextZXO", 'S'+0x80
      
      ENDIF

   ENDIF
   
   error_msg_d_break:

      defm "D BREAK - no repea", 't'+0x80

ENDIF

IF __ESXDOS_VERSION

   error_msg_esxdos:
   
      defm "Requires ESXDO", 'S' + 0x80

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RUNTIME VARS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__sp:             defw 0

include "../clib_variables.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CLIB STUBS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "../clib_stubs.inc"
