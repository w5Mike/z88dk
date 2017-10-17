/*
 *      Small C+ Compiler
 *
 *      Perform a function call
 *
 *      $Id: callfunc.c,v 1.20 2016-07-08 06:57:04 dom Exp $
 */

#include "ccdefs.h"

/*
 * Local functions
 */

static int SetWatch(char* sym, int* isscanf);
static int SetMiniFunc(unsigned char* arg, uint32_t* format_option_ptr);
static Kind ForceArgs(Type *dest, Type *src);


/*
 *      Perform a function call
 *
 * called from heirb, this routine will either call
 *      the named function, or if the supplied ptr is
 *      zero, will call the contents of HL
 */

void callfunction(SYMBOL *ptr, Type *fnptr_call_type)
{
    int isscanf = 0;
    uint32_t format_option = 0;
    int nargs, vconst, expr, argnumber;
    double val;
    int watcharg; /* For watching printf etc */
    int minifunc = 0; /* Call cut down version */
    char preserve = NO; /* Preserve af when cleaningup */
    int   isconstarg[5];
    double constargval[5];
    FILE *tmpfiles[100];  // 100 arguments enough I guess */
    FILE *save_fps;
    int   i;
    int   save_fps_num;
    int   function_pointer_call = ptr == NULL ? YES : NO;
    int   savesp;
    enum symbol_flags builtin_flags = 0;
    char   *funcname = "(unknown)";
    Type   *functype = ptr ? ptr->ctype: fnptr_call_type;
       

    memset(tmpfiles, 0, sizeof(tmpfiles)); 
    nargs = 0;
    argnumber = 0;
    watcharg = minifunc = 0;
    blanks(); /* already saw open paren */

    if (ptr && (strcmp(ptr->name, "asm") == 0)) {
        /* We're calling asm("code") */
        doasmfunc(NO);
        return;
    }

    if (ptr ) {
        funcname = ptr->name;
        watcharg = SetWatch(funcname, &isscanf);
    }
    savesp = Zsp;
    while (ch() != ')') {
        char *before, *start;
        Type *type;
        if (endst()) {
            break;
        }
        argnumber++;
        tmpfiles[argnumber] = tmpfile();
        push_buffer_fp(tmpfiles[argnumber]);

        setstage(&before, &start);
        expr = expression(&vconst, &val, &type);
        if ( argnumber < 5 ) {
            isconstarg[argnumber] = vconst;
            constargval[argnumber] = val;
        }
        clearstage(before, start);  // Wipe out everything we did
        if ( vconst && expr == KIND_DOUBLE ) {
            decrement_double_ref_direct(val);
        }
        fprintf(tmpfiles[argnumber],";\n");
        pop_buffer_fp();

        if (cmatch(',') == 0)
            break;
    }
    needchar(')'); 
    Zsp = savesp;

  //  if ( ptr == NULL ) ptr = fnptr;

    if ( ptr != NULL ) {
        /* Check for some builtins */
        if ( strcmp(funcname, "__builtin_memset") == 0 ) {
            if ( argnumber == 3 && isconstarg[3] && constargval[3] > 0 && c_disable_builtins == 0  ) {
                /* We want at least the size to be constant */
                fclose(tmpfiles[3]);
                tmpfiles[3] = NULL;
                builtin_flags = SMALLC|FASTCALL;
                if ( isconstarg[2] ) {
                    fclose(tmpfiles[2]);
                    tmpfiles[2] = NULL;
                }
            } else {
                funcname = "memset";
            }
        } else if ( strcmp(funcname, "__builtin_memcpy") == 0 ) {
            if ( argnumber == 3 && isconstarg[3] && constargval[3] > 0  && c_disable_builtins == 0) {
                /* We want at least the size to be constant */
                fclose(tmpfiles[3]);
                tmpfiles[3] = NULL;
                builtin_flags = SMALLC|FASTCALL;    
                if ( isconstarg[2] ) {
                    fclose(tmpfiles[2]);
                    tmpfiles[2] = NULL;
                }
            } else {
                funcname = "memcpy";
            }  
        } else if ( strcmp(funcname, "__builtin_strcpy") == 0) {
            if ( argnumber == 2  && c_disable_builtins == 0 ) {
                builtin_flags = FASTCALL|SMALLC;
            } else {
                funcname = "strcpy";
            }
        } else if ( strcmp(funcname, "__builtin_strchr") == 0) {
            if ( argnumber == 2  && c_disable_builtins == 0) {
                builtin_flags = SMALLC|FASTCALL;
                if ( isconstarg[2] && constargval[2] ) {
                    fclose(tmpfiles[2]);
                    tmpfiles[2] = NULL;
                }
            } else {
                funcname = "strchr";
            }

        }
    }

    if ( ( (ptr == NULL && c_use_r2l_calling_convention == YES ) || (ptr && (functype->flags & SMALLC) == 0) ) && (builtin_flags & SMALLC) == 0)  {
        for ( i = 1; argnumber >= i ; argnumber--, i++) {
            FILE *tmp = tmpfiles[i];
            tmpfiles[i] = tmpfiles[argnumber];
            tmpfiles[argnumber] = tmp;
        }
    }
    argnumber = 0;

    /* Don't rewrite expressions whilst we are evaluating */
    save_fps_num = buffer_fps_num;
    save_fps = MALLOC(buffer_fps_num * sizeof(buffer_fps[0]));
    memcpy(save_fps, buffer_fps, save_fps_num * sizeof(buffer_fps[0]));
    buffer_fps_num = 0;
    while ( tmpfiles[argnumber+1] ) {
        Type *type;        
        argnumber++;
        rewind(tmpfiles[argnumber]);
        set_temporary_input(tmpfiles[argnumber]);

        if ( function_pointer_call ) zpush(); // Save function address
        /* ordinary call */
        expr = expression(&vconst, &val, &type);
        if (expr == KIND_CARRY) {
            zcarryconv();
            expr = KIND_INT;
            type = type_int;
        }
        if ( functype->oldstyle == 0 && argnumber <= array_len(functype->parameters)) {       
            int proto_argnumber;
            Type *prototype;
            if ( (functype->flags & SMALLC) == SMALLC)  {
                proto_argnumber = argnumber - 1;                
            } else {
                proto_argnumber = array_len(functype->parameters) - argnumber;                
            }
            prototype = array_get_byindex(functype->parameters, proto_argnumber);

            if ( prototype->kind != KIND_ELLIPSES && type->kind != prototype->kind ) {
                expr = ForceArgs(prototype, type);
            }
            // if ( (protoarg & ( SMALLC << 16)) !=  (packedArgumentType & (SMALLC << 16)) ) {
            //     warning(W_PARAM_CALLINGCONVENTION_MISMATCH, funcname, argnumber, "__smallc/__stdc");
            // }
            // if ( (protoarg & ( CALLEE << 16)) !=  (packedArgumentType & (CALLEE << 16)) ) {
            //     warning(W_PARAM_CALLINGCONVENTION_MISMATCH, funcname, argnumber, "__z88dk_callee");
            // }
        }
        if ( (function_pointer_call == 0 && (functype->flags & FASTCALL)) || 
            (tmpfiles[argnumber+1] == NULL && (builtin_flags & FASTCALL) == FASTCALL ) ) {
            /* fastcall of single expression OR the last argument of a builtin */

        } else {
            if (argnumber == watcharg) {
                if (ptr)
                    debug(DBG_ARG1, "Caughtarg!! %s", litq + (int)val + 1);
                minifunc = SetMiniFunc(litq + (int)val + 1, &format_option);
            }
            if ( function_pointer_call == 0 ) {
                if (expr == KIND_DOUBLE) {
                    dpush();
                    nargs += 6;
                } else if (expr == KIND_LONG || expr == KIND_CPTR) {
                    if (!(fnflags & FARPTR) && expr != KIND_LONG)
                        const2(0);
                    lpush();
                    nargs += 4;
                } else {
                    zpush();
                    nargs += 2;
                }
            } else {
                if (expr == KIND_LONG || expr == KIND_CPTR) {
                    swap(); /* MSW -> hl */
                    swapstk(); /* MSW -> stack, addr -> hl */
                    zpushde(); /* LSW -> stack, addr = hl */
                    nargs += 4;
                } else if (expr == KIND_DOUBLE) {
                    dpush_under(KIND_INT);
                    nargs += 6;
                    mainpop();
                } else {
                    /* If we've only got one 2 byte argment, don't swap the stack */
                    if ( tmpfiles[argnumber+1] != NULL  || nargs != 0) {
                        swapstk();
                    }
                    nargs += 2;
                }
            }
        }
        restore_input();
        fclose(tmpfiles[argnumber]);
    }
    memcpy(buffer_fps, save_fps, save_fps_num * sizeof(buffer_fps[0]));
    buffer_fps_num = save_fps_num ;
    FREENULL(save_fps);

 
  //  if (ptr && (ptr->prototyped != 0) && builtin_flags == 0 ) {
        // if ((ptr->prototyped > argnumber) && (ptr->args[1] != PKIND_VOID) && (ptr->args[1] != PKIND_ELLIPSES)) {
        //     warning(W_2FAFUNC);
        // } else if ((ptr->prototyped < argnumber) && (ptr->args[1] != PKIND_ELLIPSES)) {
        //     warning(W_2MAFUNC);
        // }
  //  }
    if (function_pointer_call == NO ) {
        /* Check to see if we have a variable number of arguments */
        if ( functype->hasva ) {
            if ( (functype->flags & SMALLC) == SMALLC ) {
                loadargc(nargs);
            }
        }
        if ( strcmp(funcname,"__builtin_strcpy") == 0) {
            gen_builtin_strcpy();
            nargs = 0;
            Zsp += 2;
        } else if ( strcmp(funcname,"__builtin_strchr") == 0) {
            gen_builtin_strchr(isconstarg[2] ? constargval[2] : -1);
            nargs = 0;
        } else if ( strcmp(funcname, "__builtin_memset") == 0 ) {
            gen_builtin_memset(isconstarg[2] ? constargval[2] : -1,  constargval[3]);
            nargs = 0;
        } else if ( strcmp(funcname, "__builtin_memcpy") == 0 ) {
            gen_builtin_memcpy(isconstarg[2] ? constargval[2] : -1,  constargval[3]);
            nargs = 0;
        } else if (watcharg || (ptr->flags & (SHARED|SHAREDC)) ) {
            if ((ptr->flags & (SHARED|SHAREDC) ) )
                preserve = YES;
            if (ptr->flags & SHAREDC)
                zclibcallop();
            else
                zcallop();
            if (isscanf) {
                scanf_format_option |= format_option;
            } else {
                printf_format_option |= format_option;
            }
            outname(funcname, dopref(ptr));
            if ((ptr->flags & SHARED) && c_useshared)
                outstr("_sl");
            else if (ptr->flags & SHAREDC)
                outstr("_rst");
            nl();
        } else {
            zcallop();
            outname(funcname, dopref(ptr)); nl();
        }
    } else {
        callstk(nargs);
    }
    /*
     *        Modify the stack after a function call
     *
     *        We should modify stack if:
     *        - __CALLEE__ isn't set
     *        - Function is __LIB__ even if c_compact_code is set
     *        - c_compact_code isn't set and __CALLEE__ isn't set
     */

    if ((functype->flags & CALLEE) || (c_compact_code && ptr == NULL) || (c_compact_code && ((functype->flags & LIBRARY) == 0))) {
        Zsp += nargs;
    } else {
        /* If we have a frame pointer then ix holds it */
#ifdef USEFRAME
        if (c_framepointer_is_ix != -1) {
            if (nargs)
                RestoreSP(preserve);
            Zsp += nargs;
        } else
#endif
            Zsp = modstk(Zsp + nargs, functype->return_type->kind != KIND_DOUBLE, preserve); /* clean up arguments - we know what type is MOOK */
    }
}

