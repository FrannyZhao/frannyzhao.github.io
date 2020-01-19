更新bootable/recovery:

make installclean && make recovery && make -j16 && make otapackage -j16





* 烧板子：

选择Format All + Download

* 第二次make otapackage之前 rm -rf out/target/product/tb8735ap1_lr_ztk/obj/PACKAGING/target_files_intermediates/*

* 差分包制作：

./build/tools/releasetools/ota_from_target_files -s ./vendor/mediatek/proprietary/scripts/releasetools/mt_ota_from_target_files.py -i ~/ota/old/old.zip ~/ota/new/new.zip update.zip

* 启动本地升级的apk:

adb push update.zip /sdcard/

am start com.zelustek.usbupgrade/.MainActivity

点击开始升级按钮