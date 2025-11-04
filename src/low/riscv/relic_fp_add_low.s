/*
 * Copyright (c) 2025 Inter-University Research Institute Corporation Research
 *  Organization of Information and Systems(ROIS). All rights reserved.
 */
#include "relic_fp_low.h"
#include "macro.s"

/**
 * @file
 *
 * Implementation of the low-level prime field addition and subtraction
 * functions.
 *
 * @ingroup fp
 */

.text

.global fp_addn_low
.global fp_addm_low
.global fp_addd_low
.global fp_addc_low
.global fp_subm_low
.global fp_dbln_low
.global fp_dblm_low

/*
 *   Carry, A = A + B + Carry
 */
.macro ADDC A,B,C,T
	add	\A,\A,\B
	sltu	\T,\A,\B
	add	\A,\A,\C
	sltu	\C,\A,\C
	or	\C,\C,\T
.endm

/*
 *   Borrow(C), Z = A - B - Borrow(C)
 */
.macro SUBB Z,A,B,C
        sub     \Z,\A,\B
        sltu    \B,\A,\Z
        sub     \Z,\Z,\C
        sltu    \C,\A,\Z
        or      \C,\C,\B
.endm


/*
 * Function: fp_addn_low
 * Inputs: a0 = c, a1 = a, a2 = b
 * Output: a0
 */
fp_addn_low:
	ld	t1,0(a1)
	ld	t2,0(a2)
	add	t1,t1,t2
	sltu	t0,t1,t2
	sd	t1,0(a0)

	ld	t1,8(a1)
	ld	t2,8(a2)
	ADDC	t1,t2,t0,t4
	sd	t1,8(a0)

	ld	t1,16(a1)
	ld	t2,16(a2)
	ADDC	t1,t2,t0,t4
	sd	t1,16(a0)

	ld	t1,24(a1)
	ld	t2,24(a2)
	ADDC	t1,t2,t0,t4
	sd	t1,24(a0)

	mv	a0,t0
	ret

/*
 * Function: fp_addm_low
 * Inputs: a0 = c, a1 = a, a2 = b
 * Output: void
 */
fp_addm_low:
	ld	a4,0(a1)
	ld	t0,0(a2)
	add	a4,a4,t0
	sltu	t0,a4,t0

	ld	a5,8(a1)
	ld	t1,8(a2)
	ADDC	a5,t1,t0,t6

	ld	a6,16(a1)
	ld	t1,16(a2)
	ADDC	a6,t1,t0,t6

	ld	a7,24(a1)
	ld	t1,24(a2)
	ADDC	a7,t1,t0,t6

        li      t0,P0
        sub     t1,a4,t0
        sltu    t5,a4,t1

        li      t0,P1
	SUBB	t2,a5,t0,t5
#if 0
        sub     t2,a5,t0
        sltu    t6,a5,t2
        sub     t2,t2,t5
        sltu    t5,a5,t2
        or      t5,t5,t6
#endif
        li      t0,P2
        sub     t3,a6,t0
        sltu    t6,a6,t3
        sub     t3,t3,t5
        sltu    t5,a6,t3
        or      t5,t5,t6
        li      t0,P3
        sub     t4,a7,t0
        sltu    t6,a7,t4
        sub     t4,t4,t5
        sltu    t5,a7,t4
        or      t5,t5,t6

        beqz    t5,addm0
        sd      a4,0(a0)
        sd      a5,8(a0)
        sd      a6,16(a0)
        sd      a7,24(a0)
	ret
addm0:
        sd      t1,0(a0)
        sd      t2,8(a0)
        sd      t3,16(a0)
        sd      t4,24(a0)
	ret

/*
 * Function: fp_addd_low
 * Inputs: a0 = c, a1 = a, a2 = b
 * Output: a0
 */
fp_addd_low:
	ld	t1,0(a1)
	ld	t2,0(a2)
	add	t1,t1,t2
	sltu	t0,t1,t2
	sd	t1,0(a0)

	ld	t1,8(a1)
	ld	t2,8(a2)
	ADDC	t1,t2,t0,t4
	sd	t1,8(a0)

	ld	t1,16(a1)
	ld	t2,16(a2)
	ADDC	t1,t2,t0,t4
	sd	t1,16(a0)

	ld	t1,24(a1)
	ld	t2,24(a2)
	ADDC	t1,t2,t0,t4
	sd	t1,24(a0)

	ld	t1,32(a1)
	ld	t2,32(a2)
	ADDC	t1,t2,t0,t4
	sd	t1,32(a0)

	ld	t1,40(a1)
	ld	t2,40(a2)
	ADDC	t1,t2,t0,t4
	sd	t1,40(a0)

	ld	t1,48(a1)
	ld	t2,48(a2)
	ADDC	t1,t2,t0,t4
	sd	t1,48(a0)

	ld	t1,56(a1)
	ld	t2,56(a2)
	ADDC	t1,t2,t0,t4
	sd	t1,56(a0)

	mv	a0,t0
	ret

/*
 * Function: fp_addc_low
 * Inputs: a0 = c, a1 = a, a2 = b
 * Output: void
 */