static int SetWatch(char* sym, int* type)
{
    *type = 0; // printf
    if (strcmp(sym, "printf") == 0)
        return 1;
    if (strcmp(sym, "printk") == 0)
        return 1;
    if (strcmp(sym, "fprintf") == 0)
        return 2;
    if (strcmp(sym, "sprintf") == 0)
        return 2;
    if (strcmp(sym, "vprintf") == 0)
        return 1;
    if (strcmp(sym, "vfprintf") == 0)
        return 2;
    if (strcmp(sym, "vsprintf") == 0)
        return 2;
    if (strcmp(sym, "snprintf") == 0)
        return 3;
    if (strcmp(sym, "vsnprintf") == 0)
        return 3;
    *type = 1; // scanf
    if (strcmp(sym, "scanf") == 0)
        return 1;
    if (strcmp(sym, "vscanf") == 0)
        return 1;
    if (strcmp(sym, "fscanf") == 0)
        return 2;
    if (strcmp(sym, "vfscanf") == 0)
        return 2;
    if (strcmp(sym, "sscanf") == 0)
        return 2;
    if (strcmp(sym, "vsscanf") == 0)
        return 2;
    return 0;
}

/*
 *      djm routine to force arguments to switch type
 */

static Kind ForceArgs(Type *dest, Type *src)
{
    // TODO: ARRAYS
    if ( dest->kind != KIND_PTR && dest->kind != KIND_CPTR) {
        if ( src->kind != KIND_PTR && src->kind != KIND_CPTR ) {
            // Variable to variable cast
            force( dest->kind, src->kind, dest->isunsigned, src->isunsigned, 0);
        } else {
            /* Converting pointer to integer */
            warning(W_PTRINT);
            force( dest->kind, src->kind == KIND_PTR ? KIND_INT : KIND_LONG, dest->isunsigned, 1, 0);
        }
    } else {
        if ( src->kind != KIND_PTR && src->kind != KIND_CPTR ) {
            // Converting number to pointer
        } else {
            // Pointer to pointer
        }
    }
    return dest->kind;
}
   
        /* Dealing with pointers.. a type mismatch!*/
        // if (((dtype != stype) && (dtype != KIND_VOID) && (stype != KIND_VOID) && (stype != KIND_CPTR)) || ((dtype == stype) && (margtag != functab))) {
        //     debug(DBG_ARG3, "dtype=%d stype=%d margtab=%d functag=%d", dtype, stype, margtag, functab);
        //     warning(W_PRELIM, currfn->name, lineno - fnstart);
        //     warning(W_PTRTYP);
        //     ExpandArgValue(dest, buffer, functab);
        //     warning(W_PTRTYP1, buffer);
        //     ExpandArgValue(src, buffer, margtag);
        //     warning(W_PTRTYP2, buffer);
        // } else if (dtype == stype && dident != sident && sident != FUNCTION) {
        //     warning(W_INTPTR);
        //     expr = KIND_INT;
        // }

