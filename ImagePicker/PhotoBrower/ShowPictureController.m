//
//  ShowPictureController.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/18.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "ShowPictureController.h"
#import "ImageScrollView.h"
#import "PhotoItemView.h"
#import "PictureView.h"

@interface ShowPictureController ()<UIScrollViewDelegate,UIActionSheetDelegate,PhotoItemViewDelegate>
{
    UILabel *titleLabel;    // 标题
    UILabel *pageLabel;     // 页码
    BOOL isImageDeleted;    // 是否删除了图片
}

/** 图片模型数组 */
@property (nonatomic, strong) NSMutableArray *photoModels;

@property (nonatomic, strong) ImageScrollView *scrollView;

@property (nonatomic, assign) BOOL isNetWork;

@property (nonatomic, assign) PickerShowType type;
/** 总页码 */
@property (nonatomic, assign) NSUInteger pageCount;
/** 当前页 */
@property (nonatomic, assign) NSUInteger page;
/** 初始显示的index */
@property (nonatomic,assign) NSUInteger index;
/** 上一个页码 */
@property (nonatomic, assign) NSUInteger lastPage;
/** 现在显示页面 */
@property (nonatomic,assign) NSUInteger currentIndex;
/** 可重用集合 */
@property (nonatomic,strong) NSMutableSet *reusablePhotoItemViewSetM;
/** 显示中视图字典 */
@property (nonatomic,strong) NSMutableDictionary *visiblePhotoItemViewDictM;
/** 要显示的下一页 */
@property (nonatomic,assign) NSUInteger nextPage;
/** drag时的page */
@property (nonatomic,assign) NSUInteger dragPage;


@end

@implementation ShowPictureController

- (void)show:(UIViewController *)handleVC type:(PickerShowType)type isInternet:(BOOL)flag index:(NSUInteger)index photoViews:(NSArray *)photos
{
    self.photoModels = [NSMutableArray arrayWithArray:photos];
    
    if (_photoModels == nil || _photoModels.count == 0) return ;
    
    if (index >= _photoModels.count)
        return ;
    
    self.index = index;
    self.currentIndex = index;
    
    self.type = type;
    self.isNetWork = flag;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self vcPrepare];
    
    [self topBarView];
    
    // 创建底部图片标题
    if (self.imageScaleEnable) {
        [self bottomTitleView];
    }
    
    [self bottomView];
    
    self.dragPage = -1;
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

#pragma clang diagnostic pop

- (void)vcPrepare {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    self.scrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width+20, size.height)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    [self pagesPrepare];
}

- (void)pagesPrepare {
    
    __block CGRect frame = [UIScreen mainScreen].bounds;
    
    CGFloat widthEachPage = frame.size.width + 20;
    
    [self showWithPage:self.index];
    
    self.scrollView.contentSize = CGSizeMake(widthEachPage * self.photoModels.count, 0);
    
    self.scrollView.index = _index;
}

- (void)topBarView {
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    UIToolbar *topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, size.width, 64)];
    topBar.barStyle = UIBarStyleBlackTranslucent;
    topBar.alpha = 0.5f;
    
    if (self.type == PickerTypeDelete) {
        
        UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
        deleBtn.frame = CGRectMake(size.width-50, 24, 40, 30);
        [deleBtn addTarget:self action:@selector(deleteEvent) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:deleBtn];
    }
    
    [self.view addSubview:topBar];
}

#pragma mark - 图片标题

- (void)bottomTitleView {
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    
    CGFloat x = 10.f;
    CGFloat y = ScreenWidth+(ScreenHeight-ScreenWidth)/2+10.f;
    CGFloat width = ScreenWidth-20.f;
    CGFloat height = 20;
    titleLabel.frame = CGRectMake(x, y, width, height);
    
    [self.view addSubview:titleLabel];
}

#pragma mark - 图片页码

- (void)bottomView {
    
    UIToolbar *bottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, ScreenHeight-44, ScreenWidth, 44)];
    bottomBar.barStyle = UIBarStyleBlackTranslucent;
    bottomBar.alpha = 0.3f;
    [self.view addSubview:bottomBar];
    
    pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-120)*.5, 10, 120, 20)];
    pageLabel.backgroundColor = [UIColor clearColor];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.font = [UIFont systemFontOfSize:18];
    pageLabel.textColor = [UIColor whiteColor];
    [bottomBar addSubview:pageLabel];
}

