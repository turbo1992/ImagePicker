//
//  WEAssetHelper.h
//  ImagePicker
//
//  Created by Turbo on 2017/7/19.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface WEAssetHelper : NSObject

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

/**
 *  对ALAssetsLibrary开启单例模式
 */
+(ALAssetsLibrary *) defaultAssetsLibrary;

#pragma clang diagnostic pop


@end
