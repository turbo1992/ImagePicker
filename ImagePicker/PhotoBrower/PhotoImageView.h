//
//  PhotoImageView.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoImageView : UIImageView

/*
 * 初始化图片是否可高度缩放,默认为NO
 * @YES:imageView高度为屏幕宽度,宽度缩放
 * @NO:根据imageSize计算缩放
 */
@property (nonatomic, assign) BOOL imageScaleEnable;

/*
 * 设置照片后的回调
 */
@property (nonatomic,copy) void (^ImageSetBlock)(UIImage *image);

@property (nonatomic, assign) CGRect calF;

@end
