// cf. src/low/x64-asm-4l/macro.s
/*
 * RELIC is an Efficient LIbrary for Cryptography
 * Copyright (c) 2021 RELIC Authors
 *
 * This file is part of RELIC. RELIC is legal property of its developers,
 * whose names are not listed here. Please refer to the COPYRIGHT file
 * for contact information.
 *
 * RELIC is free software; you can redistribute it and/or modify it under the
 * terms of the version 2.1 (or later) of the GNU Lesser General Public License
 * as published by the Free Software Foundation; or version 2.0 of the Apache
 * License as published by the Apache Software Foundation. See the LICENSE files
 * for more details.
 *
 * RELIC is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE. See the LICENSE files for more details.
 *
 * You should have received a copy of the GNU Lesser General Public or the
 * Apache License along with RELIC. If not, see <https://www.gnu.org/licenses/>
 * or <https://www.apache.org/licenses/>.
 */

#include "relic_fp_low.h"

/**
 * @file
 *
 * Implementation of low-level prime field multiplication.
 *
 * @ingroup fp
 */

#if FP_PRIME == 254

#define P0 0xA700000000000013
#define P1 0x6121000000000013
#define P2 0xBA344D8000000008
#define P3 0x2523648240000001
#define U0 0x08435E50D79435E5

#elif FP_PRIME == 255

#define P0 0xFFFFFFFFFFFFFFED
#define P1 0xFFFFFFFFFFFFFFFF
#define P2 0xFFFFFFFFFFFFFFFF
#define P3 0x7FFFFFFFFFFFFFFF
#define U0 0x86BCA1AF286BCA1B

#endif

#define NP40 0xC000000000000000
#define NP41 0xE9C0000000000004
#define NP42 0x1848400000000004
#define NP43 0x6E8D136000000002
#define NP44 0x0948D92090000000

#define NP20 0x8000000000000000         // N*p/2
#define NP21 0xD380000000000009
#define NP22 0x3090800000000009
#define NP23 0xDD1A26C000000004
#define NP24 0x1291B24120000000
