//
//  PhotoItemView.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowPictureController.h"
#import "PhotoImageView.h"
#import "PhotoModel.h"

@protocol PhotoItemViewDelegate <NSObject>

- (void)dismissView;

@end

@interface PhotoItemView : UIView

@property (nonatomic, weak) id<PhotoItemViewDelegate> delegate;

@property (nonatomic, assign) PickerShowType type;


/* 数据模型 */
@property (nonatomic, strong) PhotoModel *photoModel;

/* 当前缩放比例 */
@property (nonatomic, assign) CGFloat zoomScale;

/* 初始化图片是否可高度缩放 */
@property (nonatomic, assign) BOOL imageScaleEnable;

/*
 * 当前页标 
 */
@property (nonatomic, assign) NSUInteger pageIndex;

@property (nonatomic, strong) PhotoImageView *photoImageView;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) UIImage *image;

/*
 * 重置
 */
- (void)reset;
@end
