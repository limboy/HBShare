//
//  UIImage+ResizeCrop.h
//  HBShare
//
//  Created by Limboy on 5/5/14.
//  Copyright (c) 2014 Huaban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeCrop)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
