#!/bin/bash
#
# Copyright (C) 2024 Elias Dimopoulos
# SPDX-License-Identifier: Apache-2.0
#

# Terminal colors (To simulate log levels)
RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0m'

# Script variables
SCRIPT_DIR=$(pwd)/build
TC_DIR="$SCRIPT_DIR"/clang-r416183b
AK_DIR="$SCRIPT_DIR"/AnyKernel3
MAKE_ARGS="O=out ARCH=arm64 CC=clang LLVM=1 LLVM_IAS=1 CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-"

# Clone aosp clang from its repo
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_clang_kernel_linux-x86_clang-r416183b $TC_DIR

# Clone AnyKernel3 (TODO: Fix this for GKI and garnet)
git clone --depth=1 https://github.com/osm0sis/AnyKernel3 $AK_DIR

# Export the PATH variable
export PATH="$TC_DIR/bin:$PATH"

# Build defconfig
make -j"$(nproc --all)" $MAKE_ARGS garnet_defconfig

# Build kernel
make -j"$(nproc --all)" $MAKE_ARGS

# Zip the kernel and pack it into an AnyKernel3 zip
FILE="$(pwd)/out/arch/arm64/boot/Image.gz"
BUILD_TIME=$(date +"%d%m%Y-%H%M")
KERNEL_NAME="Kernel-"${BUILD_TIME}""
FILE_OUT=""$AK_DIR"/"$KERNEL_NAME".zip"

if [ -f "$FILE" ]; then
    echo -e "Build Script: ${GREEN}The kernel has successfully been compiled.${NOCOLOR}"
    rm -rf $AK_DIR/Image.gz $AK_DIR/*.zip $AK_DIR/*.ko
    cp $FILE $AK_DIR
    cd $AK_DIR
    zip -r9 "$KERNEL_NAME".zip ./*
    echo "Build Script: The kernel has been zipped and can be found in $FILE_OUT."
    exit 0
else
    echo -e "Build Script: ${RED}The kernel failed to compile. Check your compiler output for build errors.${NOCOLOR}"
    exit 1
fi
