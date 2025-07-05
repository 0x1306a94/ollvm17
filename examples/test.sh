#!/bin/bash

CURDIR=$(dirname "$0")

MLLVM_PLIGIN_LIB="$CURDIR/../build/llvm-project/llvm/lib/Passes/libObfuscation.dylib"
# MLLVM_ARGS=-mllvm -sobf -mllvm -split -mllvm -fla -mllvm -bcf
MLLVM_ARGS="\
-mllvm -fla \
-mllvm -bcf \
-mllvm -bcf_prob=80 \
-mllvm -bcf_loop=3 \
-mllvm -sobf \
-mllvm -icall \
-mllvm -ibr \
-mllvm -igv \
-mllvm -sub \
-mllvm -sub_loop=3 \
-mllvm -split \
-mllvm -split_num=5 \
"

$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang++ \
--target=aarch64-linux-android23 \
-x c \
-Xclang -load -Xclang $MLLVM_PLIGIN_LIB \
-fpass-plugin=$MLLVM_PLIGIN_LIB -shared -fPIC \
$MLLVM_ARGS \
-o $CURDIR/../build/test.so \
$CURDIR/test_ollvm.c