//
//  ImageScrollView.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "ImageScrollView.h"
#import "PhotoItemView.h"

@interface ImageScrollView ()

@property (nonatomic, assign) BOOL isScrollToIndex;

@end

@implementation ImageScrollView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    __block CGRect frame = self.bounds;
    
    CGFloat width = frame.size.width;
    
    frame.size.width = width - 20;
    
    [self.subviews enumerateObjectsUsingBlock:^(PhotoItemView *photoItemView, NSUInteger idx, BOOL *stop) {
        
        if ([photoItemView isKindOfClass:[PhotoImageView class]]) {
            CGFloat x = width * photoItemView.pageIndex;
            
            frame.origin.x = x;
            
            [UIView animateWithDuration:.01 animations:^{
                
                photoItemView.frame = frame;
                
            }];
        }
        
    }];
    
    if (!_isScrollToIndex) {
        
        CGFloat offsetX = width * _index;
        
        [self setContentOffset:CGPointMake(offsetX, 0) animated:NO];
        
        _isScrollToIndex = YES;
        
    }
}
@end
