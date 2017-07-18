//
//  ImageScrollView.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIScrollView

@property (nonatomic, assign) NSUInteger index;

/** 照片数组 */
@property (nonatomic, strong) NSArray *photoModels;
@end
