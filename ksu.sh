git fetch https://github.com/aosp-clhex/kernel_xiaomi_vayu ksu
git cherry-pick d24fd4077dbf5cdc1922ac540a8b5a2a93b19fce
git submodule init
git submodule update --remote --merge
sed -i 's/vayu_defconfig/vayu_ksu_defconfig/g' build.sh
sed -i 's/Rectilia/Rectilia-KSU/g' build.sh
bash build.sh