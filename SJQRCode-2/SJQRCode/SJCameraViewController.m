//
//  SJCameraViewController.m
//  SJQRCode
//
//  Created by Sunjie on 16/11/15.
//  Copyright © 2016年 Sunjie. All rights reserved.
//
//
// 项目还未完成，将继续更新。
//
//
// 初次封装代码，有不足的地方，请大神指教  邮箱：15220092519@163.com
//
//

#import "SJCameraViewController.h"

NSString *const SJCameraErrorDomain = @"com.SJQRCode.SJCameraErrorDomain";
NSString *const SJCameraErrorFailedToAddInput = @"SJThumbnailNotification";

@interface SJCameraViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice *activeCamera;
@property (nonatomic, assign) AVCaptureDeviceInput *activeVideoInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) dispatch_queue_t videoQueue;

@end

@implementation SJCameraViewController

#pragma mark - Propertys

- (AVCaptureVideoPreviewLayer *)captureVideoPreviewLayer {
    if (!_captureVideoPreviewLayer) {
        _captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _captureVideoPreviewLayer;
}

- (NSString *)sessionPreset{                                         
    return AVCaptureSessionPresetHigh;
}

- (dispatch_queue_t)videoQueue {
    return dispatch_queue_create("com.SJQRCode.videoQueue", NULL);
}

#pragma mark - Public Event

- (void)showCaptureOnView:(UIView *)preview {
    NSError *error;
    if ([self setupSession:&error]) {
        [self startSession];
    } else {
        NSLog(@"Error:%@",[error localizedDescription]);
    }
    
    self.captureVideoPreviewLayer.frame = preview.bounds;
    [preview.layer addSublayer:self.captureVideoPreviewLayer];
}

- (void)startSession {
    if (![self.captureSession isRunning]) {
        dispatch_async(self.videoQueue, ^{
            [self.captureSession startRunning];
        });
    }
}

- (void)stopSession {
    if ([self.captureSession isRunning]) {
        dispatch_async(self.videoQueue, ^{
            [self.captureSession stopRunning];
        });
    }
}

- (BOOL)setupSession:(NSError **)error {
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = [self sessionPreset];
    if (![self setupSessionInputs:error]) {
        return NO;
    }
    if (![self setupSessionOutputs:error]) {
        return NO;
    }
    return YES;
}

//AVCaptureAutoFocusRangeRestrictionNear ios7版本新增的属性，允许我们使用一个范围的约束对这个功能进行定制，我们扫描的大部分条码距离都不远，所以可以通过缩小扫描区域来提升识别的成功率。检测是否支持该功能
- (BOOL)setupSessionInputs:(NSError *__autoreleasing *)error {
    BOOL success = [self setupFatherSessionInputs:error];
    if (success) {
        if (self.activeCamera.autoFocusRangeRestrictionSupported) {         // 3
            if ([self.activeCamera lockForConfiguration:error]) {
                self.activeCamera.autoFocusRangeRestriction =
                AVCaptureAutoFocusRangeRestrictionNear;
                [self.activeCamera unlockForConfiguration];
            }
        }
    }
    return success;
}

- (BOOL)setupSessionOutputs:(NSError **)error {
    self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    if ([self.captureSession canAddOutput:self.metadataOutput]) {
        [self.captureSession addOutput:self.metadataOutput];
        dispatch_queue_t mainqueue = dispatch_get_main_queue();
        [self.metadataOutput setMetadataObjectsDelegate:self queue:mainqueue];
        //设置扫描的类型
        NSArray *typesArr = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code];
        self.metadataOutput.metadataObjectTypes = typesArr;
    } else {
        NSDictionary *usernfoDic = @{NSLocalizedDescriptionKey:@"Fail add metadata output"};
         *error = [NSError errorWithDomain:SJCameraErrorDomain code:SJCameraErrorCodeFailedToAddOutput userInfo:usernfoDic];
        return NO;
    }
    return YES;
}

- (BOOL)setupFatherSessionInputs:(NSError **)error {
    AVCaptureDevice *videoDevice =
    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.activeCamera = videoDevice;
    AVCaptureDeviceInput *videoInput =
    [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
    if (videoInput) {
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        } else {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Failed to add video input."};
            *error = [NSError errorWithDomain:SJCameraErrorDomain code:SJCameraErrorCodeFailedToAddInput userInfo:userInfo];
            return NO;
        }
    } else {
        return NO;
    }
    
    return YES;
}

#pragma mark - Configuration Flash

- (BOOL)cameraHasTorch {
    return [[self activeCamera] hasTorch];
}

- (void)setTorchMode:(AVCaptureTorchMode)torchMode{
    AVCaptureDevice *device = [self activeCamera];
    if (device.torchMode != torchMode && [device isTorchModeSupported:torchMode]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.torchMode = torchMode;
            [device unlockForConfiguration];
        } else {
            NSLog(@"%@",error);
        }
    }
}

#pragma mark - Read the photo album of QRCode  读取相册的中二维码

- (NSString *)readAlbumQRCodeImage:(UIImage *)imagePicker {
    CIContext *imageContext = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:imagePicker.CGImage];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:imageContext options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *qrcodeArr = [detector featuresInImage:image];
    NSString *qrCodeString = nil;
    if (!qrcodeArr) {
        for (CIQRCodeFeature *feature in qrcodeArr) {
            qrCodeString = feature.messageString;
        }
    }
    if (qrCodeString) {
        [self stopSession];
    }
    
    return qrCodeString;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate Delagate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        [self stopSession];
        [self.delegate didDetectCodes:metadataObjects];
    }
}

@end