- (void)showWithPage:(NSUInteger)page {
    
    // 如果对应页码对应的视图正在显示中，就不用再显示了
    if ([self.visiblePhotoItemViewDictM objectForKey:@(page)] != nil) return ;
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    // 取出重用photoItemView
    PhotoItemView *photoItemView = [self dequeReusablePhotoItemView];
    
    if (photoItemView == nil) {
        
        photoItemView = [[PhotoItemView alloc] initWithFrame:CGRectMake((size.width + 20) * page, 0, size.width, size.height)];
        photoItemView.delegate = self;
        photoItemView.imageScaleEnable = self.imageScaleEnable;
        
    } else {
        
        photoItemView.frame = CGRectMake((size.width + 20) * page, 0, size.width, size.height);
        
    }
    
    // 到这里，photoItemView一定有值，而且一定显示为当前页
    // 加入到当前显示中的字典
    [self.visiblePhotoItemViewDictM setObject:photoItemView forKey:@(page)];
    
    photoItemView.pageIndex = page;
    photoItemView.type = self.type;
    
    if (self.photoModels && self.photoModels.count > 0)
    {
        PhotoModel *model = _photoModels[page];
        if (model.image_url) {
            photoItemView.url = model.image_url;
        }
        else
            photoItemView.photoImageView.image = model.fullScreenImage;
        
        photoItemView.photoModel = model;
    }
    
    [self.scrollView addSubview:photoItemView];
}

#pragma mark -
#pragma mark PhotoItemView Delegate Method
- (void)dismissView
{
    if (isImageDeleted) {
        if (_delegate && [_delegate respondsToSelector:@selector(finishWithImages:)] && self.type == PickerTypeDelete) {
            [_delegate finishWithImages:_photoModels];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteEvent
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"要删除这张照片吗?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    
    [self addActionTarget:alert title:@"删除" color:RGBCOLOR(37, 124, 231) action:^(UIAlertAction *action) {
        isImageDeleted = YES;
        [weakSelf deleteImage];
    }];
    
    [self addCancelActionTarget:alert title:@"取消"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}

- (void)deleteImage {
    
    CGRect frame = [UIScreen mainScreen].bounds;
    
    CGFloat widthEachPage = frame.size.width + 20;
    
    [self.photoModels removeObjectAtIndex:self.currentIndex];
    
    for (PhotoItemView *item in self.scrollView.subviews)
    {
        [item removeFromSuperview];
        
        [self.visiblePhotoItemViewDictM removeAllObjects];
    }
    
    if (self.currentIndex > 0) {
        
        self.currentIndex -= 1;
        
        self.scrollView.contentSize = CGSizeMake(widthEachPage * self.photoModels.count, 0);
        self.scrollView.contentOffset = CGPointMake(widthEachPage * self.currentIndex, 0);
        
        self.pageCount = self.photoModels.count;
        [self showWithPage:self.currentIndex];
        
    } else if (self.currentIndex == 0) {
        
        if (self.photoModels.count > 0) {
            
            self.scrollView.contentSize = CGSizeMake(widthEachPage * self.photoModels.count, 0);
            
            self.pageCount = self.photoModels.count;
            
            [self showWithPage:self.currentIndex];
        }
        
    }
    
    if (self.photoModels.count == 0) {
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:0.1];
    } else {
        pageLabel.text = [NSString stringWithFormat:@"%lu/%lu", self.currentIndex+1, (unsigned long)self.pageCount];
        PhotoModel *model = _photoModels[self.page];
        //图片标题
        titleLabel.text = model.title;
        //重置图片标题frame
        [self resetTitleFrame];
        
        [self reuserAndVisibleHandle:self.currentIndex];
    }
    
}

- (PhotoItemView *)dequeReusablePhotoItemView {
    
    PhotoItemView *photoItemView = [self.reusablePhotoItemViewSetM anyObject];
    
    if (photoItemView != nil) {
        
        [self.reusablePhotoItemViewSetM removeObject:photoItemView];
        
        [photoItemView removeFromSuperview];
        
        [photoItemView reset];
    }
    
    return photoItemView;
}

- (NSMutableSet *)reusablePhotoItemViewSetM {
    
    if (_reusablePhotoItemViewSetM == nil)
        _reusablePhotoItemViewSetM = [NSMutableSet set];
    
    return _reusablePhotoItemViewSetM;
}

- (NSMutableDictionary *)visiblePhotoItemViewDictM {
    
    if (_visiblePhotoItemViewDictM == nil)
    {
        _visiblePhotoItemViewDictM = [NSMutableDictionary dictionary];
    }
    
    return _visiblePhotoItemViewDictM;
}

#pragma mark - UIScrollView Delegate Method

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSUInteger page = [self pageCalWithScrollView:scrollView];
    
    //self.drapPage 开始移动页面
    if (self.dragPage == -1) self.dragPage = page;
    
    //self.page 移动到当前页面位置
    self.page = page;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    CGFloat pageOffsetX = self.dragPage * scrollView.bounds.size.width;
    
    if (offsetX > pageOffsetX) { //正在向左滑动，展示右边的页面
        
        if (page >= self.pageCount - 1) return ;
        
        self.nextPage = page + 1;
        
    } else if (offsetX < pageOffsetX) { //正在向右滑动，展示左边的页面
        
        if (page == 0)  return ;
        
        self.nextPage = page - 1;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //重围
    self.dragPage = -1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSUInteger page = [self pageCalWithScrollView:scrollView];
    self.currentIndex = page;
    
    pageLabel.text = [NSString stringWithFormat:@"%lu/%lu", self.currentIndex+1, (unsigned long)self.pageCount];
    PhotoModel *model = _photoModels[self.page];
    //图片标题
    titleLabel.text = model.title;
    //重置图片标题frame
    [self resetTitleFrame];
    
    [self reuserAndVisibleHandle:page];
}

- (void)setNextPage:(NSUInteger)nextPage {
    _nextPage = nextPage;
    [self showWithPage:_nextPage];
}

- (NSUInteger)pageCalWithScrollView:(UIScrollView *)scrollView {
    NSUInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width + .5;
    return page;
}

-(void)reuserAndVisibleHandle:(NSUInteger)page {
    
    //遍历可视视图字典，除了page之外的所有视图全部移除，并加入重用集合
    [self.visiblePhotoItemViewDictM enumerateKeysAndObjectsUsingBlock:^(NSValue *key, PhotoItemView *photoItemView, BOOL *stop) {
        
        if (page == 0) {
            
            if ([key isEqualToValue:@(page)]) {
                
            } else if ([key isEqualToValue:@(page+1)] && ((page+1) < self.pageCount)) {
                
                photoItemView.zoomScale = 1.0;
                
            } else {
                
                photoItemView.zoomScale = 1.0;
                
                [self.reusablePhotoItemViewSetM addObject:photoItemView];
                
                [photoItemView removeFromSuperview];
                
                [self.visiblePhotoItemViewDictM removeObjectForKey:key];
                
            }
            
        } else if (page == self.pageCount - 1) {
            
            if ([key isEqualToValue:@(page)]) {
                
            } else if ([key isEqualToValue:@(page-1)]) {
                
                photoItemView.zoomScale = 1.0;
                
            } else {
                
                photoItemView.zoomScale = 1.0;
                
                [self.reusablePhotoItemViewSetM addObject:photoItemView];
                
                [photoItemView removeFromSuperview];
                
                [self.visiblePhotoItemViewDictM removeObjectForKey:key];
                
            }
            
        } else {
            
            if ([key isEqualToValue:@(page)]) {
                
            } else if ([key isEqualToValue:@(page+1)] || [key isEqualToValue:@(page-1)]) {
                
                photoItemView.zoomScale = 1.0;
                
            } else {
                
                photoItemView.zoomScale = 1.0;
                
                [self.reusablePhotoItemViewSetM addObject:photoItemView];
                
                [photoItemView removeFromSuperview];
                
                [self.visiblePhotoItemViewDictM removeObjectForKey:key];
                
            }
            
        }
        
    }];
}

- (void)setIndex:(NSUInteger)index
{
    _index = index;
}

- (void)setPhotoModels:(NSMutableArray *)photoModels {
    
    if (photoModels == nil || photoModels.count == 0) return ;
    
    _photoModels = (NSMutableArray *)photoModels;
    
    self.pageCount = photoModels.count;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //初始化页码信息
        self.page = _index;
        pageLabel.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)_index+1, (unsigned long)self.pageCount];
        PhotoModel *model = _photoModels[self.page];
        //图片标题
        titleLabel.text = model.title;
        //重置图片标题frame
        [self resetTitleFrame];
    });
}

