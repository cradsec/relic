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
.global fp_sqrn_low

/*
 * (R2, R1, R0) = (R2, R1, R0) + A * A
 */

.macro	SQR_ADD_1 R2,R1,R0,TH,TL,A
	mulhu	\TH,\A,\A
	mul	\TL,\A,\A
	add	\R0,\R0,\TL
	sltu	\TL,\R0,\TL
	add	\TH,\TH,\TL
	add	\R1,\R1,\TH
	sltu	\TL,\R1,\TH
	add	\R2,\R2,\TL
.endm

/*
 * (R2, R1, R0) = (R1, R0) + A * B  + A * B
 */
.macro	SQR_ADD_2 R2,R1,R0,T0,TH,TL,A,B
	mulhu	\TH,\A,\B
	mul	\TL,\A,\B
	add	\R0,\R0,\TL
	sltu	\T0,\R0,\TL
	add	\R1,\R1,\T0
	sltu	\R2,\R1,\T0
	add	\R0,\R0,\TL
	sltu	\TL,\R0,\TL
	add	\R1,\R1,\TH
	sltu	\T0,\R1,\TH
	add	\R2,\R2,\T0
	add	\TH,\TH,\TL
	add	\R1,\R1,\TH
	sltu	\T0,\R1,\TH
	add	\R2,\R2,\T0
.endm

/*
 * (R2, R1, R0) = (R2,R1, R0) + A * B  + A * B
 */
.macro	SQR_ADD_3 R2,R1,R0,T0,TH,TL,A,B
	mulhu	\TH,\A,\B
	mul	\TL,\A,\B
	add	\R0,\R0,\TL
	sltu	\T0,\R0,\TL
	add	\R1,\R1,\T0
	sltu	\T0,\R1,\T0
	add	\R2,\R2,\T0
	add	\R0,\R0,\TL
	sltu	\TL,\R0,\TL
	add	\R1,\R1,\TH
	sltu	\T0,\R1,\TH
	add	\R2,\R2,\T0
	add	\TH,\TH,\TL
	add	\R1,\R1,\TH
	sltu	\T0,\R1,\TH
	add	\R2,\R2,\T0
.endm


/*
 * Function: fp_addn_low
 * Inputs: a0 = c, a1 = a
 * Output: void
 */

fp_sqrn_low:
	ld	a4,0(a1)
	mulhu	t1,a4,a4
	mul	t0,a4,a4
	sd	t0,0(a0)

	ld	a5,8(a1)
	mulhu	t6,a4,a5
	mul	t5,a4,a5
	add	t1,t1,t5
	sltu	t2,t1,t5
	add	t2,t2,t6
	add	t1,t1,t5
	sltu	t5,t1,t5
	add	t6,t6,t5
	add	t2,t2,t6
	sltu	t3,t2,t6
	sd	t1,8(a0)

	ld	a6,16(a1)
	SQR_ADD_2 t0,t3,t2,t4,t6,t5,a4,a6
	SQR_ADD_1 t0,t3,t2,t6,t5,a5
	sd	t2,16(a0)

	ld	a7,24(a1)
	SQR_ADD_2 t1,t0,t3,t4,t6,t5,a4,a7
	SQR_ADD_3 t1,t0,t3,t4,t6,t5,a5,a6
	sd	t3,24(a0)

	SQR_ADD_2 t2,t1,t0,t4,t6,t5,a5,a7
	SQR_ADD_1 t2,t1,t0,t6,t5,a6
	sd	t0,32(a0)

	SQR_ADD_2 t3, t2,t1,t4,t6,t5,a6,a7
	sd	t1,40(a0)

	SQR_ADD_1 t0,t3,t2,t6,t5,a7
	sd	t2,48(a0)

	sd	t3,56(a0)
	
	ret
