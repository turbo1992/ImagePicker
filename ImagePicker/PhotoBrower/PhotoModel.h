//
//  PhotoModel.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoModel : NSObject

/* mid，保存图片缓存唯一表示，必须传 */
@property (nonatomic, copy) NSString *mid;

/** 网络图片地址 */
@property (nonatomic, copy) NSString *image_url;

/** 高清图地址 */
@property (nonatomic, copy) NSString *image_HD;

/* 本地高清图片 */
@property (nonatomic, strong) UIImage *fullResolutionImage;

/* 本地全屏图片 */
@property (nonatomic, strong) UIImage *fullScreenImage;

/* 本地图片海报 */
@property (nonatomic, strong) UIImage *posterImage;

/* 本地图片路径 */
@property (nonatomic, copy) NSString *filePath;

/* 是否为网络图片 */
@property (nonatomic, assign) BOOL isNetWork;

/*! 默认图片 */
@property (nonatomic, strong) UIImage *defaultImage;

/*! 图片大小 byte */
@property (nonatomic, strong) NSNumber *bytes;
/*! 图片大小 M */
@property (nonatomic, copy) NSString *bigBytes;

/* 图片最新地址 */
@property (nonatomic, copy) NSString *filename;

/* 图片对应标题 */
@property (nonatomic, copy) NSString *title;

@end
