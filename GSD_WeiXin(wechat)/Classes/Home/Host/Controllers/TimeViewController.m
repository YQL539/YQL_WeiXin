//
//  TimeViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by 胡锦吾 on 2017/3/24.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import "TimeViewController.h"

@interface TimeViewController ()

@end

@implementation TimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubView];
}

-(void)setSubView{
    [self.view setBackgroundColor:DEFAULT_CHATBOX_COLOR];
    self.navigationItem.title = @"时间设置";
    
    CGFloat iMargin = 5;
    _time = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 65+25, screenW, 44+1)];
    [self.view addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(iMargin, 4, 18*4, 40)];
    [contentView addSubview:money];
    money.text = @"设置时间";
    money.font = [UIFont systemFontOfSize:16];
    
    UITextField *moneyText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(money.frame) + iMargin, 4, screenW - CGRectGetWidth(money.frame) - iMargin*3, 40)];
    [contentView addSubview:moneyText];
    moneyText.placeholder = @"时间格式请参照下面样式";
    moneyText.tag = 100;
    moneyText.delegate = self;
    moneyText.returnKeyType = UIReturnKeyDone;
    moneyText.font = [UIFont systemFontOfSize:15];
    moneyText.textColor = [UIColor colorWithHexString:@"#999999"];
    [moneyText setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    moneyText.textAlignment = NSTextAlignmentRight;
    
    UIView *oneoneDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenW, 0.5)];
    oneoneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [contentView addSubview:oneoneDiv];
    
    //完成
    CGFloat overBtnY = CGRectGetMaxY(contentView.frame) + 25;
    UIButton* completeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, overBtnY, screenW -30, 44)];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    completeBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5959"];
    [completeBtn addTarget:self action:@selector(completeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn.layer setMasksToBounds:YES];
    [completeBtn.layer setCornerRadius:5];
    [self.view addSubview:completeBtn];
    
    UILabel *pShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(completeBtn.frame) + 25, screenW - 30, 150)];
    pShowLabel.text = @"格式举例(=后面为输入的格式):\n1,今天=下午8:59\n2,昨天=昨天 下午10:43\n3,昨天之前=星期三 下午11:42\n4,一周之前=2016年8月8日 上午11:58";
    pShowLabel.numberOfLines = 5;
    [self.view addSubview:pShowLabel];
}

-(void)completeButtonDidClick:(id)sender{
    [self.view endEditing:YES];
    if (self.didFinishSetTimeBlock) {
        self.didFinishSetTimeBlock(_time);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark ==========textfield Delegate==========
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    _time = textField.text;
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    _time = textField.text;
    return YES;
}

@end
