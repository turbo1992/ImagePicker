//
//  PBGView.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "PBGView.h"
#import "LFRoundProgressView.h"

@interface PBGView ()

/** 进度视图 */
@property (nonatomic, strong) LFRoundProgressView *progressView;

@end

@implementation PBGView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self viewPrepare];
    }
    
    return self;
}

/*
 * 视图准备
 */
- (void)viewPrepare
{
    self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    
    [self addSubview:self.progressView];
    
    self.clipsToBounds = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.bounds.size.width * .5;
    
    CGFloat d_xy = 5.0f;
    
    self.progressView.frame = CGRectInset(self.bounds, d_xy, d_xy);
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    
    self.progressView.progress = progress;
    
    if  (progress >= 1) {
      
        [UIView animateWithDuration:.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
            self.alpha = 1.0f;
        }];
        
    }
}

- (LFRoundProgressView *)progressView
{
    if (_progressView == nil) {
    
        _progressView = [[LFRoundProgressView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        
    }
    
    return _progressView;
}

@end
