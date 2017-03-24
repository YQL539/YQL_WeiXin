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
    self.navigationItem.title = @"红包设置";
    
    CGFloat iMargin = 5;
    _moneyNum = @"0";
    _moneyStatus = @"恭喜发财,大吉大利!";
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 65+25, screenW, 44*2+1)];
    [self.view addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(iMargin, 4, 18*4, 40)];
    [contentView addSubview:money];
    money.text = @"红包金额";
    money.font = [UIFont systemFontOfSize:16];
    
    UITextField *moneyText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(money.frame) + iMargin, 4, screenW - CGRectGetWidth(money.frame) - iMargin*3, 40)];
    [contentView addSubview:moneyText];
    moneyText.placeholder = @"红包金额";
    moneyText.tag = 100;
    moneyText.delegate = self;
    moneyText.keyboardType = UIKeyboardTypeDecimalPad;
    moneyText.returnKeyType = UIReturnKeyDone;
    moneyText.font = [UIFont systemFontOfSize:15];
    moneyText.textColor = [UIColor colorWithHexString:@"#999999"];
    [moneyText setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    moneyText.textAlignment = NSTextAlignmentRight;
    
    UIView *oneoneDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenW, 0.5)];
    oneoneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [contentView addSubview:oneoneDiv];
    UILabel *state = [[UILabel alloc]initWithFrame:CGRectMake(iMargin, CGRectGetMaxY(oneoneDiv.frame) + 4, 18*4, 40)];
    [contentView addSubview:state];
    state.text = @"红包说明";
    state.font = [UIFont systemFontOfSize:16];
    
    UITextField *statusText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(state.frame) + iMargin, CGRectGetMaxY(oneoneDiv.frame) + 4, screenW - CGRectGetWidth(state.frame) - iMargin*3, 40)];
    [contentView addSubview:statusText];
    statusText.placeholder = @"恭喜发财,大吉大利！";
    statusText.tag = 200;
    statusText.delegate = self;
    statusText.returnKeyType = UIReturnKeyDone;
    statusText.font = [UIFont systemFontOfSize:15];
    statusText.textColor = [UIColor colorWithHexString:@"#999999"];
    [statusText setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    statusText.textAlignment = NSTextAlignmentRight;
    
    //完成
    CGFloat overBtnY = CGRectGetMaxY(contentView.frame) + 25;
    UIButton* completeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, overBtnY, screenW -30, 44)];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    completeBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5959"];
    [completeBtn addTarget:self action:@selector(completeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn.layer setMasksToBounds:YES];
    [completeBtn.layer setCornerRadius:5];
    [self.view addSubview:completeBtn];
}

-(void)completeButtonDidClick:(id)sender{
    [self.view endEditing:YES];
    if (self.didFinishSetRedPacketBlock) {
        self.didFinishSetRedPacketBlock(_moneyNum,_moneyStatus);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark ==========textfield Delegate==========
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 100) {
        _moneyNum = textField.text;
    }else{
        _moneyStatus = textField.text;
    }
    
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 100) {
        _moneyNum = textField.text;
    }else{
        _moneyStatus = textField.text;
    }
    
    [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 100) {
        _moneyNum = textField.text;
    }else{
        _moneyStatus = textField.text;
    }
    return YES;
}


@end
