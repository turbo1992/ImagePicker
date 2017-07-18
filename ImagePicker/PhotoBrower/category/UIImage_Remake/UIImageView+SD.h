//
//  UIImageView+SD.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"
#import "UIImage+ReMake.h"

@interface UIImageView (SD)

/**
 * 普通网络图片展示
 *
 * @param urlStr   图片地址
 * @param phImage  占位图片
 */
- (void)imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage;

/**
 * 带有进度的网络图片展示
 *
 * @param urlStr           图片地址
 * @param phImage          占位图片
 * @param progressBlock    进度
 * @param completedBlock   完成
 */
- (void)imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage progressBlock:(SDWebImageDownloaderProgressBlock)progressBlock completedBlock:(SDWebImageCompletionBlock)completedBlock;

@end
