//
//  StytlePtotoShowView.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/21.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "StytlePtotoShowView.h"
#import "ShowPictureController.h"
#import "PhotoModel.h"

static NSString *cellIdentifier = @"StytlePhotoCell";

@interface StytlePtotoShowView ()<UICollectionViewDelegate,UICollectionViewDataSource>

/* 展示列表 */
@property (nonatomic, strong) UICollectionView *collectionView;
/* 图片 */
@property (nonatomic, strong) NSArray *photos;

@end

@class StytlePhotoCell;

@implementation StytlePtotoShowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        if (self.itemPadding == 0) {
            self.itemPadding = 10.f;
        }
        
        if (self.columns == 0) {
            self.columns = 3;
        }
    
        [self addSubview:self.collectionView];
        
    }
    return self;
}

- (void)showInView:(UIView *)view photos:(NSArray *)photos {

    [view addSubview:self];
    
    self.photos = photos;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.minimumLineSpacing = _itemPadding;
    flowLayout.sectionInset = UIEdgeInsetsMake(_itemPadding, _itemPadding, _itemPadding, _itemPadding);
    
    if (self.showType == StytleSingleType)//高度适配
    {
        CGFloat h = (CGRectGetWidth(self.collectionView.frame) - 2 * _itemPadding - _itemPadding * (_columns - 1))/_columns;
    
        CGRect viewFrame = self.frame;
        viewFrame.size.height = h;
        self.frame = viewFrame;
        
        CGRect collectFrame = self.collectionView.frame;
        collectFrame.size.height = h;
        self.collectionView.frame = collectFrame;
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    [self.collectionView setCollectionViewLayout:flowLayout];

    [self.collectionView reloadData];
    
}

#pragma mark - UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StytlePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImage *image = self.photos[indexPath.row];
    [cell.photoImageView setImage:image];
  
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (CGRectGetWidth(collectionView.frame) - 2 * _itemPadding - _itemPadding * (_columns - 1))/_columns;
    return CGSizeMake(w, w);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ShowPictureController *show = [[ShowPictureController alloc] init];
    show.isLocalImage = YES;
    
    NSMutableArray *models = [NSMutableArray array];
    
    [self.photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PhotoModel *model = [[PhotoModel alloc] init];
        model.image = self.photos[idx];
        [models addObject:model];
        
    }];
    
    [show show:nil type:PickerTypeShow isInternet:NO index:indexPath.row photoViews:models];
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:show animated:YES completion:nil];
}


#pragma mark - view getters

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        flowLayout.sectionInset = UIEdgeInsetsMake(_itemPadding, _itemPadding, _itemPadding, _itemPadding);
        flowLayout.minimumLineSpacing = _itemPadding;
        flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[StytlePhotoCell class] forCellWithReuseIdentifier:cellIdentifier];
    }
    return _collectionView;
}

@end

@implementation StytlePhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // 相册图片
        self.photoImageView.frame = CGRectMake(.0f, .0f, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self.contentView addSubview:self.photoImageView];
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

@end
