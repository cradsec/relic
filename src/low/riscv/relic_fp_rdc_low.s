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

/*
 * (R3, R2, R1) = (R2, R1) + A * B + R3
 */
.macro  MULU_ADD R2,R1,R0,TH,TL,A,B

	mulhu	\TH,\A,\B
	mul	\TL,\A,\B
	add	\R0,\R0,\TL
	sltu	\TL,\R0,\TL
	add	\TH,\TH,\TL
	add	\R1,\R1,\TH
	sltu	\R2,\R1,\TH
.endm

/*
 * (R2, R1,R0) += A * B + (C, 0)
 */
.macro MULU_ADD_1 R2,R1,R0,TH,TL,A,B,C

	mulhu	\TH,\A,\B
	mul	\TL,\A,\B
	add	\R0,\R0,\TL
	sltu	\TL,\R0,\TL
	add	\TH,\TH,\TL
	add	\R1,\R1,\TH
	sltu	\TH,\R1,\TH
	add	\R2,\R2,\TH
	add	\R1,\R1,\C
	sltu	\TL,\R1,\C
	add	\R2,\R2,\TL
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
	mul	a4,a3,t0

	li	a2,P0
	mulhu	t3,a2,a4
	mul	t2,a2,a4
	add	t2,t2,t0
	sltu	t0,t2,t0
	add	t3,t3,t0

	li	a2,P1
	MULU_ADD t2,t1,t3,t6,t5,a2,a4
	mul	a5,t1,a3
	li	a2,P0
	ld	t0,8(a1)
	MULU_ADD_1 t2,t1,t3,t6,t5,a2,a5,t0

	li	a2,P2
	MULU_ADD t3,t2,t1,t6,t5,a2,a4
	li	a2,P1
	MULU_ADD t3,t2,t1,t6,t5,a2,a5
	mul	a6,t2,a3
	li	a2,P0
	ld	t0,16(a1)
	MULU_ADD_1 t3,t2,t1,t6,t5,a2,a6,t0

	li	a2,P3
	MULU_ADD t1,t3,t2,t6,t5,a2,a4
	li	a2,P2
	MULU_ADD t1,t3,t2,t6,t5,a2,a5
	li	a2,P1
	MULU_ADD t1,t3,t2,t6,t5,a2,a6
	mul	a7,t3,a3
	li	a2,P0
	ld	t0,24(a1)
	MULU_ADD_1 t1,t3,t2,t6,t5,a2,a7,t0

	li	a2,P3
        ld      t0,32(a1)
	MULU_ADD_1 t2,t1,t3,t6,t5,a2,a7,t0
	li	a2,P2
	MULU_ADD t2,t1,t3,t6,t5,a2,a6
	li	a2,P1
	MULU_ADD t2,t1,t3,t6,t5,a2,a7

	li	a2,P3
	ld	t0,40(a1)
	MULU_ADD_1 t3,t2,t1,t6,t5,a2,a7,t0
	li	a2,P2
	MULU_ADD t3,t2,t1,t6,t5,a2,a6

	li	a2,P3
	ld	t0,48(a1)
	MULU_ADD_1 t4,t3,t2,t6,t5,a2,a7,t0

	ld	t0,56(a1)
	add	t4,t4,t0

	li	t0,P0
	sub	a4,t1,t0
	sltu	t5,t1,a4
	li	t0,P1
	sub	a5,t2,t0
	sltu	t6,t2,a5
	sub	a5,a5,t5
	sltu	t5,t2,a5
	or	t5,t5,t6
	li	t0,P2
	sub	a6,t3,t0
	sltu	t6,t3,a6
	sub	a6,a6,t5
	sltu    t5,t3,a6
	or	t5,t5,t6
	li	t0,P3
	sub	a7,t4,t0
	sltu	t6,t4,a7
	sub	a7,a7,t5
	sltu	t5,t4,a7
	or	t5,t5,t6

	bnez	t5,rdcn0
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
