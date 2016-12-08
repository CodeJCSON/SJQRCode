# SJQRCode

使用说明：1.读取相册中的二维码只支持ios8以上的系统 2.扫码二维码支持ios7以上的系统


QRCode(二维码扫描) 使用iOS系统自带<AVFoundation/AVFoundation.h>框架，实现二维码的的扫描，代码主要分为三个模块，1.SJCameraViewController 配置相机属性 2. SJScanningView 建立视图 3. SJViewController 实现功能



 SJCameraViewControlle简介：
// 配置和控制捕捉会话
- (void)stopSession;
- (void)startSession;
- (BOOL)setupSession:(NSError **)error;

//设置分辨率
- (NSString *)sessionPreset;

//配置输入和输出会话
- (BOOL)setupSessionInputs:(NSError **)error;
- (BOOL)setupSessionOutputs:(NSError **)error;

// 相机显示view
- (void)showCaptureOnView:(UIView *)preview;
//读取相册二维码的图片
- (NSString *)readAlbumQRCodeImage:(UIImage *)imagePicker;





 SJScanningView简介：

//扫描线段的动画
- (void)scanning;
//移除动画
- (void)removeScanningAnimations;


 SJViewController 实现功能

//建立视图
- (void)setupView {
    [self.view addSubview:self.preview];
    [self.view addSubview:self.scanningView];
    [self.cameraController showCaptureOnView:self.preview];
    [self.scanningView scanning];
}

//判断相机是否授权

- (BOOL)isCameraIsAuthorized {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusDenied){
        return NO;
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    return YES;
}

//扫描二维码的结果

- (void)didDetectCodes:(NSArray *)codesArr {
    [self.scanningView removeScanningAnimations];
    
    NSString *metadataString = nil;
    AudioServicesPlaySystemSound(1360);
    AVMetadataMachineReadableCodeObject *MetadataObject = [codesArr objectAtIndex:0];
    metadataString = MetadataObject.stringValue;
   [UIAlertView alertViewTitle:@"tip" message:metadataString delegate:self cancelButtonTitle:@"取消"];
}


关于如何使用：


1：下载本代码
2. 把SJQRCode放进去你的工程
3. 增加代码： 
   
   
    
    SJViewController *viewController = [[SJViewController alloc] init];
    /** successString 扫描成功返回来的数据 */
    viewController.successBlock = ^(NSString *successString) {
    
        [self dismissViewControllerAnimated:YES completion:nil];
       
        NSLog(@"successBlock=%@",successString);
        
        [UIAlertView alertViewTitle:@"tip" message:successString delegate:self cancelButtonTitle:@"取消"];
    };
    
    
    [self presentViewController:viewController animated:YES completion:nil];


如果想了解二维码和条形码的更多类型，请到博客http://blog.csdn.net/sunjie886/article/details/53304913了解。

如有问题，请留言。或者邮件，请大家多多指点，谢谢大家。
 
