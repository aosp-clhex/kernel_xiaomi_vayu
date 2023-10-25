echo "Fetching KSU Patch"
git fetch https://github.com/aosp-clhex/kernel_xiaomi_vayu ksu
echo "Applying KSU Patch"
git cherry-pick d24fd4077dbf5cdc1922ac540a8b5a2a93b19fce
git cherry-pick cb1b315cf8c2
git submodule init
git submodule update --remote --merge
echo "Renaming Kernel to Rectilia-KSU"
sed -i 's/Rectilia/Rectilia-KSU/g' arch/arm64/configs/vayu_defconfig
sed -i 's/Rectilia/Rectilia-KSU/g' build.sh
echo "Starting Build"
bash build.sh