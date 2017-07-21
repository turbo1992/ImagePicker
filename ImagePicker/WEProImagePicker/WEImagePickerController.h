//
//  WEImagePickerController.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/19.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEAssetHelper.h"

@protocol PhotoSelectedDelegate<NSObject>

/**
 *  选择图片完成代理方法回调
 *
 *  @param assets 存的是ALAsset对象 通过ALAsset对象获取image
 */
-(void)selectPhotosDidFinish:(NSMutableArray *)assets;

@end

@interface WEImagePickerController : UIViewController

/**
 *  传入已选中图片selectPhotos
 */
@property (nonatomic, strong) NSMutableArray *selectPhotos;

/**
 *  最大可选数量
 */
@property (nonatomic, assign) NSInteger maxPhotoCount;

/**
 *  item间距
 */
@property (nonatomic, assign) CGFloat itemPadding;

/**
 *  每行item个数
 */
@property (nonatomic, assign) int columns;

/**
 *  选择图片完成block回调
 *
 *  assets 存的是ALAsset对象 通过ALAsset对象获取image
 */
@property (nonatomic, copy) void (^didFinishPickingPhotosHandle)(NSMutableArray *assets);

@property (nonatomic, assign) id <PhotoSelectedDelegate> delegate;

@end
