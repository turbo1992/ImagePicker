//
//  StytlePtotoShowView.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/21.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    StytleNineSquareType, // 九宫格
    StytleSingleType      // 单行列表滑动
} StytleShowType;

@interface StytlePtotoShowView : UIView

/**
 *  图片展示方式:单行列表、九宫格
 */
@property (nonatomic, assign) StytleShowType showType;

/**
 *  item间距
 */
@property (nonatomic, assign) CGFloat itemPadding;

/**
 *  每行item个数
 */
@property (nonatomic, assign) int columns;

/**
 *  图片展示
 *
 *  @param photos 图片model数组
 */
- (void)showInView:(UIView *)view photos:(NSArray *)photos;

@end


@interface StytlePhotoCell : UICollectionViewCell

/**
 *  相册图片
 */
@property (nonatomic, strong) UIImageView *photoImageView;

@end