fp_addc_low:
	ld	t1,0(a1)
	ld	t2,0(a2)
	add	t1,t1,t2
	sltu	t0,t1,t2
	sd	t1,0(a0)

	ld	t1,8(a1)
	ld	t2,8(a2)
	ADDC	t1,t2,t0,t4
	sd	t1,8(a0)

	ld	t1,16(a1)
	ld	t2,16(a2)
	ADDC	t1,t2,t0,t4
	sd	t1,16(a0)

	ld	t1,24(a1)
	ld	t2,24(a2)
	ADDC	t1,t2,t0,t4
	sd	t1,24(a0)

	ld	a4,32(a1)
	ld	t2,32(a2)
	ADDC	a4,t2,t0,t4

	ld	a5,40(a1)
	ld	t2,40(a2)
	ADDC	a5,t2,t0,t4

	ld	a6,48(a1)
	ld	t2,48(a2)
	ADDC	a6,t2,t0,t4

	ld	a7,56(a1)
	ld	t2,56(a2)
	ADDC	a7,t2,t0,t4

        li      t0,P0
        sub     t1,a4,t0
        sltu    t5,a4,t1
        li      t0,P1
        sub     t2,a5,t0
        sltu    t6,a5,t2
        sub     t2,t2,t5
        sltu    t5,a5,t2
        or      t5,t5,t6
        li      t0,P2
        sub     t3,a6,t0
        sltu    t6,a6,t3
        sub     t3,t3,t5
        sltu    t5,a6,t3
        or      t5,t5,t6
        li      t0,P3
        sub     t4,a7,t0
        sltu    t6,a7,t4
        sub     t4,t4,t5
        sltu    t5,a7,t4
        or      t5,t5,t6

        beqz    t5,addc0
        sd      a4,32(a0)
        sd      a5,40(a0)
        sd      a6,48(a0)
        sd      a7,56(a0)
	ret
addc0:
        sd      t1,32(a0)
        sd      t2,40(a0)
        sd      t3,48(a0)
        sd      t4,56(a0)
	ret

/*
 * Function: fp_subm_low
 * Inputs: a0 = c, a1 = a, a2 = b
 * Output: void
 */
fp_subm_low:
	ld	t4,0(a1)
	ld	t5,0(a2)
	sub	a4,t4,t5
	sltu	t6,t4,a4

	ld	t4,8(a1)
	ld	t5,8(a2)
	SUBB	a5,t4,t5,t6

	ld	t4,16(a1)
	ld	t5,16(a2)
	SUBB	a6,t4,t5,t6

	ld	t4,24(a1)
	ld	t5,24(a2)
	SUBB	a7,t4,t5,t6

        li      t0,P0
        li      t1,P1
        li      t2,P2
        li      t3,P3
	beqz	t6,subm0

	add	a4,a4,t0
	sltu	t0,a4,t0
	ADDC	a5,t1,t0,t4
	ADDC	a6,t2,t0,t4
	ADDC	a7,t3,t0,t4
	sd	a4,0(a0)
	sd	a5,8(a0)
	sd	a6,16(a0)
	sd	a7,24(a0)
	ret
subm0:
	add	a4,a4,zero
	sltu	t0,a4,zero
	ADDC	a5,zero,t0,t4
	ADDC	a6,zero,t0,t4
	ADDC	a7,zero,t0,t4
	sd	a4,0(a0)
	sd	a5,8(a0)
	sd	a6,16(a0)
	sd	a7,24(a0)
	ret

.macro DBLC Z,A,C,T
	add	\Z,\A,\A
	sltu	\T,\Z,\A
	add	\Z,\Z,\C
	sltu	\C,\Z,\A
	or	\C,\C,\T
.endm

fp_dbln_low:
	ld	t0,0(a1)
	add	a4,t0,t0
	sltu	t1,a4,t0
	
	ld	t0,8(a1)
	DBLC	a5,t0,t1,t2

	ld	t0,16(a1)
	DBLC	a6,t0,t1,t2

	ld	t0,24(a1)
	add	a7,t0,t0
	sltu	t2,a7,t0
	add	a7,a7,t1
	sltu	t1,a7,t0

	sd	a4,0(a0)
	sd	a5,8(a0)
	sd	a6,16(a0)
	sd	a7,24(a0)

	or	a0,t1,t2

	ret

fp_dblm_low:
	ld	t0,0(a1)
	add	a4,t0,t0
	sltu	t1,a4,t0
	
	ld	t0,8(a1)
	DBLC	a5,t0,t1,t2

	ld	t0,16(a1)
	DBLC	a6,t0,t1,t2

	ld	t0,24(a1)
	add	a7,t0,t0
	add	a7,a7,t1

        li      t0,P0
        sub     t1,a4,t0
        sltu    t5,a4,t1
        li      t0,P1
        sub     t2,a5,t0
        sltu    t6,a5,t2
        sub     t2,t2,t5
        sltu    t5,a5,t2
        or      t5,t5,t6
        li      t0,P2
        sub     t3,a6,t0
        sltu    t6,a6,t3
        sub     t3,t3,t5
        sltu    t5,a6,t3
        or      t5,t5,t6
        li      t0,P3
        sub     t4,a7,t0
        sltu    t6,a7,t4
        sub     t4,t4,t5
        sltu    t5,a7,t4
        or      t5,t5,t6

        beqz    t5,dblm0
        sd      a4,0(a0)
        sd      a5,8(a0)
        sd      a6,16(a0)
        sd      a7,24(a0)
	ret
dblm0:
        sd      t1,0(a0)
        sd      t2,8(a0)
        sd      t3,16(a0)
        sd      t4,24(a0)
	ret
