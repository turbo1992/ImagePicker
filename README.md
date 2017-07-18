# ImagePicker
简易图片浏览器,含图片标题,删除图片功能

![image](https://github.com/turbo1992/ImagePicker/raw/master/ImageBrower.gif)

# PhotoBrower
PhotoBrower为图片浏览器，TZImagePickerController是从github下载的图片多选demo
将PhotoBrower文件拷贝至所需项目即可!

    show.delegate = self;
    
代理方法为图片删除功能，不需要此功能可不设置delegate;

# 基本用法
初始化控制器ShowPictureController，传入图片模型数组models，调用show方法即可

    ShowPictureController *show = [[ShowPictureController alloc] init];
    show.delegate = self;
    
    NSMutableArray *models = [NSMutableArray array];
    
    [models addObject:imageModel];
    
    [show show:self type:PickerTypeShow isInternet:NO index:0 photoViews:models];
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:show animated:YES completion:nil];

# 图片删除功能

typedef enum {
    PickerTypeShow, // 展示图片
    PickerTypeDelete// 删除
} PickerShowType;

调用show方法时选择PickerTypeDelete即可！

    [show show:self type:PickerTypeDelete isInternet:NO index:0 photoViews:models];
    
    #pragma mark - ShowPictureControllerDelegate Delete

通过代理可获取删除后剩余的图片model数组
- (void)finishWithImages:(NSArray *)images {
    
    NSLog(@"images count:------>%ld",images.count);

}



# 图片加标题展示

图片加入标题，则每页图片高度设置为屏幕宽度，标题居于图片下方，初始化控制器时设置属性imageScaleEnable 

    ShowPictureController *show = [[ShowPictureController alloc] init];
    show.delegate = self;
    show.imageScaleEnable = YES;
    
