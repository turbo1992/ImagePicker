//
//  WEImgPickerPhotoCell.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/19.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "WEImgPickerPhotoCell.h"

@implementation WEImgPickerPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // 相册图片
        self.photoImageView.frame = CGRectMake(.0f, .0f, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self.contentView addSubview:self.photoImageView];
        
        // 选中状态图片
        self.selectImageView.frame = CGRectMake(frame.size.width - 26, 8, 18, 18);
        [self.contentView addSubview:self.selectImageView];
    }
    
    return self;
}

#pragma mark - view getters

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.layer.masksToBounds = YES;
    }
    return _photoImageView;
}

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
    }
    return _selectImageView;
}

@end
