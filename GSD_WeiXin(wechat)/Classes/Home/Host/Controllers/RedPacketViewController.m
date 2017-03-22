//
//  RedPacketViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by 胡锦吾 on 2017/3/22.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import "RedPacketViewController.h"

@interface RedPacketViewController ()

@end

@implementation RedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubView];
}

-(void)setSubView{
    [self.view setBackgroundColor:DEFAULT_CHATBOX_COLOR];
    CGFloat iMargin = 5;
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 65+25, screenW, 44*2+1)];
    [self.view addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(iMargin, 0, 20*4, 36)];
    [contentView addSubview:money];
    money.text = @"转账金额";
    [money sizeToFit];
    money.font = [UIFont systemFontOfSize:18];
    UIView *oneoneDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenW, 0.5)];
    oneoneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [contentView addSubview:oneoneDiv];
    
    //完成
    CGFloat overBtnY = CGRectGetMaxY(contentView.frame) + 25;
    UIButton *overBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, overBtnY, screenW -30, 44)];
    [overBtn setTitle:@"完成" forState:UIControlStateNormal];
    overBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5959"];
    [overBtn addTarget:self action:@selector(completeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [overBtn.layer setMasksToBounds:YES];
    [overBtn.layer setCornerRadius:5];
    [self.view addSubview:overBtn];
}

-(void)completeButtonDidClick:(id)sender{
    NSLog(@"完成");
}
@end
