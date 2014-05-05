//
//  HBShare.h
//  HBBussiness
//
//  Created by Limboy on 3/12/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@class HBPin;

@interface HBShare : NSObject <WXApiDelegate>

+ (void)registerWeixinAPIKey:(NSString *)weixinAPIKey;

+ (HBShare *)sharedInstance;

- (void)shareImageWithTitle:(NSString *)title image:(UIImage *)image completionHandler:(UIActivityViewControllerCompletionHandler)completionHandler;

- (void)shareWebPageWithTitle:(NSString *)title description:(NSString *)description url:(NSString *)url thumbnailImage:(UIImage *)thumbnailImage completionHandler:(UIActivityViewControllerCompletionHandler)completionHandler;
@end
