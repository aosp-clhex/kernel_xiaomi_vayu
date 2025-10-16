#!/bin/bash
set -e

# --- basic setup ---
kernel_dir="${PWD}"
objdir="${kernel_dir}/out"
anykernel="$HOME/anykernel"
builddir="${kernel_dir}/build"
mkdir -p "$objdir" "$builddir"

# --- compiler detection ---
if command -v clang >/dev/null 2>&1; then
  export PATH="$(dirname "$(command -v clang)"):$PATH"
  echo "==> Using clang from: $(command -v clang)"
else
  echo "Error: clang not found in PATH!"
  exit 1
fi

# --- environment vars ---
export ARCH=arm64
export SUBARCH=arm64
export CC="clang"
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
export LLVM=1
export LLVM_IAS=1
export KBUILD_BUILD_USER="meel"
export KBUILD_BUILD_HOST="github"

# --- build start ---
echo "==> Starting kernel build..."
make O="$objdir" vayu_defconfig
make -j"$(nproc)" O="$objdir"

# --- packaging ---
KIMG=""
if [[ -f ${objdir}/arch/arm64/boot/Image ]]; then
  KIMG="${objdir}/arch/arm64/boot/Image"
elif [[ -f ${objdir}/arch/arm64/boot/Image.gz ]]; then
  echo "Decompressing Image.gz..."
  gunzip -c ${objdir}/arch/arm64/boot/Image.gz > ${objdir}/arch/arm64/boot/Image
  KIMG="${objdir}/arch/arm64/boot/Image"
fi

if [[ -z "$KIMG" ]]; then
  echo "Error: Kernel Image not found!"
  exit 1
fi

mkdir -p "$anykernel"
cp -f "$KIMG" "$anykernel"/Image

if [[ -f ${objdir}/arch/arm64/boot/dtbo.img ]]; then
  cp -f ${objdir}/arch/arm64/boot/dtbo.img "$anykernel"/dtbo.img
  echo "==> Added dtbo.img"
else
  echo "==> dtbo.img not found, skipping"
fi

cd "$anykernel"

# --- zip naming ---
zipname="Rectilia_Vayu_$(date +%Y%m%d-%H%M).zip"
zip -r9 "$zipname" ./*

mv -f "$zipname" /workspace/"$zipname" 2>/dev/null || mv -f "$zipname" "$kernel_dir"/
echo "==> Build done: $zipname"
