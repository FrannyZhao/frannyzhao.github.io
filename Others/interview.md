# 面试出题

主要成就：

视图模块化；

Arouter;

外观模式；

eventbus观察者模式，

binder了解, socket,

ams;

tinker,封装dex，类的映射， classloader数组;

jvm, gc新生代



java 8 c 4,5



薪资：20K左右

15*15K

3周

## git工作流程

解决冲突；

git pull

git add; git commit;





## 堆和栈的区别（程序的分配机制）

* 栈 
  * 编译器自动维护的，不需要程序员显式维护
  * 栈size比较小，创建线程的时候确定栈大小，栈里面存放局部变量和函数调用关系；
  * 栈由相应的硬件支持，硬件指令和寄存器；
  * 栈是高地址向低地址扩展, 是一块连续的内存区域
* 堆 
  * 一片可以动态分配释放的内存区域，内存维护方式，频繁分配释放可能会引起内存碎片
  * 堆是地地址向高地址分配, 不连续的内存区域
  * 栈上的数据在函数结束后自动释放, 堆上的数据如果不释放, 一直能访问, 可能会造成内存泄漏
  * 栈是先进后出, 不会有内存碎片问题, 堆如果频繁的new/delete 会造成内存空间不连续, 造成大量碎片

https://m.php.cn/faq/418027.html

回答ok



## 二分查找

```java
public int binarySearch(int[] nums, int target) {
    if (nums == null || nums.length == 0) {
        return -1;
    }
    int start = 0;
    int end = nums.length - 1;
    while (start + 1 < end) {
        int mid = start + (end - start) / 2;
        if (nums[mid] == target) {
            end = mid;
        } else if (nums[mid] < target) {
            start = mid;
        } else if (nums[mid] > target) {
            end = mid;
        }
    }
    if (nums[start] == target) {
        return start;
    }
    if (nums[end] == target) {
        return end;
    }
    return -1;
}
```

## 插入排序

```java
import java.util.Arrays;
public class InsertSort {
    public int[] sort(int[] srcArr) {
        int[] arr = Arrays.copyOf(srcArr, srcArr.length);
        int tmp;
        for (int i = 1; i < arr.length; i++) {
            tmp = arr[i];
            int j = i;
            while (j > 0 && tmp < arr[j - 1]) {
                arr[j] = arr[j - 1];
                j--;
            }
            arr[j] = tmp;
        }
        return arr;
    }
}
```





