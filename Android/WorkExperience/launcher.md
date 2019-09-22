[TOC]

# Launcher获取全部应用列表，并监听应用增删

## 获取全部应用列表

### 安卓L以后

通过LauncherApps.getActivityList获得

```java
LauncherApps mLauncherApps = (LauncherApps) context.getSystemService(Context.LAUNCHER_APPS_SERVICE);

@RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
public List<LauncherActivityInfo> getAllApps(Context context) {
  List<LauncherActivityInfo> allApps = new ArrayList<>();
  UserManager mUserManager = (UserManager) context.getSystemService(Context.USER_SERVICE);
  for (UserHandle user : mUserManager.getUserProfiles()) {
    List<LauncherActivityInfo> lais = mLauncherApps.getActivityList(null, user);
    allApps.addAll(lais);
  }
  return allApps;
}
```

获得应用图标，名称，启动intent

```java
LauncherActivityInfo launcherActivityInfo = mAppsHighVersion.get(position);
holder.appName.setText(launcherActivityInfo.getLabel().toString());
holder.appIcon.setImageDrawable(launcherActivityInfo.getIcon(320));
// todo
```



### 安卓4.4.4

通过PackageManager.queryIntentActivities获得全部应用

```java
public List<ResolveInfo> getAllApps(Context context) {
  PackageManager pm = context.getPackageManager();
  Intent launchable = new Intent(Intent.ACTION_MAIN);
  launchable.addCategory(Intent.CATEGORY_LAUNCHER);
  final List<ResolveInfo> allApps = pm.queryIntentActivities(launchable, 0);
  return allApps;
}
```

获得应用图标，名称，启动Intent

```java
ResolveInfo resolveInfo = mAppsLowVersion.get(position);
holder.appName.setText(resolveInfo.activityInfo.applicationInfo.loadLabel(mPackageManager));
holder.appIcon.setImageDrawable(resolveInfo.activityInfo.applicationInfo.loadIcon(mPackageManager));
// todo
```



## 监听应用增删

### 安卓L以后

注册回调LauncherApps.Callback

```java
public class AppStateManager {
    private static final String TAG = AppStateManager.class.getSimpleName();
    private static volatile AppStateManager instance = null;

    private LauncherApps mLauncherApps;
    private AppStateCallback mCallback;
    private Object mCallbackLock = new Object();
    private final HandlerThread mCallbackThread = new HandlerThread("callback");

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private AppStateManager(Context context) {
        mCallbackThread.start();
        mLauncherApps = (LauncherApps) context.getSystemService(Context.LAUNCHER_APPS_SERVICE);
        synchronized (mCallbackLock) {
            if (mCallback != null) {
                mLauncherApps.unregisterCallback(mCallback);
            }
        }
        mCallback = new AppStateCallback();
        mLauncherApps.registerCallback(mCallback, new Handler(mCallbackThread.getLooper()));
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public void unregister() {
        synchronized (mCallbackLock) {
            if (mCallback != null) {
                mLauncherApps.unregisterCallback(mCallback);
                mCallback = null;
            }
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private class AppStateCallback extends LauncherApps.Callback {
        private final String TAG = AppStateCallback.class.getSimpleName();
        @Override
        public void onPackageRemoved(String packageName, UserHandle user) {
            Log.i(TAG, "onPackageRemoved packageName " + packageName + ", user " + user);
        }

        @Override
        public void onPackageAdded(String packageName, UserHandle user) {
            Log.i(TAG, "onPackageAdded packageName " + packageName + ", user " + user);
        }

        @Override
        public void onPackageChanged(String packageName, UserHandle user) {
            Log.i(TAG, "onPackageChanged packageName " + packageName + ", user " + user);
        }

        @Override
        public void onPackagesAvailable(String[] packageNames, UserHandle user, boolean replacing) {
            Log.i(TAG, "onPackagesAvailable packageNames " + Arrays.toString(packageNames) + ", user " + user + ", replacing " + replacing);
        }

        @Override
        public void onPackagesUnavailable(String[] packageNames, UserHandle user, boolean replacing) {
            Log.i(TAG, "onPackagesUnavailable packageNames " + Arrays.toString(packageNames) + ", user " + user + ", replacing " + replacing);
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public static AppStateManager getInstance(Context context) {
        if (instance == null) {
            synchronized (AppStateManager.class) {
                if (instance == null) {
                    instance = new AppStateManager(context);
                }
            }
        }
        return instance;
    }
}
```

### 安卓4.4.4

监听广播Intent.ACTION_PACKAGE_ADDED， Intent.ACTION_PACKAGE_REMOVED， Intent.ACTION_PACKAGE_CHANGED

```java
private void register(Context context) {
  IntentFilter filter = new IntentFilter(Intent.ACTION_PACKAGE_ADDED);
  filter.addAction(Intent.ACTION_PACKAGE_REMOVED);
  filter.addAction(Intent.ACTION_PACKAGE_CHANGED);
  filter.addDataScheme("package");
  context.registerReceiver(this, filter);
}

@Override
public void onReceive(Context context, Intent intent) {
  String action = intent.getAction();
  Log.i(TAG, "receive action " + action);
  String packageName = intent.getData().getSchemeSpecificPart();
  boolean replacing = intent.getBooleanExtra(Intent.EXTRA_REPLACING, false);
  if (packageName == null || packageName.length() == 0) {
    return;
  }
  int op = PackageUpdatedTask.OP_NONE;
  if (Intent.ACTION_PACKAGE_CHANGED.equals(action)) {
    op = PackageUpdatedTask.OP_UPDATE;
  } else if (Intent.ACTION_PACKAGE_REMOVED.equals(action)) {
    if (!replacing) {
      op = PackageUpdatedTask.OP_REMOVE;
    }
    // else, we are replacing the package, so a PACKAGE_ADDED will be sent
    // later, we will update the package at this time
  } else if (Intent.ACTION_PACKAGE_ADDED.equals(action)) {
    if (!replacing) {
      op = PackageUpdatedTask.OP_ADD;
    } else {
      op = PackageUpdatedTask.OP_UPDATE;
    }
  }
  Log.i(TAG, "op " + op);
  if (op != PackageUpdatedTask.OP_NONE) {
    notifyAppState();
  }
}

private class PackageUpdatedTask {
  int mOp;
  public static final int OP_NONE = 0;
  public static final int OP_ADD = 1;
  public static final int OP_UPDATE = 2;
  public static final int OP_REMOVE = 3; // uninstlled
  public static final int OP_UNAVAILABLE = 4; // external media unmounted
}
```



源码：https://github.com/FrannyZhao/LauncherDemo



###Android原生Launcher源码更多分析参考：

* Android 7.0 Launcher3源码实现全解析

https://blog.csdn.net/kuaiguixs/article/details/78818788

https://blog.csdn.net/kuaiguixs/article/details/78904196

https://blog.csdn.net/kuaiguixs/article/details/78890509

* [Android M Launcher3主流程源码浅析](https://blog.csdn.net/yanbober/article/details/50525559)





