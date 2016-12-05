//
//  ViewController.m
//  SJQRCode-2
//
//  Created by 中创 on 16/12/5.
//  Copyright © 2016年 中创. All rights reserved.
//

#import "ViewController.h"
#import "SJViewController.h"

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
    [self presentViewController:[[SJViewController alloc] init] animated:YES completion:nil];
}

@end
