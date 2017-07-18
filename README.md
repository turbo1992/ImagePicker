# ImagePicker
简易图片浏览器,含图片标题,删除图片功能

初始化控制器ShowPictureController，传入图片模型数组models，调用show方法即可
ShowPictureController *show = [[ShowPictureController alloc] init];
show.delegate = self; 
NSMutableArray *models = [NSMutableArray array];
[models addObject:imageModel];    
[show show:self type:PickerTypeShow isInternet:NO index:0 photoViews:models];
[[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:show animated:YES completion:nil];

