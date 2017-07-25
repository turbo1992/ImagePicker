//
//  ViewController.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/17.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "ViewController.h"
#import "WEPhotoLibrayController.h" // 多选相册
#import "ShowPictureController.h"   // 图片浏览
#import "StytlePtotoShowView.h"     // 小图滑动展示
#import "PhotoModel.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

static char imageViewAssociation;

@interface ViewController ()<ShowPictureControllerDelegate>
{
    NSArray *_photoImages; // 图片数组
    StytlePtotoShowView *_showView; // 单行展示、九宫格展示View
}

@property (nonatomic, strong) NSMutableArray *selectedPhotos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"ImagePicker";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = RGBCOLOR(37, 124, 231);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    // 图片选择
    UIButton *imageSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    imageSelect.frame = CGRectMake(30, 85, ScreenWidth - 60, 35);
    [imageSelect setTitle:@"图片选择" forState:UIControlStateNormal];
    imageSelect.backgroundColor = RGBCOLOR(37, 124, 231);
    imageSelect.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [imageSelect addTarget:self action:@selector(imageSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageSelect];
    
    
    // 图片浏览
    UIButton *imageBrower = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBrower.frame = CGRectMake(30, 135, ScreenWidth - 60, 35);
    [imageBrower setTitle:@"图片浏览" forState:UIControlStateNormal];
    imageBrower.backgroundColor = RGBCOLOR(37, 124, 231);
    imageBrower.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [imageBrower addTarget:self action:@selector(imagePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageBrower];
    
    
    // 图片展示
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 190, ScreenWidth-140, ScreenWidth-140)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.image = DefaultImage;
    [self addAssion:imageView];
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture)];
    [imageView addGestureRecognizer:singleTap];
    
    
    // 图片浏览展示
    _showView = [[StytlePtotoShowView alloc] initWithFrame:CGRectMake(0, 470, ScreenWidth, 200)];
    _showView.showType = StytleSingleType;
    _showView.columns = 4;
    [self.view addSubview:_showView];
    
}

#pragma mark - 图片选择

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)imageSelect {
 
    // 525J: framework
//    WEImagePickerController *imagePicker = [[WEImagePickerController alloc]init];
//    imagePicker.columns = 3;
//    imagePicker.itemPadding = 10;
//    imagePicker.maxPhotoCount = 10;
//    imagePicker.selectPhotos = self.selectedPhotos;
//    imagePicker.delegate = self;
//    
//    [imagePicker setDidFinishPickingPhotosHandle:^(NSMutableArray *assets){
//        
//        self.selectedPhotos = assets;
//        if (assets.count > 0) {
//            ALAsset *asset = self.selectedPhotos[0];
//            UIImageView *imageView = (UIImageView *)[self getAssociation];
//            [imageView setImage:[UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
//        }
//        
//    }];
//    [self presentViewController:imagePicker animated:YES completion:nil];
    
//    __weak typeof (self)weakSelf = self;
    
    // 多选相册
    WEPhotoLibrayController *photoSelector = [WEPhotoLibrayController photoLibrayControllerWithBlock:^(NSArray *images) {
        
        NSLog(@"images count:------>%ld",images.count);
        
        [_showView showInView:self.view photos:images];
        
        UIImageView *imageView = (UIImageView *)[self getAssociation];
        imageView.userInteractionEnabled = YES;
        imageView.image = [images firstObject];
        _photoImages = images;
        
    }];
    photoSelector.multiAlbumSelect = NO;
    photoSelector.navigationBar.barTintColor = RGBCOLOR(37, 124, 231);
    photoSelector.navigationBar.tintColor = [UIColor whiteColor];
    [photoSelector.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    photoSelector.maxCount = 10;
    photoSelector.multiAlbumSelect = YES;
    [self presentViewController:photoSelector animated:YES completion:nil];
}

#pragma mark - 图片浏览
- (void)imagePicker {
    
    ShowPictureController *show = [[ShowPictureController alloc] init];
    show.delegate = self;
    show.imageScaleEnable = YES;
    show.textAligent = TextAlignmentBottom;
    
    NSMutableArray *models = [NSMutableArray array];
    
    NSArray *imageUrls = @[@"http://pic71.nipic.com/file/20150630/914109_163252258000_2.jpg",
                           @"http://pic38.nipic.com/20140227/8175703_133854027355_2.jpg",
                           @"http://img.redocn.com/shejigao/20140114/20140113_4e3ab07b70eecb2f8201yhJzLeItqEJk.jpg",
                           @"http://img.taopic.com/uploads/allimg/140708/235042-140FR2212833.jpg",
                           @"http://pic.qiantucdn.com/58pic/18/41/53/33a58PICZDm_1024.jpg"];
    
    NSArray *titles = @[@"家装套餐首选橱柜,一种精致，一种生活方式",
                        @"新房装修时,很多人都纠结厨房橱柜到底封不封顶,封顶了够不着,不封顶又丑",
                        @"终于等到了乳胶漆阶段，涂刷完毕很多东西就可以就位安装",
                        @"装修是一件复杂又繁琐大事，从最初装修公司的各种狂轰滥炸",
                        @"随着中国家具品牌的增多，也使得中国家具十大品牌排名越来越来受人们关注"];
    
    for (int i = 0; i < imageUrls.count; i++) {
        PhotoModel *model = [[PhotoModel alloc] init];
        model.image_url = imageUrls[i] ;
        model.title = titles[i];
        [models addObject:model];
    }
    
    [show show:self type:PickerTypeShow isInternet:NO index:0 photoViews:models];
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:show animated:YES completion:nil];
}

