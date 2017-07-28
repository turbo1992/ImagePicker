//
//  UIImageView+SD.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "UIImageView+SD.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SD)

- (void)imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage
{
    if (urlStr == nil) return;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [self sd_setImageWithURL:url placeholderImage:phImage];
}

- (void)imageWithUrlStr:(NSString *)urlStr phImage:(UIImage *)phImage progressBlock:(SDWebImageDownloaderProgressBlock)progressBlock completedBlock:(SDWebImageCompletionBlock)completedBlock
{
    if (urlStr == nil) return;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    SDWebImageOptions options = SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageDownloaderLowPriority;
    
    [self sd_setImageWithURL:url placeholderImage:phImage options:options progress:progressBlock completed:completedBlock];
}
@end
