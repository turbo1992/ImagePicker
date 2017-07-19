//
//  WEAssetHelper.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/19.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "WEAssetHelper.h"

@implementation WEAssetHelper

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

+(ALAssetsLibrary *) defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end
