#!/bin/sh
#
# cmake command based Makefile of OpenABE library.
#
COMP="-O2 -funroll-loops -fomit-frame-pointer -Wno-incompatible-pointer-types -Wno-unused-function -Wno-implicit-function-declaration -Wno-incompatible-pointer-types-discards-qualifiers" \
	cmake \
		-DCMAKE_C_COMPILER=/usr/bin/riscv64-linux-gnu-gcc \
		-DCMAKE_FIND_ROOT_PATH=/opt/riscv \
		-DGMP_ROOT=/opt/riscv/gmp \
		-DGMP_LIBRARIES=/opt/riscv/gmp/lib/libgmp.so \
		-DCMAKE_EXE_LINKER_FLAGS="-Wl,-rpath,/opt/riscv/gmp/lib" \
		-DOPSYS=LINUX -DARCH= \
		-DWITH="BN;DV;FP;FPX;EP;EPX;PP;PC;MD" -DCHECK=off -DVERBS=off \
		-DDEBUG=off -DMULTI=PTHREAD -DBENCH=0 -DTESTS=10 \
		-DARITH=riscv \
		-DFP_PRIME=254 -DBN_PRECI=254 \
		-DFP_QNRES=on \
		-DEP_METHD="PROJC;LWNAF;COMBS;INTER;SSWUM" \
		-DFP_METHD="BASIC;COMBA;COMBA;MONTY;JMPDS;JMPDS;SLIDE" \
		-DFPX_METHD="INTEG;INTEG;LAZYR" -DPP_METHD="LAZYR;OATEP" \
		-DSEED="UDEV" -DRAND="CALL" \
		$1
