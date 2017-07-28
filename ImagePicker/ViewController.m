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

@interface ViewController ()<ShowPictureControllerDelegate>
{
    // 图片数组
    NSArray *_photoImages;
    // 小图滑动展示(单行、九宫格)
    StytlePtotoShowView *_showView;
    // 展示图片
    UIImageView *_imageView;
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
    
    [self initUI];
}

- (void)initUI {
    
    // 图片选择
    UIButton *imageSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    imageSelect.frame = CGRectMake(30, 85, self.view.frame.size.width - 60, 35);
    [imageSelect setTitle:@"图片选择" forState:UIControlStateNormal];
    imageSelect.backgroundColor = RGBCOLOR(37, 124, 231);
    imageSelect.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [imageSelect addTarget:self action:@selector(imageSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageSelect];
    
    
    // 图片浏览
    UIButton *imageBrower = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBrower.frame = CGRectMake(30, 135, self.view.frame.size.width - 60, 35);
    [imageBrower setTitle:@"图片浏览" forState:UIControlStateNormal];
    imageBrower.backgroundColor = RGBCOLOR(37, 124, 231);
    imageBrower.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [imageBrower addTarget:self action:@selector(imagePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageBrower];
    
    
    // 图片展示
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 190, self.view.frame.size.width - 140, self.view.frame.size.width - 140)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    _imageView.backgroundColor = RGBCOLOR(230, 230, 230);
    [self.view addSubview:_imageView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture)];
    [_imageView addGestureRecognizer:singleTap];
    
    
    // 小图滑动展示(九宫格、单行展示)
    _showView = [[StytlePtotoShowView alloc] initWithFrame:CGRectMake(0, 470, self.view.frame.size.width, 200)];
    _showView.showType = StytleSingleType;
    _showView.columns = 4;
    [self.view addSubview:_showView];
}

#pragma mark - 图片选择
- (void)imageSelect {
    
    // 多选相册
    WEPhotoLibrayController *photoSelector = [WEPhotoLibrayController photoLibrayControllerWithBlock:^(NSArray *images) {
        
        [_showView showInView:self.view photos:images];
        
        _imageView.userInteractionEnabled = YES;
        _imageView.image = [images firstObject];
        _photoImages = images;
        
    }];
    photoSelector.maxCount = 10;
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
    
    [imageUrls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PhotoModel *model = [[PhotoModel alloc] init];
        model.image_url = imageUrls[idx] ;
        model.title = titles[idx];
        [models addObject:model];
    }];
    
    [show show:self type:PickerTypeDelete isInternet:NO index:0 photoViews:models];
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:show animated:YES completion:nil];
}

#pragma mark - 触摸手势,浏览图片
- (void)singleTapGesture {
    
    // 图片浏览器
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

#pragma mark - 图片浏览器,删除图片代理回调
- (void)deleteImageFinish:(NSArray *)images {
    
    // 删除图片后剩余图片images
    
}

@end
