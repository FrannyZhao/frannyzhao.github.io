



[TOC]

# Android强制更改为横屏方案

参考https://blog.csdn.net/songjinshi/article/details/50586333

增加了应用层的修改，防止有的应用写了screenOrientation = portrait, 或者request orientation portrait

## frameworks/native

### SurfaceFlinger的DispalyDevice

```cpp
diff --git a/services/surfaceflinger/DisplayDevice.cpp b/services/surfaceflinger/DisplayDevice.cpp
index 6128890..3d92e49 100644
--- a/services/surfaceflinger/DisplayDevice.cpp
+++ b/services/surfaceflinger/DisplayDevice.cpp
@@ -189,7 +189,8 @@ DisplayDevice::DisplayDevice(
     }
 
     // initialize the display orientation transform.
-    setProjection(DisplayState::eOrientationDefault, mViewport, mFrame);
+    //setProjection(DisplayState::eOrientationDefault, mViewport, mFrame);
+    setProjection(DisplayState::eOrientation90, mViewport, mFrame);
 
     if (useTripleFramebuffer) {
         surface->allocateBuffers();
@@ -563,6 +564,10 @@ void DisplayDevice::setProjection(int orientation,
         // the destination frame can be invalid if it has never been set,
         // in that case we assume the whole display frame.
         frame = Rect(w, h);
+        if (R.getOrientation() & Transform::ROT_90) {
+            // for force landscape
+            swap(frame.right, frame.bottom);
+        }
     }
 
     if (viewport.isEmpty()) {

```



## frameworks/base

### 开机动画，宽高对调

```cpp
diff --git a/cmds/bootanimation/BootAnimation.cpp b/cmds/bootanimation/BootAnimation.cpp
index 6526123..abb8510 100644
--- a/cmds/bootanimation/BootAnimation.cpp
+++ b/cmds/bootanimation/BootAnimation.cpp
@@ -258,7 +258,8 @@ status_t BootAnimation::readyToRun() {
 
     // create the native surface
     sp<SurfaceControl> control = session()->createSurface(String8("BootAnimation"),
-            dinfo.w, dinfo.h, PIXEL_FORMAT_RGB_565);
+            dinfo.h, dinfo.w, PIXEL_FORMAT_RGB_565);
+            //dinfo.w, dinfo.h, PIXEL_FORMAT_RGB_565);
 
     SurfaceComposerClient::openGlobalTransaction();
     control->setLayer(0x40000000);

```

### framework层


```java
diff --git a/services/core/java/com/android/server/policy/PhoneWindowManager.java b/services/core/java/com/android/server/policy/PhoneWindowManager.java
index e81fd66..bfd068a 100644
--- a/services/core/java/com/android/server/policy/PhoneWindowManager.java
+++ b/services/core/java/com/android/server/policy/PhoneWindowManager.java
@@ -7167,7 +7167,9 @@ public class PhoneWindowManager implements WindowManagerPolicy {
                             ? "USER_ROTATION_LOCKED" : "")
                         );
         }
-
+        if (true) {
+            return mLandscapeRotation;
+        }
         if (mForceDefaultOrientation) {
             return Surface.ROTATION_0;
         }

```

```java
diff --git a/services/core/java/com/android/server/wm/DisplayContent.java b/services/core/java/com/android/server/wm/DisplayContent.java
index a49f447..be35409 100644
--- a/services/core/java/com/android/server/wm/DisplayContent.java
+++ b/services/core/java/com/android/server/wm/DisplayContent.java
@@ -233,7 +233,7 @@ class DisplayContent extends WindowContainer<DisplayContent.DisplayChildWindowCo
      *
      * @see #updateRotationUnchecked(boolean)
      */
-    private int mRotation = 0;
+    private int mRotation = 1;
 
     /**
      * Last applied orientation of the display.
@@ -891,7 +891,8 @@ class DisplayContent extends WindowContainer<DisplayContent.DisplayChildWindowCo
     }
 
     void setRotation(int newRotation) {
-        mRotation = newRotation;
+        //mRotation = newRotation;
+        mRotation = 1;
     }
 
     int getLastOrientation() {

```

### 应用层

```java
diff --git a/core/java/android/app/Activity.java b/core/java/android/app/Activity.java
index bfa35da..e0c53eb 100644
--- a/core/java/android/app/Activity.java
+++ b/core/java/android/app/Activity.java
@@ -5773,12 +5773,12 @@ public class Activity extends ContextThemeWrapper
         if (mParent == null) {
             try {
                 ActivityManager.getService().setRequestedOrientation(
-                        mToken, requestedOrientation);
+                        mToken, 0);
             } catch (RemoteException e) {
                 // Empty
             }
         } else {
-            mParent.setRequestedOrientation(requestedOrientation);
+            mParent.setRequestedOrientation(0);
         }
     }
 
```

```java
diff --git a/core/java/android/content/pm/PackageParser.java b/core/java/android/content/pm/PackageParser.java
index 750bad6..6b34af6 100644
--- a/core/java/android/content/pm/PackageParser.java
+++ b/core/java/android/content/pm/PackageParser.java
@@ -4378,9 +4378,7 @@ public class PackageParser {
                 a.info.flags |= ActivityInfo.FLAG_RESUME_WHILE_PAUSING;
             }
 
-            a.info.screenOrientation = sa.getInt(
-                    R.styleable.AndroidManifestActivity_screenOrientation,
-                    SCREEN_ORIENTATION_UNSPECIFIED);
+            a.info.screenOrientation = 0;
 
             setActivityResizeMode(a.info, sa, owner);
 
@@ -4810,7 +4808,7 @@ public class PackageParser {
         if (info.descriptionRes == 0) {
             info.descriptionRes = target.info.descriptionRes;
         }
-        info.screenOrientation = target.info.screenOrientation;
+        info.screenOrientation = 0;
         info.taskAffinity = target.info.taskAffinity;
         info.theme = target.info.theme;
         info.softInputMode = target.info.softInputMode;
```

