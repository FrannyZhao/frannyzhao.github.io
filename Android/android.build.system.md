
[TOC]

#### **与其他build system的比较**
----------
- 不像linux kernel那样，有一个顶层的makefile会递归地调用子目录的makefiles。
Android build system用脚本搜索所有的文件夹，直到找到Android.mk文件，并停止继续搜索这个Android.mk文件所在的目录的子目录，除非该Android.mk文件有写`include $(call all-subdir-makefiles)`或者`include $(LOCAL_PATH)/xxx/Android.mk`之类的。

[ ] Why??? Read "Recursive Make Considered Harmful" and build/core/buildsystem.html // TODO

One Android.mk == One module
一个Android.mk对应一个编译模块
一共有多少Android.mk呢？在Android 6.0上：
```
$ find . -name Android.mk | wc -l
2646
```
- .o等编译中间文件和.c等源文件不在同一个目录下，所有编译生成的文件都在out目录下。
- 不像linux kernel那样可以配置的选项非常多，android能配置的只有：envsetup.sh, lunch, buildspec.mk
[ ] 想配置enable, disable某个模块 // TODO

#### **架构**
----------
![image](https://raw.githubusercontent.com/FrannyZhao/FrannyZhao.github.io/master/Android/pic/architecture.png)


  ● Sequence of load vendor make file
  1. . build/envsetup.sh
including vendor/marvell/uplus_tvg2/vendorsetup.sh
  2. lunch uplus_tvg2-eng
include vendor/marvell/uplus_tvg2/AndroidProducts.mk
include vendor/marvell/uplus_tvg2/uplus_tvg2.mk
include vendor/marvell/uplus_tvg2/BoardConfig.mk
  3. make
include vendor/marvell/uplus_tvg2/AndroidBoard.mk

> Written with [StackEdit](https://stackedit.io/).