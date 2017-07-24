//
//  WEImagePickerController.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/19.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "WEImagePickerController.h"
#import "WEImgPickerPhotoCell.h"

static NSString *cellIdentifier = @"WEImgPickerPhotoCell";

@interface WEImagePickerController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

/* 照片数组,存放的是ALAsset */
@property (nonatomic, strong) NSMutableArray *photos;
/* 图片URL */
@property (nonatomic, strong) NSMutableArray *selectPhotoNames;
/* 完成按钮 */
@property (nonatomic, strong) UIButton *completeBtn;
/* 展示已选图片数量 */
@property (nonatomic, strong) UILabel *photoCountLab;
/* 表单 */
@property (nonatomic, strong) UICollectionView *colectView;

@end

@implementation WEImagePickerController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view .backgroundColor = [UIColor whiteColor];
    
    if (self.maxPhotoCount == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = NO;
            picker.delegate = self;
            [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:picker animated:YES completion:nil];
        }

    } else {
        
        if (self.itemPadding == 0) {
            self.itemPadding = 10.f;
        }
        
        if (self.columns == 0) {
            self.columns = 3;
        }
        
        self.photos = [[NSMutableArray alloc]init];
        
        // 布局subviews
        [self initSubviews];
        
        // 计算已选图片
        [self calPhotos];
        
        // 刷新手机相册
        [self setSelectedPic];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //NSMutableArray *arr = [self getAllPhoto];
            //NSLog(@"完成%@ \n照片总数%ld", arr, arr.count);
        });

    }
    
}

- (void)initSubviews {
    
    // 顶部view
    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kNavigationBarHeight)];
    [self.view addSubview:navBarView];
    navBarView.backgroundColor = RGBCOLOR(37, 124, 231);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, ScreenWidth-140, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"相册";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [navBarView addSubview:titleLabel];
    
    // 底部的View
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - kTabBarHeight, ScreenWidth, kTabBarHeight)];
    bottomView.layer.borderColor = RGBCOLOR(230, 230, 230).CGColor;
    bottomView.layer.borderWidth = .5f;
    [bottomView addSubview:self.completeBtn];
    [bottomView addSubview:self.photoCountLab];
    bottomView.backgroundColor = RGBCOLOR(252, 252, 252);
    [self.view addSubview:bottomView];
    
    [self.view addSubview:self.colectView];
}