#pragma mark - Reset frame.size.height

- (void)resetTitleFrame {
    if (!self.imageScaleEnable) {
        return;
    }
    CGFloat height = [self calcTextHight:titleLabel.font text:titleLabel.text width:ScreenWidth-20.f];    CGRect tFrame = titleLabel.frame;
    tFrame.size.height = height;
    titleLabel.frame = tFrame;
}

- (float)calcTextHight:(UIFont *)font text:(NSString *)text width:(CGFloat)width {
    //根据label宽度、内容、字体大小计算高度
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(width, 2000)
                                        options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize.height;
}

#pragma mark - UIAlertController 取消

- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    if ([[UIDevice currentDevice].systemVersion floatValue] > 8.3) {
        [action setValue:[UIColor darkGrayColor] forKey:@"_titleTextColor"];
    }
    [alertController addAction:action];
}

#pragma mark - UIAlertController 添加标题

- (void)addActionTarget:(UIAlertController *)alertController title:(NSString *)title color:(UIColor *)color action:(void(^)(UIAlertAction *))actionTarget {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actionTarget(action);
    }];
    if ([[UIDevice currentDevice].systemVersion floatValue] > 8.3) {
        [action setValue:color forKey:@"_titleTextColor"];
    }
    [alertController addAction:action];
}

@end