- (void)singleTapGesture {
    
    ShowPictureController *show = [[ShowPictureController alloc] init];
    show.delegate = self;
    show.isLocalImage = YES;
    
    NSMutableArray *models = [NSMutableArray array];
    
    [_photoImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PhotoModel *model = [[PhotoModel alloc] init];
        model.image = _photoImages[idx];
        [models addObject:model];
        
    }];
    
    [show show:self type:PickerTypeShow isInternet:NO index:0 photoViews:models];
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:show animated:YES completion:nil];
}

#pragma mark - ShowPictureControllerDelegate Delete

- (void)finishWithImages:(NSArray *)images {
    NSLog(@"images count:------>%ld",images.count);
}

#pragma mark - WEImagePickerDelegate

- (void)selectPhotosDidFinish:(NSMutableArray *)assets {
    
    self.selectedPhotos = assets;
    
    NSArray *photos = [self assetsToImages:assets];
    [_showView showInView:self.view photos:photos];
    
    UIImageView *imageView = (UIImageView *)[self getAssociation];
    imageView.userInteractionEnabled = YES;
    _photoImages = photos;
    
}

- (NSArray *)assetsToImages:(NSArray *)assets {
    
    if (assets.count > 0) {
        ALAsset *asset = self.selectedPhotos[0];
        UIImageView *imageView = (UIImageView *)[self getAssociation];
        [imageView setImage:[UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
    }
    
    NSMutableArray *photos = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ALAsset *asset = (ALAsset *)obj;
        [photos addObject:[UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
        
    }];

    return photos;
}

-(void)cameraPhotosDidFinish:(UIImage *)image {
    
    NSMutableArray *photos = [_photoImages mutableCopy];
    [photos insertObject:image atIndex:0];
    _photoImages = [photos mutableCopy];
    [_showView showInView:self.view photos:photos];

    UIImageView *imageView = (UIImageView *)[self getAssociation];
    [imageView setImage:image];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - objc_Association

- (void)addAssion:(id)objc {
    objc_setAssociatedObject(self, &imageViewAssociation, objc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)getAssociation {
    id objc = objc_getAssociatedObject(self, &imageViewAssociation);
    if (objc) {
        return objc;
    }
    return nil;
}

- (void)dealloc {
    objc_setAssociatedObject(self, &imageViewAssociation, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_removeAssociatedObjects(self);
}

@end
