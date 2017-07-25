//
//  WEPhotoLibrayController.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/24.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEImagePickerHeader.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface WEPhotoLibrayController : UINavigationController

/**
 *  最多能选择的照片数量
 */
@property(nonatomic, assign) NSInteger maxCount;

/**
 *  是否可以跨相册选择
 */
@property (nonatomic, assign) BOOL multiAlbumSelect;

/**
 *  初始化相册及图片资源回调
 *
 *  @param block 回调图片数组(images)
 */
+ (instancetype)photoLibrayControllerWithBlock:(WEImagePicker_ArrayBlock) block;

@end


// 相册组模型
@interface WEPhotoGroup : NSObject

/**
 *  相册组名字
 */
@property(nonatomic, copy) NSString *groupName;

/**
 *  相册组封面
 */
@property(nonatomic, strong) UIImage *groupIcon;

/**
 *  相册组资源
 */
@property(nonatomic, strong) NSMutableArray *photoALAssets;

@end


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// 相册图片模型
@interface WEPhotoALAssets : NSObject

/**
 *  iOS8以下使用ALASset
 */
@property(nonatomic ,strong) ALAsset *photoALAsset;

/**
 *  iOS8以上使用PhotoKit/PHASset
 */
@property(nonatomic ,strong) PHAsset *photoAsset;

/**
 *  选中状态
 */
@property(nonatomic, assign, getter = isSelected) BOOL selected;

@end

#pragma clang diagnostic pop
