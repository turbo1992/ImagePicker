//
//  ViewController.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/17.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "ViewController.h"
#import "TZImagePickerController.h" // 多选相册
#import "WEImagePickerController.h"
#import "ShowPictureController.h"   // 图片浏览
#import "PhotoModel.h"              // 浏览图片model
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

static char imageViewAssociation;

@interface ViewController ()<TZImagePickerControllerDelegate,PhotoSelectedDelegate,ShowPictureControllerDelegate>
{
    PhotoModel *imageModel;
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
    imageSelect.frame = CGRectMake(30, 100, ScreenWidth - 60, 55);
    [imageSelect setTitle:@"图片选择" forState:UIControlStateNormal];
    imageSelect.backgroundColor = RGBCOLOR(37, 124, 231);
    imageSelect.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [imageSelect addTarget:self action:@selector(imageSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageSelect];
    
    
    // 图片浏览
    UIButton *imageBrower = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBrower.frame = CGRectMake(30, 185, ScreenWidth - 60, 55);
    [imageBrower setTitle:@"图片浏览" forState:UIControlStateNormal];
    imageBrower.backgroundColor = RGBCOLOR(37, 124, 231);
    imageBrower.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [imageBrower addTarget:self action:@selector(imagePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageBrower];
    
    
    // 图片展示
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 290, ScreenWidth-140, ScreenWidth-140)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.image = DefaultImage;
    [self addAssion:imageView];
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    [imageView addGestureRecognizer:singleTap];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+30, ScreenWidth, 20)];
    label.text = @"展示删除图片后的第一张图,点击图片查看";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
}

#pragma mark - 图片选择
- (void)imageSelect {
/*
    // 谭真: github demo
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.navigationBar.barTintColor = RGBCOLOR(37, 124, 231);
    imagePickerVc.navigationBar.tintColor = [UIColor whiteColor];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        UIImageView *imageView = (UIImageView *)[self getAssociation];
        imageView.image = photos[0];
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
 */
 
    // 525J: framework
    WEImagePickerController *imagePicker = [[WEImagePickerController alloc]init];
    imagePicker.columns = 3;
    imagePicker.itemPadding = 10;
    imagePicker.maxPhotoCount = 9;
    imagePicker.selectPhotos = self.selectedPhotos;
    imagePicker.selectPhotoDelegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - 图片浏览
- (void)imagePicker {
    
    ShowPictureController *show = [[ShowPictureController alloc] init];
    show.delegate = self;
    show.imageScaleEnable = YES;
    
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
    
    [show show:self type:PickerTypeDelete isInternet:NO index:0 photoViews:models];
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:show animated:YES completion:nil];
}

#pragma mark - ShowPictureControllerDelegate Delete

- (void)finishWithImages:(NSArray *)images {
    
    NSLog(@"images count:------>%ld",images.count);
    
    if (images.count > 0) {
        imageModel = images[0];
        UIImageView *imageView = (UIImageView *)[self getAssociation];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.image_url] placeholderImage:DefaultImage];
    }

}

#pragma mark - 查看单图
- (void)singleTap {
    
    ShowPictureController *show = [[ShowPictureController alloc] init];
    show.delegate = self;
    
    NSMutableArray *models = [NSMutableArray array];
    
    [models addObject:imageModel];
    
    [show show:self type:PickerTypeShow isInternet:NO index:0 photoViews:models];
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:show animated:YES completion:nil];

}

#pragma mark - WEImagePickerDelegate
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)selectPhotosDidFinish:(NSMutableArray *)photos {
    
    self.selectedPhotos = photos;
    
    if (photos.count > 0) {
        ALAsset *asset = [self.selectedPhotos lastObject];
        UIImageView *imageView = (UIImageView *)[self getAssociation];
        [imageView setImage:[UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
    }
    
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
