//
//  WEPhotoLibrayController.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/24.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "WEPhotoLibrayController.h"
#import "WEPhotoGroupTableViewController.h" // 相册组列表

@interface WEPhotoLibrayController ()

/* 数据回调 */
@property(nonatomic, copy) WEImagePicker_ArrayBlock block;
/* 相册组展示列表 */
@property(nonatomic, strong) WEPhotoGroupTableViewController *photoGroupTableViewController;
/* ALAsset资源 */
@property(nonatomic, strong) ALAssetsLibrary *library;
/* PhotoKit资源 */
@property(nonatomic, strong) PHImageRequestOptions *imageOptions;
/* 相册组array */
@property(nonatomic, strong) NSMutableArray *photoGroupArray;

@end

@implementation WEPhotoLibrayController

+ (instancetype)photoLibrayControllerWithBlock:(WEImagePicker_ArrayBlock) block
{
    return [[self alloc]initWithBlock:block];
}

- (instancetype)initWithBlock:(WEImagePicker_ArrayBlock) block
{
    self.block = [block copy];
    return [super initWithRootViewController:self.photoGroupTableViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.barTintColor = PickerMainColor;
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 创建相册
    [self setUpImagePickerController];
}

#pragma mark - 创建相册
- (void)setUpImagePickerController {
    
    __weak typeof (self) weakSelf = self;
    
    if (WEImagePicker_System_iOS8) {
    
        // iOS8以上使用PHAsset
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status != PHAuthorizationStatusAuthorized) {
                // 用户未开启相册权限提示
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.photoGroupTableViewController showErrorMessageView];
                });
                
            }else {
                
                // 获取相册资源
                PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
                [collections enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
                    // 序列化相册组Group模型
                    [weakSelf photoGroupWithCollection:collection];
                }];
                
                // 为防止获取资源为nil,再次获取相册资源(系统bug)
                collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
                [collections enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
                    if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                        // 序列化相册组Group模型
                        [weakSelf photoGroupWithCollection:collection];
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.photoGroupTableViewController.photoGroupArray = weakSelf.photoGroupArray;
                });
            }
        }];
    }else {
        
        // iOS8以下使用ALAsset
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *error) {
                if (error != nil) {
                    // 用户未开启相册权限提示
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.photoGroupTableViewController showErrorMessageView];
                    });
                }
            };
            
            // 遍历所有相册资源,序列化相册组模型
            [weakSelf.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *aLAssets, BOOL* stop){
                
                if (aLAssets != nil) {
                    NSString *groupName = [aLAssets valueForProperty:ALAssetsGroupPropertyName];
                    UIImage *posterImage = [UIImage imageWithCGImage:[aLAssets posterImage]];
                    
                    WEPhotoGroup *photoGroup = [[WEPhotoGroup alloc]init];
                    photoGroup.groupName = groupName;
                    photoGroup.groupIcon = posterImage;
                    [weakSelf.photoGroupArray addObject:photoGroup];
                    
                    // 遍历该相册组资源,序列化相册图片模型
                    [aLAssets enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop){
                        
                        if (result != NULL) {
                            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                                WEPhotoALAssets *photoALAssets = [[WEPhotoALAssets alloc]init];
                                photoALAssets.photoALAsset = result;
                                photoALAssets.selected = NO;
                                [photoGroup.photoALAssets addObject:photoALAssets];
                            }
                        }
                    }];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.photoGroupTableViewController.photoGroupArray = weakSelf.photoGroupArray;
                    });
                }
                
            } failureBlock:failureblock];
            
        });
    }
}

#pragma mark - 序列化相册组Group模型
- (void)photoGroupWithCollection:(PHAssetCollection *)collection {
    
    [self coverImageWithCollection:collection completion:^(UIImage *image) {
        WEPhotoGroup *photoGroup = [[WEPhotoGroup alloc]init];
        photoGroup.groupName = collection.localizedTitle;
        photoGroup.groupIcon = image;
        [self.photoGroupArray addObject:photoGroup];
        [self photoGroupSetALAsset:photoGroup collection:collection];
    }];
}

// 遍历相册组Group资源,获取相册组封面
- (void)coverImageWithCollection:(PHAssetCollection *)collection completion:(WEImagePicker_imageBlock)completion {
    
    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    [assetResult enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        if (asset.mediaType == PHAssetMediaTypeImage) {
            CGSize targetSize = CGSizeMake(WEImagePicker_Item_Height, WEImagePicker_Item_Height);
            [self imageWithAsset:asset targetSize:targetSize completion:^(UIImage *image) {
                completion(image);
                *stop = YES;
            }];
        }
    }];
}

// 遍历相册组Group资源,序列化相册图片模型
- (void)photoGroupSetALAsset:(WEPhotoGroup *)photoGroup collection:(PHAssetCollection *)collection {
    
    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    [assetResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        if (asset.mediaType == PHAssetMediaTypeImage) {
            WEPhotoALAssets *photoALAssets = [[WEPhotoALAssets alloc]init];
            photoALAssets.photoAsset = asset;
            photoALAssets.selected = NO;
            [photoGroup.photoALAssets insertObject:photoALAssets atIndex:0];
        }
    }];
}

// 相册组封面取值
- (void)imageWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize completion:(WEImagePicker_imageBlock)completion {
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeDefault options:self.imageOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        completion(result);
    }];
}


#pragma mark - obj getters && setters

- (WEPhotoGroupTableViewController *)photoGroupTableViewController {
    if (!_photoGroupTableViewController) {
        _photoGroupTableViewController = [[WEPhotoGroupTableViewController alloc]init];
    }
    return _photoGroupTableViewController;
}

- (ALAssetsLibrary *)library {
    if (!_library) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}

- (NSMutableArray *)photoGroupArray {
    if (!_photoGroupArray) {
        _photoGroupArray = [NSMutableArray array];
    }
    return _photoGroupArray;
}

- (PHImageRequestOptions *)imageOptions {
    if (!_imageOptions) {
        _imageOptions = [[PHImageRequestOptions alloc] init];
        _imageOptions.synchronous = YES;
    }
    return _imageOptions;
}

- (void)setMaxCount:(NSInteger)maxCount {
    _maxCount = maxCount;
    self.photoGroupTableViewController.maxCount = maxCount;
    self.photoGroupTableViewController.block = self.block;
}

- (void)setMultiAlbumSelect:(BOOL)multiAlbumSelect {
    _multiAlbumSelect = multiAlbumSelect;
    self.photoGroupTableViewController.multiAlbumSelect = multiAlbumSelect;
}

@end

// 相册组模型
@implementation WEPhotoGroup

- (NSMutableArray *)photoALAssets {
    if (!_photoALAssets) {
        _photoALAssets = [NSMutableArray array];
    }
    return _photoALAssets;
}

- (void)setGroupName:(NSString *)groupName {
    if ([groupName isEqualToString:@"Camera Roll"]) {
        groupName = @"相机胶卷";
    }
    _groupName = groupName;
}

@end

// 相册图片模型
@implementation WEPhotoALAssets

@end
