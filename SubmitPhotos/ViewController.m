//
//  ViewController.m
//  SubmitPhotos
//
//  Created by Leo on 15/2/3.
//  Copyright (c) 2015年 Leo Ling. All rights reserved.
//

#import "ViewController.h"
#import "SubmitPhotos.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    //添加照片提交类
    SubmitPhotos *photo_vc = [[SubmitPhotos alloc]init];
    [self presentViewController: photo_vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
