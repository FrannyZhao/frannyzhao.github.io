# JNI: Java Native Interface

**目的：java & c/c++可以互相调用对方的函数**

* 对java层屏蔽不同操作系统的差异
* native已经实现的功能可以直接用，避免重复造轮子
* native实现部分的运行效率和速度快

Java(MediaScanner) <--> JNI(libmedia**_jni**.so) <--> Native(libmedia.so)

```java
public class MediaScanner
{
    static {
        System.loadLibrary("media_jni"); // 根据不同平台扩展，linux下扩展为libmedia_jni.so, windows下扩展为media_jni.dll
        native_init();
    }
    ...
}
```

?? java native关键字

?? native_init做了什么

```

```



private native void processFile(String path, String mimeType, MediaScannerClient client);

