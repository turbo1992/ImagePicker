//
//  WEPhotoGroupDetailController.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/24.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPhotoLibrayController.h"

@interface WEPhotoGroupDetailController : UICollectionViewController

/**
 *  最多能选择的照片数量
 */
@property (nonatomic, assign) NSInteger maxCount;

/**
 *  相册组名字
 */
@property (nonatomic,   copy) NSString *groupName;


/**
 *  相册资源array
 */
@property (nonatomic, strong) NSArray *photoALAssets;

/**
 *  选中回调
 */
@property (nonatomic,   copy) WEImagePicker_ArrayBlock block;

@end


// 相册图片cell
@interface WEPhotoCell : UICollectionViewCell

/**
 *  图片数据模型
 */
@property(nonatomic, strong) WEPhotoALAssets *photoALAsset;

/**
 *  图片
 */
@property(nonatomic, weak) UIImageView *iconView;

/**
 *  选中蒙版
 */
@property(nonatomic, weak) UIView *selectedView;

/**
 *  选中按钮
 */
@property(nonatomic, weak) UIButton *selectedBtn;

@end
