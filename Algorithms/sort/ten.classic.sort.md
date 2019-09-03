[TOC]

# Ten classic sort algorithms

## Bubble sort

```java
import java.util.Arrays;
public class BubbleSort {
    public int[] sort(int[] srcArr) {
        int[] arr = Arrays.copyOf(srcArr, srcArr.length);
        boolean hasChanged;
        for (int i = arr.length - 1; i > 0; i --) {
            hasChanged = false;
            for (int j = 0; j < i; j ++) {
                if (arr[j] > arr[j + 1]) {
                    int tmp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = tmp;
                    hasChanged = true;
                }
            }
            if (!hasChanged) {
                break;
            }
        }
        return arr;
    }
}
```

* **重点**

import java.util.Arrays;
public class BubbleSort {
    public int[] sort(int[] srcArr) {
        int[] arr = Arrays.copyOf(srcArr, srcArr.length);
        boolean hasChanged;

>####               for (int i = arr.length - 1; i > 0; i --) {

​            hasChanged = false;

> ####       for (int j = 0; j < i; j ++) {

​                if (arr[j] > arr[j + 1]) {
​                    int tmp = arr[j];
​                    arr[j] = arr[j + 1];
​                    arr[j + 1] = tmp;
​                    hasChanged = true;
​                }
​            }
​            if (!hasChanged) {
​                break;
​            }
​        }
​        return arr;
​    }
}

## Selection sort









## Insert sort







## Shell sort







## Merge sort









## Quick sort







## Heap sort







## Counting sort





## Bucket sort







## Radix sort





































