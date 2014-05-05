//
//  HBAppDelegate.m
//  HBShare
//
//  Created by Limboy on 5/5/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import "HBAppDelegate.h"
#import "HBShare.h"
#import "UIImage+ResizeCrop.h"

@implementation HBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self setupRootViewController];
    return YES;
}

- (void)setupRootViewController
{
    [HBShare registerWeixinAPIKey:@"wxd930ea5d5a258f4f"];
    
    UIViewController *viewController = [[UIViewController alloc] init];
    self.window.rootViewController = viewController;
    UIButton *(^createButton)(NSString *) = ^UIButton *(NSString *buttonName) {
        static NSInteger positionY = 100;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:buttonName forState:UIControlStateNormal];
        button.frame = CGRectMake(0, positionY, 320, 30);
        positionY += 30;
        [viewController.view addSubview:button];
        return button;
    };
    
    UIButton *shareImageButton = createButton(@"分享图片");
    shareImageButton.tag = 0;
    [shareImageButton addTarget:self action:@selector(onTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareURLButton = createButton(@"分享链接");
    shareURLButton.tag = 1;
    [shareURLButton addTarget:self action:@selector(onTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapped:(UIButton *)button
{
    UIImage *image = [UIImage imageNamed:@"demo"];
    if (button.tag == 0) {
        [[HBShare sharedInstance] shareImageWithTitle:@"清凉小MM" image:image completionHandler:^(NSString *activityType, BOOL completed) {
            if (completed) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"图片分享成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }];
    } else {
        UIImage *thumbnail = [image imageByScalingAndCroppingForSize:CGSizeMake(100, 100)];
        [[HBShare sharedInstance] shareWebPageWithTitle:@"我是一枚链接哦" description:@"啥都不说了" url:@"http://huaban.com" thumbnailImage:thumbnail completionHandler:^(NSString *activityType, BOOL completed) {
            if (completed) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"链接分享成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[HBShare sharedInstance]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
