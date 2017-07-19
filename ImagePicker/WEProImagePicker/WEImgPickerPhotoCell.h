//
//  WEImgPickerPhotoCell.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/19.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEImgPickerPhotoCell : UICollectionViewCell

/**
 *  相册图片
 */
@property (nonatomic, strong) UIImageView *photoImageView;

/**
 *  选中状态图片
 */
@property (nonatomic, strong) UIImageView *selectImageView;

@end
