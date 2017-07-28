//
//  ShowPictureController.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureView.h"
#import "PhotoModel.h"

typedef enum {
    PickerTypeShow, // 展示图片
    PickerTypeDelete// 删除
} PickerShowType;

typedef enum {
    TextAlignmentBottom,// 文字底部布局
    TextAlignmentTop    // 文字顶部布局
} TextAligentType;

@protocol ShowPictureControllerDelegate <NSObject>

@optional

/**
 *  删除图片回调
 *
 *  @param images 删除图片后返回剩余图片model数组
 */
- (void)deleteImageFinish:(NSArray *)images;

@end

@interface ShowPictureController : UIViewController

@property (nonatomic, weak) id<ShowPictureControllerDelegate> delegate;

/**
 *  图片是否根据宽高缩放
 */
@property (nonatomic, assign) BOOL imageScaleEnable;

/**
 *  是否为本地图片
 */
@property (nonatomic, assign) BOOL isLocalImage;

/**
 *  文字布局样式
 */
@property (nonatomic, assign) TextAligentType textAligent;

/**
 *  展示图片浏览
 *
 *  @param handleVC     传入控制器
 *  @param type         图片展示类型为展示、删除
 *  @param index        需要展示图片所在的页码
 *  @param photos       图片模型数组
 */
- (void)show:(UIViewController *)handleVC type:(PickerShowType)type isInternet:(BOOL)flag index:(NSUInteger)index photoViews:(NSArray *)photos;

@end
