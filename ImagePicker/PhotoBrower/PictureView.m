//
//  PictureVIew.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "PictureView.h"

@interface PictureView ()

@property (nonatomic, strong) NSData *originData;

@end

@implementation PictureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat centerX = self.frame.size.width * .5;
        CGFloat centerY = self.frame.size.height * .5;
        CGFloat width = 50.0f;
        self.progressView = [[PBGView alloc] initWithFrame:CGRectMake(centerX-25.0, centerY-25.0, width, width)];
        self.progressView.hidden = YES;
        [self addSubview:self.progressView];
        
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    
    [self loadImage:_url];
}

- (void)setIsFromInternet:(BOOL)isFromInternet {
    
    _isFromInternet = isFromInternet;
    
    UIImage *image = nil;
    if (isFromInternet) {
        image = nil;
    } else {
        image = nil;
    }
    self.image = image;
    
}

- (void)setDefatultImage:(UIImage *)defatultImage {
    
    _defatultImage = defatultImage;
    
    self.image = _defatultImage;
    
}

- (void)loadImage:(NSString *)url
{
    __weak typeof(self) weakSelf = self;
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache diskImageExistsWithKey:url completion:^(BOOL isInCache) {
        
        if (isInCache) {
            UIImage *image = [imageCache imageFromDiskCacheForKey:url];
            if (image != nil) {
                
                weakSelf.hasImage = YES;
                
                weakSelf.originalImage = image;
                
                weakSelf.image = image;
            }
        } else {
            
            __weak typeof(self) weakSelf = self;
            [self imageWithUrlStr:url phImage:self.image progressBlock:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                if (weakSelf.isNotShow)
                    _progressView.hidden = YES;
                else
                    _progressView.hidden = NO;
                
                CGFloat progress = receivedSize / ((CGFloat)expectedSize);
                
                _progressView.progress = progress;
                
                
            } completedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (error) {
                    weakSelf.defatultImage = DefaultImage;
                }
                weakSelf.hasImage = image != nil;
                
                if (image != nil) {
                    
                    weakSelf.originalImage = image;
                    
                    _progressView.progress = 1.0f;
                    
                    [weakSelf save];
                }
                
            }];
        }
        
    }];
}


- (BOOL)isExits
{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    
    return [imageCache diskImageExistsWithKey:self.url];
}

// 保存图片到本地Library/Caches/Datas 文件夹下
- (void)save
{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache storeImage:self.originalImage recalculateFromImage:YES imageData:nil forKey:self.url toDisk:YES];
    
    
    if (![self isExits]) {
        
//        ImageBO *bo = [[ImageBO alloc] init];
//        bo.image_url = self.url;
//        bo.filePath = [imageCache defaultCachePathForKey:self.url];
//        [DB insertToDB:bo];
//        
    }
}

- (void)layoutSubviews
{
    CGFloat centerX = self.frame.size.width * .5;
    CGFloat centerY = self.frame.size.height * .5;
    CGFloat width = 50.0f;
    self.progressView.frame = CGRectMake(centerX-25.0, centerY-25.0, width, width);
}
@end
