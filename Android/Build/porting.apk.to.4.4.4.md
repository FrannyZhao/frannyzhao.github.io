



## 问题：

MoosLauncher.apk是在android studio中开发的，放到aosp 7.1.2以及8.1.0上都可以编过：

```makefile
file Android.mk: 
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := MoosLauncher
LOCAL_MODULE_TAGS := optional
LOCAL_DEX_PREOPT:= false
LOCAL_SRC_FILES := launcher3/build/MoosLauncher.apk
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_CLASS := APPS
include $(BUILD_PREBUILT)
```

但是放到aosp 4.4.4上出现了报错，out/host/linux-x86/bin/zipalign无法对此apk进行优化：

target Prebuilt APK: MoosLauncher (out/target/product/rk312x/obj/APPS/MoosLauncher_intermediates/MoosLauncher.apk)
**out/host/linux-x86/bin/zipalign** -f 4 packages/apps/MoosLauncher/launcher3/build/MoosLauncher.apk out/target/product/rk312x/obj/APPS/MoosLauncher_intermediates/MoosLauncher.apk
build/core/prebuilt.mk:151: recipe for target 'out/target/product/rk312x/obj/APPS/MoosLauncher_intermediates/MoosLauncher.apk' failed
make: * * * [out/target/product/rk312x/obj/APPS/MoosLauncher_intermediates/MoosLauncher.apk] Error 1
make: * * * Deleting file 'out/target/product/rk312x/obj/APPS/MoosLauncher_intermediates/MoosLauncher.apk'

// todo zipalign 作用：优化apk res文件，对齐，运行速度加快

## 解决办法：

* 安卓4.4.4版本上弃用Android.mk，改用PRODUCT_COPY_FILES += packages/apps/MoosLauncher/launcher3/build/MoosLauncher.apk:system/priv-app/MoosLauncher.apk

* 修改build/core/Makefile中的error为warning:

```makefile
define check-product-copy-files
$(if $(filter %.apk, $(1)),$(error \
    Prebuilt apk found in PRODUCT_COPY_FILES: $(1), use BUILD_PREBUILT instead!))
endef
```

改成

```makefile
define check-product-copy-files
$(if $(filter %.apk, $(1)),$(warning \
    Prebuilt apk found in PRODUCT_COPY_FILES: $(1), use BUILD_PREBUILT instead!))
endef
```



