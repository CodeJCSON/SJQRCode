//
//  SJScanningView.h
//  SJQRCode
//
//  Created by Sunjie on 16/11/15.
//  Copyright © 2016年 Sunjie. All rights reserved.
//
// 项目还没封装完成，初期作品

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, SJButtonType){
    SJButtonTypeReturn = 1,
    SJButtonTypeAlbum,
    SJButtonTypeFlash,
};

@protocol SJScanningViewDelegate <NSObject>

- (void)clickBarButtonItemSJButtonType:(SJButtonType)type;

@end

@interface SJScanningView : UIView

@property (nonatomic, assign) BOOL isRestrict;
@property (nonatomic, strong) UIImageView *scanningImageView;
@property (nonatomic, assign) id<SJScanningViewDelegate> scanningDelegate;

- (void)scanning;

@end
