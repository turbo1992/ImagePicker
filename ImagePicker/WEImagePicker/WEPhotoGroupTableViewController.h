//
//  WEPhotoGroupTableViewController.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/24.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPhotoLibrayController.h"

@interface WEPhotoGroupTableViewController : UITableViewController

/**
 *  最多能选择的照片数量
 */
@property (nonatomic, assign) NSInteger maxCount;

/**
 *  相册组photoGroupArray
 */
@property(nonatomic, strong) NSArray *photoGroupArray;

/**
 *  选中回调
 */
@property (nonatomic, copy) WEImagePicker_ArrayBlock block;

/**
 *  是否可以跨相册选择
 */
@property (nonatomic, assign, getter = canMultiAlbumSelect) BOOL multiAlbumSelect;

/**
 *  无法获取访问相册权限提示
 */
- (void)showErrorMessageView;

@end


// 相册组列表cell
@interface WEPhotoGroupCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  相册数据
 */
@property(nonatomic, strong) WEPhotoGroup *photoGroup;

/**
 *  相册封面
 */
@property(nonatomic, weak) UIImageView *iconView;

/**
 *  相册信息
 */
@property(nonatomic, weak) UILabel *infoLabel;

@end
