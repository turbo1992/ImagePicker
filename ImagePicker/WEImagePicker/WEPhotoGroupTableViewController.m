//
//  WEPhotoGroupTableViewController.m
//  ImagePicker
//
//  Created by Turbo on 2017/7/24.
//  Copyright © 2017年 Turbo. All rights reserved.
//

#import "WEPhotoGroupTableViewController.h"
#import "WEPhotoGroupDetailController.h"

@interface WEPhotoGroupTableViewController ()

/* 相簿无照片提示 */
@property(nonatomic,   weak) UIView *errorMessageView;
/* 相册详情 */
@property(nonatomic, strong) WEPhotoGroupDetailController *photoGroupDetailController;

@end

@implementation WEPhotoGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相簿";
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnDidClick)];
}

- (void)cancelBtnDidClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 相册数据
- (void)setPhotoGroupArray:(NSArray *)photoGroupArray{
    _photoGroupArray = photoGroupArray;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.photoGroupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WEPhotoGroupCell *cell = [WEPhotoGroupCell cellWithTableView:tableView];
    WEPhotoGroup *photoGroup = self.photoGroupArray[indexPath.section];
    if (photoGroup.photoALAssets.count == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    cell.photoGroup = photoGroup;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WEImagePicker_Item_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WEPhotoGroup *photoGroup = self.photoGroupArray[indexPath.section];
    
    if (photoGroup.photoALAssets.count == 0) return;
    
    WEPhotoGroupDetailController *photoGroupDetailController;
    
    if (!self.canMultiAlbumSelect) {
        
        for (WEPhotoGroup *photoGroup in self.photoGroupArray) {
            for (WEPhotoALAssets *photoALAssets in photoGroup.photoALAssets) {
                photoALAssets.selected = NO;
            }
        }
        photoGroupDetailController = [[WEPhotoGroupDetailController alloc]init];
        photoGroupDetailController.maxCount = self.maxCount;
        photoGroupDetailController.block = self.block;


    } else {
        if (!_photoGroupDetailController) {
            _photoGroupDetailController = [[WEPhotoGroupDetailController alloc]init];
            _photoGroupDetailController.maxCount = self.maxCount;
            _photoGroupDetailController.block = self.block;
        }
        photoGroupDetailController = _photoGroupDetailController;
    }
    photoGroupDetailController.photoALAssets = photoGroup.photoALAssets;
    photoGroupDetailController.groupName = photoGroup.groupName;
    [self.navigationController pushViewController:photoGroupDetailController animated:YES];
}

#pragma mark - 相簿无照片展示

- (void)showErrorMessageView {
    self.errorMessageView.hidden = NO;
}

#pragma mark - obj getters && setters

- (void)setMaxCount:(NSInteger)maxCount {
    _maxCount = maxCount;
}

- (UIView *)errorMessageView {
    
    if (!_errorMessageView) {
        UIView *errorMessageView = [[UIView alloc]init];
        errorMessageView.backgroundColor = [UIColor whiteColor];
        errorMessageView.frame = self.view.bounds;
        errorMessageView.hidden = YES;
        self.errorMessageView = errorMessageView;
        [self.view addSubview:errorMessageView];
        
        UILabel *msgLabel = [[UILabel alloc]init];
        msgLabel.text = @"未能读取到任何照片";
        msgLabel.backgroundColor = [UIColor clearColor];
        msgLabel.font = [UIFont systemFontOfSize:15];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.textColor = [UIColor lightGrayColor];
        CGFloat msgLabelHeight = 15;
        msgLabel.frame = CGRectMake(0, (CGRectGetHeight(errorMessageView.frame) - msgLabelHeight - 64) * 0.5 , CGRectGetWidth(errorMessageView.frame), msgLabelHeight);
        [errorMessageView addSubview:msgLabel];
        
        _errorMessageView = errorMessageView;
    }
    return _errorMessageView;
}

@end


// 相册组列表cell
@implementation WEPhotoGroupCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"WEPhotoGroupCell";
    
    WEPhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WEPhotoGroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubView];
    }
    return self;
}

- (void)setSubView {
    
    // 相册封面
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.layer.masksToBounds = YES;
    iconView.backgroundColor = [UIColor clearColor];
    self.iconView = iconView;
    [self addSubview:iconView];
    
    // 相册信息
    UILabel *infoLabel = [[UILabel alloc]init];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.font = [UIFont systemFontOfSize:16];
    self.infoLabel = infoLabel;
    [self addSubview:infoLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 12;
    CGFloat controlWH = 44;
    CGFloat marginLR = 15;
    CGFloat marginTB = (CGRectGetHeight(self.frame) - controlWH) * 0.5;
    
    _iconView.frame = CGRectMake(marginLR, marginTB, controlWH, controlWH);
    
    _infoLabel.frame = CGRectMake(CGRectGetMaxX(_iconView.frame) + padding, marginTB, CGRectGetWidth(self.frame) - CGRectGetMaxX(_iconView.frame) - marginLR, controlWH);
}

// 设置相册数据
- (void)setPhotoGroup:(WEPhotoGroup *)photoGroup {
    _photoGroup = photoGroup;
    [self.iconView setImage:photoGroup.groupIcon];
    self.infoLabel.text = [NSString stringWithFormat:@"%@(%zd)",photoGroup.groupName,photoGroup.photoALAssets.count];
}

@end
