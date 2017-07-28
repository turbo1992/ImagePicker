//
//  UIImage+ReMake.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "UIImage+ReMake.h"

@implementation UIImage (ReMake)

- (UIImage *)remakeImageWithFullSize:(CGSize)fullSize zoom:(CGFloat)zoom
{
    // 新建上下文
    UIGraphicsBeginImageContextWithOptions(fullSize, NO, 0.0);
    
    // 图片原本size
    CGSize size_original = self.size;
    CGFloat sizeW = size_original.width * zoom;
    CGFloat sizeH = size_original.height * zoom;
    CGFloat x = (fullSize.width - sizeW) * .5f;
    CGFloat y = (fullSize.height - sizeH) * .5f;
    CGRect rect = CGRectMake(x, y, sizeW, sizeH);
    
    [self drawInRect:rect];
    
    // 获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)image:(UIImage *)image phImageWithSize:(CGSize)fullSize zoom:(CGFloat)zoom
{
    return [image remakeImageWithFullSize:fullSize zoom:zoom];;
}
@end
