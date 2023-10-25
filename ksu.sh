git fetch https://github.com/aosp-clhex/kernel_xiaomi_vayu t-r-ksu
git cherry-pick fd68667d8733b6c2b5e4dbbe34d77ff159a0618d
git submodule init
git submodule update --remote --merge
sed -i 's/vayu_defconfig/vayu_ksu_defconfig/g' build.sh
sed -i 's/Rectilia/Rectilia-KSU/g' build.sh
bash b