struct printf_format_s {
    char fmt;
    char complex;
    uint32_t val;
    uint32_t lval;
} printf_formats[] = {
    { 'd', 1, 0x01, 0x1000 },
    { 'u', 1, 0x02, 0x2000 },
    { 'x', 2, 0x04, 0x4000 },
    { 'X', 2, 0x08, 0x8000 },
    { 'o', 2, 0x10, 0x10000 },
    { 'n', 2, 0x20, 0x20000 },
    { 'i', 2, 0x40, 0x40000 },
    { 'p', 2, 0x80, 0x80000 },
    { 'B', 2, 0x100, 0x100000 },
    { 's', 1, 0x200, 0x0 },
    { 'c', 1, 0x400, 0x0 },
    { 'a', 0, 0x400000, 0x0 },
    { 'A', 0, 0x800000, 0x0 },
    { 'e', 3, 0x1000000, 0x1000000 },
    { 'E', 3, 0x2000000, 0x2000000 },
    { 'f', 3, 0x4000000, 0x4000000 },
    { 'F', 3, 0x8000000, 0x8000000 },
    { 'g', 3, 0x10000000, 0x10000000 },
    { 'G', 3, 0x20000000, 0x20000000 },
    { 0, 0, 0, 0 }
};

static int SetMiniFunc(unsigned char* arg, uint32_t* format_option_ptr)
{
    char c;
    int complex, islong;
    uint32_t format_option = 0;
    struct printf_format_s* fmt;

    complex = 1; /* mini printf */
    while ((c = *arg++)) {
        if (c != '%')
            continue;

        if (*arg == '-' || *arg == '0' || *arg == '+' || *arg == ' ' || *arg == '*' || *arg == '.') {
            if (complex < 2)
                complex = 2; /* Switch to standard */
            format_option |= 0x40000000;
            while (!isalpha(*arg))
                arg++;
        } else if (isdigit(*arg)) {
            if (complex < 2)
                complex = 2; /* Switch to standard */
            format_option |= 0x40000000;
            while (isdigit(*arg) || *arg == '.') {
                arg++;
            }
        }

        islong = 0;
        if (*arg == 'l') {
            if (complex < 2)
                complex = 2;
            arg++;
            islong = 1;
        }
        fmt = &printf_formats[0];
        while (fmt->fmt) {
            if (fmt->fmt == *arg) {
                if (complex < fmt->complex)
                    complex = fmt->complex;
                format_option |= islong ? fmt->lval : fmt->val;
                break;
            }
            fmt++;
        }
    }
    *format_option_ptr = format_option;
    return (complex);
}
