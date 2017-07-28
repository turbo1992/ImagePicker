//
//  LoadingView.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoProgressView : UIView

@property (nonatomic, strong) UIColor *trackTintColor;
@property (nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic, assign) float   progress;

@end
