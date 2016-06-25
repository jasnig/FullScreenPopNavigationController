# FullScreenPopNavigationController
自定义navigationController的全屏滑动返回



最终效果
![push.gif](http://upload-images.jianshu.io/upload_images/1271831-b3235c5d28d75f4b.gif?imageMogr2/auto-orient/strip)

[实现过程](http://www.jianshu.com/p/47a3f4ae4bc3)

requirement: swift3.0+ xcode8.0+

首先展示一下最终的使用方法, 使用还是比较方便

* 第一种, 使用提供的自定义的navigationController
   * 如果在storyboard中使用, 子需要将navigationController设置为自定义的即可, 默认拥有全屏滑动返回功能, 如果需要关闭, 在需要的地方设置如下即可
   
```
// 设置为true的时候开启全屏滑动返回功能, 设置为false, 关闭
        (navigationController as? CustomNavigationController)?.enabledFullScreenPop(isEnabled: false)
```
![storyboard中使用](http://upload-images.jianshu.io/upload_images/1271831-dc06600f84a02c16.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   * 如果使用代码初始化, 那么直接使用自定义的navigationController初始化即可
   
```
        // 同样的默认是开启全屏滑动返回功能的
        let navi = CustomNavigationController(rootViewController: rootVc)
        //如果需要关闭或者重新开启, 在需要的地方使用下面方法
        (navigationController as? CustomNavigationController)?.enabledFullScreenPop(isEnabled: false)
```
* 第二种, 使用提供的navigationController的分类
这种方法, 并没有默认开启, 需要我们自己开启或者关闭全屏滑动返回功能

```
        // 在需要的地方, 获取到navigationController, 然后使用分类方法开启(关闭)全屏返回手势即可
        navigationController?.zj_enableFullScreenPop(isEnabled: true)
```