- (void)calPhotos {
    
    if (self.selectPhotos == nil) {
        self.selectPhotos = [[NSMutableArray alloc]init];
        self.selectPhotoNames = [[NSMutableArray alloc]init];
    } else {
        self.selectPhotoNames=[[NSMutableArray alloc] init];
        for (ALAsset *asset in self.selectPhotos ) {
            if ([asset valueForProperty:ALAssetPropertyAssetURL] != nil) {
                [self.selectPhotoNames addObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
            }
        }
        self.photoCountLab.text=[NSString stringWithFormat:@"已经选择 %lu 张照片",(unsigned long)self.selectPhotos.count];
        
    }
}

- (void)setSelectedPic {
    
    //如果不用单例AssetsLibrary被销毁后 Asset 就没有了
    [[WEAssetHelper defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos|ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if ([group numberOfAssets] > 0) {
            [self showPhoto:group];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

// 遍历手机相册 刷新collectView
- (void)showPhoto:(ALAssetsGroup *)album
{
    if (album != nil) {
        [album setAssetsFilter:[ALAssetsFilter allPhotos]];
        [self.photos removeAllObjects];
        [self.photos addObject:@""];

        [album enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [self.photos addObject:result];
            }
        }];
        [self.colectView reloadData];
        
    }
}


#pragma mark ---UITableViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WEImgPickerPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectImageView.hidden = YES;

    if (indexPath.row == 0) {
        [cell.photoImageView setImage:[UIImage imageNamed:@"takePicture"]];
    } else {
        
        ALAsset *asset=self.photos[indexPath.row];
        UIImage *image =  [UIImage imageWithCGImage:asset.aspectRatioThumbnail];;
        [cell.photoImageView setImage:image];

        NSString *url=[asset valueForProperty:ALAssetPropertyAssetURL];
        if ([_selectPhotoNames indexOfObject:url]==NSNotFound) {
            cell.selectImageView.image = [UIImage imageNamed:@"unselectedPic"];
        } else {
            cell.selectImageView.image = [UIImage imageNamed:@"selectedPic"];
            [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            cell.selected = YES;
        }
        cell.selectImageView.hidden = NO;
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];

        NSLog(@"拍照!");
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = NO;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }

    } else {
        WEImgPickerPhotoCell *cell=(WEImgPickerPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (self.selectPhotos.count >= self.maxPhotoCount) {
            [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            return;
        }
        
        cell.selectImageView.image = [UIImage imageNamed:@"selectedPic"];
        ALAsset *asset=self.photos[indexPath.row];
        [self.selectPhotos addObject:asset];
        [_selectPhotoNames addObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
        
        if(self.selectPhotos.count==0)
        {
            self.photoCountLab.text=@"请选择照片";
        }else
        {
            self.photoCountLab.text=[NSString stringWithFormat:@"已经选择 %lu 张照片",(unsigned long)self.selectPhotos.count];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        WEImgPickerPhotoCell *cell=(WEImgPickerPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.selectImageView.image = [UIImage imageNamed:@"unselectedPic"];
        ALAsset *asset=self.photos[indexPath.row];
        for (ALAsset *a in self.selectPhotos) {
            NSString *str1=[asset valueForProperty:ALAssetPropertyAssetURL];
            NSString *str2=[a valueForProperty:ALAssetPropertyAssetURL];
            if([str1 isEqual:str2])
            {
                [self.selectPhotos removeObject:a];
                break;
            }
        }
        
        [_selectPhotoNames removeObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
        if(self.selectPhotos.count==0)
        {
            self.photoCountLab.text=@"请选择照片";
        }
        else{
            
            self.photoCountLab.text=[NSString stringWithFormat:@"已经选择 %lu 张照片",(unsigned long)self.selectPhotos.count];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = (CGRectGetWidth(collectionView.frame) - 2 * _itemPadding - _itemPadding * (_columns - 1))/_columns;
    return CGSizeMake(w, w);
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取照片的原图
    UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraPhotosDidFinish:)]) {
        [self.delegate cameraPhotosDidFinish:original];
    }
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];

}


#pragma mark - Done

- (void)completeAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectPhotosDidFinish:)]) {
        [self.delegate selectPhotosDidFinish:self.selectPhotos];
    }
    
    if (self.didFinishPickingPhotosHandle) {
        self.didFinishPickingPhotosHandle(self.selectPhotos);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - view getters

- (UIButton *)completeBtn
{
    if (!_completeBtn) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeBtn setTitle:@"Done" forState:UIControlStateNormal];
        _completeBtn.frame = CGRectMake(ScreenWidth - 75, 9, 60, 30);
        _completeBtn.backgroundColor = [UIColor clearColor];
        [_completeBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [_completeBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}

- (UILabel *)photoCountLab
{
    if (!_photoCountLab) {
        _photoCountLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, 200, 30)];
        _photoCountLab.textColor = [UIColor brownColor];
        _photoCountLab.font = [UIFont systemFontOfSize:15];
        NSString *photoCount = [NSString stringWithFormat:@"已经选择 %lu 张照片",(unsigned long)self.selectPhotos.count];
        _photoCountLab.text = self.selectPhotos.count == 0 ?@"请选择照片":photoCount;
    }
    return _photoCountLab;
}

- (UICollectionView *)colectView
{
    if (!_colectView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _colectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight -kTabBarHeight -kNavigationBarHeight) collectionViewLayout:flowLayout];
        _colectView.delegate = self;
        _colectView.dataSource = self;
        flowLayout.sectionInset = UIEdgeInsetsMake(_itemPadding, _itemPadding, _itemPadding, _itemPadding);
        flowLayout.minimumLineSpacing = _itemPadding;
        flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        _colectView.allowsMultipleSelection = YES;
        _colectView.backgroundColor = [UIColor whiteColor];
        [_colectView registerClass:[WEImgPickerPhotoCell class] forCellWithReuseIdentifier:cellIdentifier];
    }
    return _colectView;
}

- (NSMutableArray *)getAllPhoto{
    NSMutableArray *arr = [NSMutableArray array];
    // 所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        PHCollection *collection = smartAlbums[i];
        //遍历获取相册
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            PHAsset *asset = nil;
            if (fetchResult.count != 0) {
                for (NSInteger j = 0; j < fetchResult.count; j++) {
                    //从相册中取出照片
                    asset = fetchResult[j];
                    PHImageRequestOptions *opt = [[PHImageRequestOptions alloc]init];
                    opt.synchronous = YES;
                    PHImageManager *imageManager = [[PHImageManager alloc] init];
                    [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        if (result) {
                            [arr addObject:result];
                        }
                    }];
                }
            }
        }
    }
    
    //返回所有照片
    return arr;
}

@end
