/*
 * Copyright (c) 2025 Inter-University Research Institute Corporation Research
 *  Organization of Information and Systems(ROIS). All rights reserved.
 */
#include "relic_fp_low.h"

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
