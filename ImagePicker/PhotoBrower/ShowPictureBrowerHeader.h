//
//  ShowPictureBrowerHeader.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/25.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#ifndef ShowPictureBrowerHeader_h
#define ShowPictureBrowerHeader_h

// 屏幕尺寸
#define PBScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define PBScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define PBScreenBounds	[[UIScreen mainScreen] bounds]
#define PBNavigationBarHeight    64.0f
#define PBTabBarHeight           49.0f

// 占位图
#define DefaultImage [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"ShowPictureBrower.bundle/160@2x.png"]]

// 颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#endif /* ShowPictureBrowerHeader_h */
