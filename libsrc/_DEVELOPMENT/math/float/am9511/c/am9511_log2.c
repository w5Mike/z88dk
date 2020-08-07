/*  Base 2 logarithm
 *
 * SYNOPSIS:
 *
 * float x, y, log2();
 *
 * y = log2( x );
 *
 *
 * DESCRIPTION:
 *
 * Returns the base 2 logarithm of x.
 *
 */


#include "am9511_math.h"

float am9511_log2 (float x) __z88dk_fastcall
{
    if( x <= 0.0 )
    {
        return( HUGE_NEG_F32 );
    }

    return( am9511_log( x ) * M_INVLN2 );
}
