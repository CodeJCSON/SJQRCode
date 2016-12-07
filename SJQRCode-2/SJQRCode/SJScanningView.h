//
//  SJScanningView.h
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
@property (nonatomic, assign) id<SJScanningViewDelegate> scanningDelegate;

- (void)scanning;
- (void)removeScanningAnimations;

@end
