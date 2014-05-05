### 简介

做过iOS开发的，基本都会跟分享打交道，于是需要下载各个平台的SDK，研究开发文档，调试接口，还时不时地被坑，比如某企鹅微博SDK代码混乱，且常年不更新，还经常跟第三方Lib发生命名冲突。然后还要在这些SDK的基础上包一层统一的API调用，真心累啊。

iOS自6.0起添加了`UIActivityViewController`，集成了部分社交服务，但使用起来不是很方便，同时不支持微信，HBShare就是给`UIActivityViewController` 添加了微信的支持，同时简化了API。

### 安装

#### 使用cocoapods安装

```
pod 'HBShare', '~>0.0.1'
```

### 截图

![Screenshot](https://raw.githubusercontent.com/lzyy/HBShare/master/screenshot.png)

### 使用

```
// 注册微信Key
[HBShare registerWeixinAPIKey:@"wxd930ea5d5a258f4f"];

// 分享图片
[[HBShare sharedInstance] shareImageWithTitle:@"清凉小MM" image:image completionHandler:^(NSString *activityType, BOOL completed) {
	if (completed) {
		NSLog(@"图片分享成功");
	}
}];

[[HBShare sharedInstance] shareWebPageWithTitle:@"我是一枚链接哦" description:@"啥都不说了" url:@"http://huaban.com" thumbnailImage:thumbnail completionHandler:^(NSString *activityType, BOOL completed) {
	if (completed) {
		NSLog(@"链接分享成功");
	}
}];
```

如果需要知道微信是否分享成功，可以在`AppDelegate`中添加以下代码
```
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[HBShare sharedInstance]];
}
```
