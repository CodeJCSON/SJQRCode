//
//  ViewController.m
//  SJQRCode-2
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

#import "ViewController.h"
#import "SJViewController.h"
#import "UIAlertView+SJAddtions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBtn:(id)sender {
    SJViewController *viewController = [[SJViewController alloc] init];
  
    /** 扫描成功返回来的数据 */
    viewController.successBlock = ^(NSString *successString) {
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"successBlock=%@",successString);
        [UIAlertView alertViewTitle:@"tip" message:successString delegate:self cancelButtonTitle:@"取消"];
    };
    
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
