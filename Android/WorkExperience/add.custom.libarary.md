# Not accessible for namespace

参考https://www.jianshu.com/p/4be3d1dafbec

### 问题：

做图像对比需要在/system/lib下加入一个新的库libopencv_java4.so

在安卓低版本上没问题，在高版本上报了个错误：

System.err: java.lang.UnsatisfiedLinkError: dlopen failed: library "/system/lib/libopencv_java4.so"
    needed or dlopened by "/system/lib/libnativeloader.so" is not accessible for the namespace "classloader-namespace"

搜索了一下，原来是普通应用不能直接引用系统的一些so库了，只能直接引用public.libraries.txt文件中过滤的so库。这个网址有介绍怎么处理。
[https://source.android.com/devices/tech/config/namespaces_libraries](https://link.jianshu.com?t=https://source.android.com/devices/tech/config/namespaces_libraries)

### 解决：

```txt
diff --git a/rootdir/etc/public.libraries.android.txt b/rootdir/etc/public.libraries.android.txt
index 5482085..d65453d 100644
--- a/rootdir/etc/public.libraries.android.txt
+++ b/rootdir/etc/public.libraries.android.txt
@@ -23,3 +23,4 @@ libsync.so
 libvulkan.so
 libwebviewchromium_plat_support.so
 libz.so
+libopencv_java4.so

```

