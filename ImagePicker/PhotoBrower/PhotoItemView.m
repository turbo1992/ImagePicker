//
//  PhotoItemView.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "PhotoItemView.h"
#import "PhotoLoadingView.h"

@interface PhotoItemView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) PhotoLoadingView  *loading;
@end

@implementation PhotoItemView
@synthesize zoomScale = _zoomScale;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.minimumZoomScale = 1.0f;
        self.scrollView.maximumZoomScale = 5.0f;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        self.loading = [[PhotoLoadingView alloc] init];
        
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)singleTap
{
    if (_delegate && [_delegate respondsToSelector:@selector(dismissView)])
    {
        [_delegate dismissView];
    }
}

- (void)setPhotoModel:(PhotoModel *)photoModel
{
    _photoModel = photoModel;
    
    if (_photoModel == nil) return ;
    
    // 数据准备
    [self dataPrepare];
}

- (void) dataPrepare
{
    self.scrollView.contentSize = self.photoImageView.frame.size;
    
    self.photoImageView.frame = self.photoImageView.calF;
    
    self.photoImageView.backgroundColor = [UIColor clearColor];
}

- (PhotoImageView *)photoImageView
{
    if (_photoImageView == nil) {
        
        CGSize size = [[UIScreen mainScreen] bounds].size;
        
        _photoImageView = [[PhotoImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        _photoImageView.userInteractionEnabled = YES;
        
        _photoImageView.imageScaleEnable = self.imageScaleEnable;
        
        [self.scrollView addSubview:_photoImageView];
        
    }
    
    return _photoImageView;
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    
    [self loadImageUrl:_url];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    [self loadImage:image];
}

- (BOOL)isExits
{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    
    return [imageCache diskImageExistsWithKey:self.url];
}

- (void)loadImageUrl:(NSString *)url
{
    __weak typeof(self) weakSelf = self;
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache diskImageExistsWithKey:url completion:^(BOOL isInCache) {
        
        if (isInCache) {
            UIImage *image = [imageCache imageFromDiskCacheForKey:url];
            if (image != nil) {
                
                weakSelf.photoImageView.image = image;
                [weakSelf dataPrepare];

            }
        } else {
            
            [_loading showLoading];
            [self addSubview:_loading];
            [self.photoImageView imageWithUrlStr:url phImage:self.photoImageView.image progressBlock:^(NSInteger receivedSize, NSInteger expectedSize)
            {
                
                if (receivedSize > kMinProgress) {
                    weakSelf.loading.progress = (float)receivedSize/expectedSize;
                }

            } completedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                
                [weakSelf.loading removeFromSuperview];
                
                if (image != nil) {
                    
                    weakSelf.photoImageView.image = image;
                    
                    weakSelf.scrollView.contentSize = weakSelf.photoImageView.frame.size;
                    
                    weakSelf.photoImageView.frame = weakSelf.photoImageView.calF;

                    
                    weakSelf.userInteractionEnabled = YES;
                    
                    [weakSelf save];
                    
                } else {
                    
                    weakSelf.photoImageView.image = DefaultImage;
                    
                    weakSelf.scrollView.contentSize = weakSelf.photoImageView.frame.size;
                    
                    weakSelf.photoImageView.frame = weakSelf.photoImageView.calF;
                    
                    weakSelf.userInteractionEnabled = YES;
                }

            }];
        }
        
    }];
}

// 保存图片到本地Library/Caches/Datas 文件夹下
- (void)save
{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache storeImage:self.photoImageView.image recalculateFromImage:YES imageData:nil forKey:self.url toDisk:YES];
    
    if ([self isExits]) {
        
    }
}

- (void)loadImage:(UIImage *)image {
    
    if (image != nil) {
        
        self.photoImageView.image = image;
        
        self.scrollView.contentSize = self.photoImageView.frame.size;
        
        self.photoImageView.frame = self.photoImageView.calF;
        
        
        self.userInteractionEnabled = YES;
        
        
    } else {
        
        self.photoImageView.image = DefaultImage;
        
        self.scrollView.contentSize = self.photoImageView.frame.size;
        
        self.photoImageView.frame = self.photoImageView.calF;
        
        self.userInteractionEnabled = YES;
    }

}

#pragma mark - UIScrollView Delegate Method

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale <= 1) scrollView.zoomScale = 1.0;
    
    CGFloat xcenter = scrollView.center.x, ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width * .5 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height * .5 : ycenter;
    
    [self.photoImageView setCenter:CGPointMake(xcenter, ycenter)];
}

- (void)reset
{
    //缩放比例
    self.scrollView.zoomScale = 1.0f;
    
    //默认无图
    self.photoImageView.frame = CGRectZero;
}

- (CGFloat)zoomScale {
    return self.scrollView.zoomScale;
}

- (void)setZoomScale:(CGFloat)zoomScale {
    _zoomScale = zoomScale;
    [self.scrollView setZoomScale:zoomScale animated:YES];
}
@end
