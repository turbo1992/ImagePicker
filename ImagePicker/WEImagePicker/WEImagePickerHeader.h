//
//  WEImagePickerHeader.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/24.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#ifndef WEImagePickerHeader_h
#define WEImagePickerHeader_h

typedef void(^WEImagePicker_ArrayBlock)(NSArray *images);
typedef void(^WEImagePicker_imageBlock)(UIImage *image);

#define WEImagePicker_Item_Height 80    // cell高度
#define WEImagePicker_Item_Padding 10   // item间距
#define WEImagePicker_Item_Columns 3    // 每行item个数

#define WEImagePicker_System_iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define WEScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define WEScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define WENavigationBarHeight    64.0f
#define WETabBarHeight           49.0f

#define WERGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define PickerMainColor WERGBCOLOR(37, 124, 231) // Picker工程主色

#endif /* WEImagePickerHeader_h */
