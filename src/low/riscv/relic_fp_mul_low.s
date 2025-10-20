/*
 * Copyright (c) 2025 Inter-University Research Institute Corporation Research
 *  Organization of Information and Systems(ROIS). All rights reserved.
 */

/**
 * @file
 *
 * Implementation of the low-level prime field multiplication functions.
 *
 * @ingroup fp
 */


.text
.global fp_muln_low

.macro  MULN_STEP C,R4,R3,R2,R1,R0, TH,TL, A, B3,B2,B1,B0
 	mulhu   \TH,\A,\B0
        mul     \TL,\A,\B0
        add     \R0,\R0,\TL
        sltu    \TL,\R0,\TL
	add	\TH,\TH,\TL
        add     \R1,\R1,\TH
        sltu    \TL,\R1,\TH
        add     \R2,\R2,\TL
        sltu    \TL,\R2,\TL
        add     \R3,\R3,\TL
	sltu	\R4,\R3,\TL
        sd      \R0, \C

        mulhu   \TH,\A,\B1
        mul     \TL,\A,\B1
        add     \R1,\R1,\TL
        sltu    \TL,\R1,\TL
	add	\TH,\TH,\TL
        add     \R2,\R2,\TH
        sltu    \TL,\R2,\TH
        add     \R3,\R3,\TL
        sltu    \TL,\R3,\TL
	add	\R4,\R4,\TL

        mulhu   \TH,\A,\B2
        mul     \TL,\A,\B2
        add     \R2,\R2,\TL
        sltu    \TL,\R2,\TL
	add	\TH,\TH,\TL
        add     \R3,\R3,\TH
        sltu    \TL,\R3,\TH
        add     \R4,\R4,\TL

        mulhu   \TH,\A,\B3
        mul     \TL,\A,\B3
        add     \R3,\R3,\TL
        sltu    \TL,\R3,\TL
	add	\TH,\TH,\TL
        add     \R4,\R4,\TH
.endm

/*
 * Function: fp_addn_low
 * Inputs: a0 = c, a1 = a, a2 = b
 * Output: void
 *                  t5 t4 t3 t2  *(a2)
 *   x              t1 t1 t1 t1  *(a1)
 *      a4 a3 a7 a6 a5 a4 a3 t0  *(a0)
 *
 */

fp_muln_low:
	ld	t1,0(a1)	// 0(a1) * 0(a2)
	ld	t2,0(a2)
	mulhu	a3,t1,t2
	mul	t0,t1,t2
	sd	t0,0(a0)

	ld	t3,8(a2)	// 0(a1) * 8(a2)
	mulhu	t6,t1,t3
	mul	t0,t1,t3
	add	a3,a3,t0
	sltu	a4,a3,t0
	add	a4,a4,t6

	ld	t4,16(a2)	// 0(a1) * 16(a2)
	mulhu	t6,t1,t4
	mul	t0,t1,t4
	add	a4,a4,t0
	sltu	a5,a4,t0
	add	a5,a5,t6

	ld	t5,24(a2)	// 0(a1) * 24(a2)
	mulhu	t6,t1,t5
	mul	t0,t1,t5
	add	a5,a5,t0
	sltu	a6,a5,t0
	add	a6,a6,t6

	ld	t1,8(a1)	// 8(a1) * a2
	MULN_STEP  8(a0),a7,a6,a5,a4,a3,t6,t0,t1,t5,t4,t3,t2

	ld	t1,16(a1)	// 16(a1) * a2
	MULN_STEP 16(a0),a3,a7,a6,a5,a4,t6,t0,t1,t5,t4,t3,t2

	ld	t1,24(a1)	// 24(a1) * a2
	MULN_STEP 24(a0),a4,a3,a7,a6,a5,t6,t0,t1,t5,t4,t3,t2

	sd	a6,32(a0)
	sd	a7,40(a0)
	sd	a3,48(a0)
	sd	a4,56(a0)

	ret

