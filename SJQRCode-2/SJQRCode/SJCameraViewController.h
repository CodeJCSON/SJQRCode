//
//  SJCameraViewController.h
//  SJQRCode
//
//  Created by Sunjie on 16/11/15.
//  Copyright © 2016年 Sunjie. All rights reserved.
//
// 项目还没封装完成，初期作品

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
