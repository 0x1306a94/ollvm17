#!/bin/bash

CURDIR=$(dirname "$0")

# fla 放前面会crash
MLLVM_ARGS="-mllvm -sobf -mllvm -split -mllvm -fla -mllvm -bcf"
# MLLVM_ARGS="${MLLVM_ARGS} -mllvm -bcf_prob=80 -mllvm -bcf_loop=3"
$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang++ \
--target=aarch64-linux-android23 \
-x c \
-Xclang -load -Xclang libObfuscation.so \
-fpass-plugin=libObfuscation.so -shared -fPIC \
$MLLVM_ARGS \
-o $CURDIR/../build/test.so \
$CURDIR/test_ollvm.c