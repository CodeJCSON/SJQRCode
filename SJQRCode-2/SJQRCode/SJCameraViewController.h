//
//  SJCameraViewController.h
//  SJQRCode
//
//  Created by Sunjie on 16/11/15.
//  Copyright © 2016年 Sunjie. All rights reserved.
//
// 项目还未完成，将继续更新。
//
//
// 初次封装代码，有不足的地方，请大神指教  邮箱：15220092519@163.com
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol SJCameraControllerDelegate <NSObject>

- (void)didDetectCodes:(NSArray *)codesArr;

@end

FOUNDATION_EXPORT NSString *const SJCameraErrorDomain;
FOUNDATION_EXPORT NSString *const SJCameraErrorFailedToAddInput;

typedef NS_ENUM(NSInteger, SJCameraErrorCode) {
    SJCameraErrorCodeFailedToAddInput = 98,
    SJCameraErrorCodeFailedToAddOutput    ,
};

@interface SJCameraViewController : NSObject

@property (nonatomic, assign) id <SJCameraControllerDelegate> delegate;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, assign) CGRect rectrectOfInterest;
@property (nonatomic, assign) BOOL cameraHasTorch;
@property (nonatomic, assign) AVCaptureTorchMode torchMode;

// Session Configuration
- (void)stopSession;
- (void)startSession;
- (BOOL)setupSession:(NSError **)error;


- (NSString *)sessionPreset;
- (BOOL)setupSessionInputs:(NSError **)error;
- (BOOL)setupSessionOutputs:(NSError **)error;

- (void)showCaptureOnView:(UIView *)preview;

- (NSString *)readAlbumQRCodeImage:(UIImage *)imagePicker;

@end
