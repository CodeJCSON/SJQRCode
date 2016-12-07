//
//  ViewController.m
//  SJQRCode
//
//  Created by Sunjie on 16/11/15.
//  Copyright © 2016年 Sunjie. All rights reserved.
//
//  读取相册中的二维码只支持ios8以上的系统
//
//
//
//

#import "SJViewController.h"
#import "SJScanningView.h"
#import "SJCameraViewController.h"
#import "UIAlertView+SJAddtions.h"

#define kIsAuthorizedString @"请在iOS - 设置 － 隐私 － 相机 中打开相机权限"

@interface SJViewController ()<SJCameraControllerDelegate,SJScanningViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIView *preview;
@property (nonatomic, strong) SJScanningView *scanningView;
@property (nonatomic, strong) SJCameraViewController *cameraController;
@property (nonatomic, strong) UIImagePickerController *pickerController;

@end

@implementation SJViewController

#pragma mark - Properts

- (SJScanningView *)scanningView {
    if (_scanningView == nil) {
        _scanningView = [[SJScanningView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _scanningView.scanningDelegate = self;
    }
    return _scanningView;
}

- (UIView *)preview {
    if (!_preview) {
        _preview = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _preview;
}

- (SJCameraViewController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[SJCameraViewController alloc] init];
        _cameraController.delegate = self;
    }
    return _cameraController;
}

- (UIImagePickerController *)pickerController {
    if (!_pickerController) {
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _pickerController.delegate = self;
        _pickerController.allowsEditing = NO;
    }
    return _pickerController;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self isCameraIsAuthorized]) {
        [self setupView];
    } else {
        UIAlertView *alert  =  [UIAlertView alertViewTitle:@"相机权限提示" message:kIsAuthorizedString  delegate:self cancelButtonTitle:@"知道了"];
        alert.tag = 1;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SetUp View

- (void)setupView {
    [self.view addSubview:self.preview];
    [self.view addSubview:self.scanningView];
    [self.cameraController showCaptureOnView:self.preview];
    [self.scanningView scanning];
}

#pragma mark - The Camera is Authorized

- (BOOL)isCameraIsAuthorized {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusDenied){
        return NO;
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    return YES;
}

#pragma mark - SJCameraControllerDelegate

- (void)didDetectCodes:(NSArray *)codesArr {
    [self.scanningView removeScanningAnimations];
    
    NSString *metadataString = nil;
    AudioServicesPlaySystemSound(1360);
    AVMetadataMachineReadableCodeObject *MetadataObject = [codesArr objectAtIndex:0];
    metadataString = MetadataObject.stringValue;
   [UIAlertView alertViewTitle:@"tip" message:metadataString delegate:self cancelButtonTitle:@"取消"];
}

#pragma mark - SJScanningViewDelegate BarBUttonItem 点击事件

- (void)clickBarButtonItemSJButtonType:(SJButtonType)type {
    if (type == SJButtonTypeReturn) {
        [self.cameraController stopSession];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (type == SJButtonTypeFlash) {
        [self setFlashMode];
    } else if (type == SJButtonTypeAlbum) {
        [self.cameraController stopSession];
        [self openImagePickerController];
    }
}

#pragma mark - Button Action 

- (void)setFlashMode {
    if ([self.cameraController cameraHasTorch]) {
        [self configurationTorch];
    } else {
        return;
    }
}

#pragma mark - Configuration Torch

- (void)configurationTorch {
    UIButton *button = [self.scanningView viewWithTag:SJButtonTypeFlash];
    button.selected = !button.selected;
    if (button.selected) {
        [self.cameraController setTorchMode:AVCaptureTorchModeOn];
    } else {
        [self.cameraController setTorchMode:AVCaptureTorchModeOff];
    }
}

#pragma mark - Open imagePickController

- (void)openImagePickerController {
    [self presentViewController:self.pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate 

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info; {
    UIImage *pickerImage= [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *resultString = nil;
    if (__IPHONE_8_0) {
      resultString = [self.cameraController readAlbumQRCodeImage:pickerImage];
    }
    //返回图片最后扫描的结果
    NSString *alertMessageString = nil;
    if (resultString) {
        alertMessageString = resultString;
    } else {
        alertMessageString = @"照片中未检测到二维码";
    }
    [UIAlertView alertViewTitle:@"tip" message:alertMessageString delegate:self cancelButtonTitle:@"取消"];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - StatusBarStyle

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
