//
//  UIImage+ReMake.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ReMake)

- (UIImage *)remakeImageWithFullSize:(CGSize)fullSize zoom:(CGFloat)zoom;

/*
 * 生成一个默认的占位图片：
 */
+ (UIImage *)image:(UIImage *)image phImageWithSize:(CGSize)fullSize zoom:(CGFloat)zoom;
@end
