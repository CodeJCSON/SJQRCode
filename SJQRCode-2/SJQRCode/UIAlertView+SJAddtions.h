//
//  UIAlertView+SJAddtions.h
//  SJQRCode
//
//  Created by 中创 on 16/12/5.
//  Copyright © 2016年 Sunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (SJAddtions)

+ (UIAlertView *)alertViewTitle:(NSString *)title message:(NSString *)mess delegate:(id)delegate cancelButtonTitle:(NSString *)cancelBtn;
+ (UIAlertView *)alertViewTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelBtn otherButtonTitles:(NSString *)otherBtn;

@end
