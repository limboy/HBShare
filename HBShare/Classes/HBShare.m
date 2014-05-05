//
//  HBShare.m
//  LilyCommon
//
//  Created by Limboy on 3/11/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "HBShare.h"
#import "WXApi.h"
#import "NSData+Base64Encode.h"
#import "UIImage+ResizeCrop.h"
#import "UIViewController+TopViewController.h"

static NSString *WXAPIKey;
static NSInteger selectedWeixinScene;

@interface HBShareBaseActivity : UIActivity
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *urlString;
@property (nonatomic) NSString *shareDescription;
@property (nonatomic) NSString *shareTitle;
@property (nonatomic) UIImage *image;
- (instancetype)initWithTitle:(NSString *)title type:(NSString *)type;
@end

@implementation HBShareBaseActivity

- (instancetype)initWithTitle:(NSString *)title type:(NSString *)type
{
    if (self = [super init]) {
        self.title = title;
        self.type = type;
    }
    return self;
}

- (NSString *)activityTitle
{
    return self.title;
}

- (NSString *)activityType
{
    return self.type;
}

- (UIImage *)activityImage
{
    NSString *weixinImageString = @"iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAYAAAA5ZDbSAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo4M0FENzkyMUYwNUJFMzExQjM1RkRBMzFGNDZFOTMyQSIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDowQjc4MzgxMjVFNDExMUUzQjMzMEFCMTkxMDhGOTAyRiIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDowQjc4MzgxMTVFNDExMUUzQjMzMEFCMTkxMDhGOTAyRiIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M2IChXaW5kb3dzKSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkUwNTg3QTZFMDU1Q0UzMTFCMzVGREEzMUY0NkU5MzJBIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjgzQUQ3OTIxRjA1QkUzMTFCMzVGREEzMUY0NkU5MzJBIi8+IDwvcmRmOkRlc2NyaXB0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";
    NSString *friendsImageString = @"iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAYAAAA5ZDbSAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo4M0FENzkyMUYwNUJFMzExQjM1RkRBMzFGNDZFOTMyQSIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDowQjc4MzgxNjVFNDExMUUzQjMzMEFCMTkxMDhGOTAyRiIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDowQjc4MzgxNTVFNDExMUUzQjMzMEFCMTkxMDhGOTAyRiIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M2IChXaW5kb3dzKSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkUwNTg3QTZFMDU1Q0UzMTFCMzVGREEzMUY0NkU5MzJBIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjgzQUQ3OTIxRjA1QkUzMTFCMzVGREEzMUY0NkU5MzJBIi8+IDwvcmRmOkRlc2NyaXB0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";
    
    NSData *imageData;
    if ([self.type isEqualToString:@"weixin"]) {
        imageData = [NSData dataWithBase64EncodedString:weixinImageString];
    } else {
        imageData = [NSData dataWithBase64EncodedString:friendsImageString];
    }
    return [UIImage imageWithData:imageData scale:2.0];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
}

- (void)performActivity
{
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请安装最新的微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    WXMediaMessage *wxMessage = [WXMediaMessage message];
    wxMessage.title = self.shareTitle;
    if (self.urlString) {
        WXWebpageObject *object = [WXWebpageObject object];
        wxMessage.description = self.shareDescription;
        object.webpageUrl = self.urlString;
        wxMessage.mediaObject = object;
        if (self.image) {
            [wxMessage setThumbImage:self.image];
        }
    } else {
        UIImage *thumbnailImage = [self.image imageByScalingAndCroppingForSize:CGSizeMake(80, 80)];
        WXImageObject *object = [WXImageObject object];
        object.imageData = UIImagePNGRepresentation(self.image);
        [wxMessage setThumbImage:thumbnailImage];
        wxMessage.mediaObject = object;
    }
    
    SendMessageToWXReq *wxReq = [[SendMessageToWXReq alloc] init];
    wxReq.scene = [self.type isEqualToString:@"weixin_friends"] ? WXSceneTimeline : WXSceneSession;
    selectedWeixinScene = wxReq.scene;
    wxReq.message = wxMessage;
    [WXApi sendReq:wxReq];
}

@end

// 分享到朋友圈
@interface HBShareWeixinFriends : HBShareBaseActivity
@end

@implementation HBShareWeixinFriends
- (instancetype)init
{
    if (self = [super initWithTitle:@"朋友圈" type:@"weixin_friends"]) {
    }
    return self;
}
@end

// 分享到微信
@interface HBShareWeixin : HBShareBaseActivity
@end

@implementation HBShareWeixin
- (instancetype)init
{
    if (self = [super initWithTitle:@"微信" type:@"weixin"]) {
    }
    return self;
}
@end


// --------------------------------------------------

@interface HBShare ()
@property (nonatomic, copy) UIActivityViewControllerCompletionHandler completionHandler;
@end

@implementation HBShare

#pragma mark - Public Methods

+ (void)registerWeixinAPIKey:(NSString *)weixinAPIKey
{
    WXAPIKey = weixinAPIKey;
}

+ (HBShare *)sharedInstance
{
    static id instance;
    if (!instance) {
        instance = [[HBShare alloc] init];
        NSAssert(WXAPIKey, @"请先通过 registerWeixinAPIKey: 注册微信APIKey");
        [WXApi registerApp:WXAPIKey];
    }
    return instance;
}

- (void)shareImageWithTitle:(NSString *)title image:(UIImage *)image completionHandler:(UIActivityViewControllerCompletionHandler)completionHandler
{
    self.completionHandler = completionHandler;
    [self shareWithTitle:title description:nil url:nil image:image completionHandler:completionHandler];
}

- (void)shareWebPageWithTitle:(NSString *)title description:(NSString *)description url:(NSString *)url thumbnailImage:(UIImage *)thumbnailImage completionHandler:(UIActivityViewControllerCompletionHandler)completionHandler
{
    self.completionHandler = completionHandler;
    [self shareWithTitle:title description:description url:url image:thumbnailImage completionHandler:completionHandler];
}

- (void)shareWithTitle:(NSString *)title description:(NSString *)description url:(NSString *)url image:(UIImage *)image completionHandler:(UIActivityViewControllerCompletionHandler)completionHandler
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:title?:@""];
    if (image && !url.length) {
        [items addObject:image];
    }
    if (url) {
        [items addObject:url];
    }
    
    NSMutableArray *activities = [[NSMutableArray alloc] init];
    HBShareWeixin *weixinActivity = [[HBShareWeixin alloc] init];
    HBShareWeixinFriends *weixinFriendsActivity = [[HBShareWeixinFriends alloc] init];
    [@[weixinActivity, weixinFriendsActivity] enumerateObjectsUsingBlock:^(HBShareBaseActivity *activity, NSUInteger idx, BOOL *stop) {
        activity.urlString = url;
        activity.shareDescription = description;
        activity.shareTitle = title;
        activity.image = image;
    }];
    [activities addObjectsFromArray:@[weixinActivity, weixinFriendsActivity]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:activities];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypePrint];
    [[UIViewController topViewController] presentViewController:activityViewController animated:YES completion:nil];
    
    activityViewController.completionHandler = ^(NSString *activityType, BOOL complted){
        if (completionHandler) {
            completionHandler(activityType, complted);
            self.completionHandler = nil;
        }
    };
}

#pragma mark - Weixin Delegate

- (void)onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (self.completionHandler) {
            BOOL finish = resp.errCode == WXSuccess;
            NSString *activityType = selectedWeixinScene == WXSceneTimeline ? @"weixin_friends" : @"weixin";
            self.completionHandler(activityType, finish);
        }
    }
}

@end
