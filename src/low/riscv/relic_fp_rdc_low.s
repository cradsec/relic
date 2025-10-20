/*
 * Copyright (c) 2025 Inter-University Research Institute Corporation Research
 *  Organization of Information and Systems(ROIS). All rights reserved.
 */

/**
 * @file
 *
 * Implementation of low-level prime field modular reduction.
 *
 * @ingroup fp
 */
#include "macro.s"

.text
.global fp_rdcn_low

.macro  _MULU_ADD R1,R0,TH,TL,A,B
	mulhu	\TH,\A,\B
	mul	\TL,\A,\B
	add	\R0,\R0,\TL
	sltu	\TL,\R0,\TL
	add	\TH,\TH,\TL
	add	\R1,\R1,\TH
.endm

/*
 * (R2, R1, R0) = (R1, R0) + A * B
 */
.macro  MULU_ADD_2R_CR R2,R1,R0,TH,TL,A,B
	_MULU_ADD \R1,\R0,\TH,\TL,\A,\B
	sltu	\R2,\R1,\TH
.endm

/*
 * (R2, R1, R0) = (R2,R1, R0) + A * B
 */
.macro  MULU_ADD_3R R2,R1,R0,TH,TL,A,B
	_MULU_ADD \R1,\R0,\TH,\TL,\A,\B
	sltu	\TH,\R1,\TH
	add	\R2,\R2,\TH
.endm

/*
 * (R2, R1,R0) = (R1, R0) + A * B + C
 */
.macro MULU_ADD_2R_C R2,R1,R0,TH,TL,A,B,C

	mulhu	\TH,\A,\B
	mul	\TL,\A,\B
	add	\R0,\R0,\TL
	sltu	\TL,\R0,\TL
	add	\TH,\TH,\TL
	add	\R1,\R1,\TH
	sltu	\TH,\R1,\TH
	add	\R2,\R2,\TH
	add	\R0,\R0,\C
	sltu	\TL,\R0,\C
	add	\R1,\R1,\TL
	sltu	\R2,\R1,\TL
.endm

fp_rdcn_low:
	/*
	 * Function: fp_addn_low
	* Inputs: a0 = c, a1 = a
	* Output: void
	*
	 * P = Prime number
	 * R=2^64
	 * P * U0 = -1 mod R
	 * t = MR(T) = (T + ( T * U0 mod R) * P ) / R
	 * t = *c, T = *a
	 */
	li	a3,U0
	ld	t0,(a1)
	mul	t1,t0,a3

	li	a2,P0
	mulhu	a4,a2,t1
	mul	a7,a2,t1
	add	a7,a7,t0
	sltu	t0,a7,t0
	add	a4,a4,t0
	mv	a5,zero

	li	a2,P1
	ld	t0,8(a1)
	MULU_ADD_2R_C a6,a5,a4,t6,t5,a2,t1,t0
	mul	t2,a4,a3
	li	a2,P0
	MULU_ADD_3R a6,a5,a4,t6,t5,a2,t2

	li	a2,P2
	ld	t0,16(a1)
	MULU_ADD_2R_C a4,a6,a5,t6,t5,a2,t1,t0
	li	a2,P1
	MULU_ADD_3R a4,a6,a5,t6,t5,a2,t2
	mul	t3,a5,a3
	li	a2,P0
	MULU_ADD_3R a4,a6,a5,t6,t5,a2,t3

	li	a2,P3
	ld	t0,24(a1)
	MULU_ADD_2R_C a5,a4,a6,t6,t5,a2,t1,t0
	li	a2,P2
	MULU_ADD_3R a5,a4,a6,t6,t5,a2,t2
	li	a2,P1
	MULU_ADD_3R a5,a4,a6,t6,t5,a2,t3
	mul	t4,a6,a3
	li	a2,P0
	MULU_ADD_3R a5,a4,a6,t6,t5,a2,t4

	li	a2,P3
        ld      t0,32(a1)
	MULU_ADD_2R_C a6,a5,a4,t6,t5,a2,t2,t0
	li	a2,P2
	MULU_ADD_3R a6,a5,a4,t6,t5,a2,t3
	li	a2,P1
	MULU_ADD_3R a6,a5,a4,t6,t5,a2,t4

	li	a2,P3
	ld	t0,40(a1)
	MULU_ADD_2R_C a7,a6,a5,t6,t5,a2,t3,t0
	li	a2,P2
	MULU_ADD_3R a7,a6,a5,t6,t5,a2,t4

	li	a2,P3
	ld	t0,48(a1)
	MULU_ADD_2R_C t4,a7,a6,t6,t5,a2,t4,t0

	ld	t0,56(a1)
	add	a7,a7,t0

	li	t0,P0
	sub	t1,a4,t0
	sltu	t5,a4,t1
	li	t0,P1
	sub	t2,a5,t0
	sltu	t6,a5,t2
	sub	t2,t2,t5
	sltu	t5,a5,t2
	or	t5,t5,t6
	li	t0,P2
	sub	t3,a6,t0
	sltu	t6,a6,t3
	sub	t3,t3,t5
	sltu    t5,a6,t3
	or	t5,t5,t6
	li	t0,P3
	sub	t4,a7,t0
	sltu	t6,a7,t4
	sub	t4,t4,t5
	sltu	t5,a7,t4
	or	t5,t5,t6

	beqz	t5,rdcn0
	sd	a4,0(a0)
	sd	a5,8(a0)
	sd	a6,16(a0)
	sd	a7,24(a0)
	ret
rdcn0:
	sd	t1,0(a0)
	sd	t2,8(a0)
	sd	t3,16(a0)
	sd	t4,24(a0)
	ret
