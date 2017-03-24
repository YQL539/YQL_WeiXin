//
//  TransformViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by 胡锦吾 on 2017/3/22.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import "TransformViewController.h"
#import "CCDatePickerView.h"
@interface TransformViewController ()

@end

@implementation TransformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubView];
}

-(void)setSubView{
    [self.view setBackgroundColor:DEFAULT_CHATBOX_COLOR];
    self.navigationItem.title = @"转账设置";
    
    CGFloat iMargin = 5;
    _moneyNum = @"";
    _moneyStatus = @"";
    _starTime = @"";
    _endTime = @"";
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 65+25, screenW, 44*4+2)];
    [self.view addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(iMargin, 4, 18*4, 40)];
    [contentView addSubview:money];
    money.text = @"转账金额";
    money.font = [UIFont systemFontOfSize:16];
    
    UITextField *moneyText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(money.frame) + iMargin, 4, screenW - CGRectGetWidth(money.frame) - iMargin*3, 40)];
    [contentView addSubview:moneyText];
    moneyText.placeholder = @"请输入";
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
    
    UILabel *starTime = [[UILabel alloc]initWithFrame:CGRectMake(iMargin, CGRectGetMaxY(oneoneDiv.frame) + 4, 18*4, 40)];
    [contentView addSubview:starTime];
    starTime.text = @"转账时间";
    starTime.font = [UIFont systemFontOfSize:16];
    
    //时间选择器
    UIButton *starBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(starTime.frame) + iMargin,CGRectGetMaxY(oneoneDiv.frame) + 4, screenW - CGRectGetWidth(starTime.frame) - iMargin*3, 40)];
    [contentView addSubview:starBtn];
    [starBtn setTitle:@"选择时间" forState:UIControlStateNormal];
    [starBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [starBtn addTarget:self action:@selector(starBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *twoDiv = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(starTime.frame), screenW, 0.5)];
    twoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [contentView addSubview:twoDiv];
    
    UILabel *endTime = [[UILabel alloc]initWithFrame:CGRectMake(iMargin, CGRectGetMaxY(twoDiv.frame) + 4, 18*4, 40)];
    [contentView addSubview:endTime];
    endTime.text = @"到账时间";
    endTime.font = [UIFont systemFontOfSize:16];
    //时间选择器
    UIButton *endBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(endTime.frame) + iMargin,CGRectGetMaxY(twoDiv.frame) + 4, screenW - CGRectGetWidth(endTime.frame) - iMargin*3, 40)];
    [contentView addSubview:endBtn];
    [endBtn setTitle:@"选择时间" forState:UIControlStateNormal];
    [endBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [endBtn addTarget:self action:@selector(endBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *threeDiv = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(endTime.frame), screenW, 0.5)];
    threeDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [contentView addSubview:threeDiv];
    UILabel *state = [[UILabel alloc]initWithFrame:CGRectMake(iMargin, CGRectGetMaxY(threeDiv.frame) + 4, 18*4, 40)];
    [contentView addSubview:state];
    state.text = @"转账说明";
    state.font = [UIFont systemFontOfSize:16];
    UITextField *statusText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(state.frame) + iMargin, CGRectGetMaxY(threeDiv.frame) + 4, screenW - CGRectGetWidth(state.frame) - iMargin*3, 40)];
    [contentView addSubview:statusText];
    statusText.placeholder = @"请输入";
    statusText.tag = 200;
    statusText.delegate = self;
    statusText.returnKeyType = UIReturnKeyDone;
    statusText.font = [UIFont systemFontOfSize:15];
    statusText.textColor = [UIColor colorWithHexString:@"#999999"];
    [statusText setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    statusText.textAlignment = NSTextAlignmentRight;
    
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

-(void)starBtnDidClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    CCDatePickerView *dateView=[[CCDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:dateView];
    __block UIButton *Button = sender;
    dateView.blcok = ^(NSDate *dateString){
        NSLog(@"年 = %ld  月 = %ld  日 = %ld  时 = %ld  分 = %ld",(long)dateString.year,(long)dateString.month,(long)dateString.day,dateString.hour,dateString.minute);
        _starTime = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld",(long)dateString.year,(long)dateString.month,(long)dateString.day,dateString.hour,dateString.minute,dateString.seconds];
        [Button setTitle:_starTime forState:UIControlStateNormal];
        NSLog(@"%@",_starTime);
    };
    dateView.chooseTimeLabel.text = @"选择时间";
    [dateView fadeIn];

}

-(void)endBtnDidClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    CCDatePickerView *dateView=[[CCDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:dateView];
    __block UIButton *Button = sender;
    dateView.blcok = ^(NSDate *dateString){
        NSLog(@"年 = %ld  月 = %ld  日 = %ld  时 = %ld  分 = %ld",(long)dateString.year,(long)dateString.month,(long)dateString.day,dateString.hour,dateString.minute);
        _endTime = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld",(long)dateString.year,(long)dateString.month,(long)dateString.day,dateString.hour,dateString.minute,dateString.seconds];
        [Button setTitle:_endTime forState:UIControlStateNormal];
        NSLog(@"%@",_endTime);
    };
    dateView.chooseTimeLabel.text = @"选择时间";
    [dateView fadeIn];
    
}

-(void)completeButtonDidClick:(id)sender{
    if (_starTime.length > 0 && _endTime.length > 0 && _moneyNum.length > 0) {
        [self.view endEditing:YES];
        if (self.didFinishSetTransformBlock) {
            self.didFinishSetTransformBlock(_moneyNum,_moneyStatus,_starTime,_endTime);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入完整" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag == 100) {
        _moneyNum = textField.text;
    }else{
        _moneyStatus = textField.text;
    }
    return YES;
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
