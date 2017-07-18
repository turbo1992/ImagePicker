//
//  PhotoLoadingView.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMinProgress 0.0001

@interface PhotoLoadingView : UIView
@property (nonatomic, assign) float progress;

- (void)showLoading;
@end
