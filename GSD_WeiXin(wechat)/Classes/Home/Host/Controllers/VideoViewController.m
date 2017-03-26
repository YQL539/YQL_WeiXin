//
//  VideoViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by 胡锦吾 on 2017/3/26.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()
@property (nonatomic,strong) UIImageView *pShowView;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubView];
}

-(void)setSubView{
    [self.view setBackgroundColor:DEFAULT_CHATBOX_COLOR];
    self.navigationItem.title = @"视频设置";
    
    CGFloat iMargin = 5;
    _minutes = @"00";
    _seconds = @"00";
    
    _pShowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH)];
    _pShowView.userInteractionEnabled = YES;
    UIImage *img1 = [UIImage imageWithData:_model.Fpicture];
    __block UIImage *img = [[UIImage alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        img = [CommonUtil coreBlurImage:img1 withBlurNumber:10];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_pShowView setImage:img];
            _pShowView.contentMode = UIViewContentModeScaleToFill;
        });
    });

    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 65+25, screenW, 44*2+1)];
    [self.view addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(iMargin, 4, 18*4, 40)];
    [contentView addSubview:money];
    money.text = @"分钟";
    money.font = [UIFont systemFontOfSize:16];
    
    UITextField *moneyText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(money.frame) + iMargin, 4, screenW - CGRectGetWidth(money.frame) - iMargin*3, 40)];
    [contentView addSubview:moneyText];
    moneyText.placeholder = @"分钟(1-59)";
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
    state.text = @"秒数";
    state.font = [UIFont systemFontOfSize:16];
    
    UITextField *statusText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(state.frame) + iMargin, CGRectGetMaxY(oneoneDiv.frame) + 4, screenW - CGRectGetWidth(state.frame) - iMargin*3, 40)];
    [contentView addSubview:statusText];
    statusText.placeholder = @"秒数(1-59)";
    statusText.tag = 200;
    statusText.delegate = self;
    statusText.keyboardType = UIKeyboardTypeDecimalPad;
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
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:_pShowView];
    UIButton *SuoXiaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(35/2, 30/2 + STATUSBAR_HEIGHT, 52/2, 38/2)];
    [_pShowView addSubview:SuoXiaoBtn];
    [SuoXiaoBtn setBackgroundImage:[UIImage imageNamed:@"suoxiao"] forState:UIControlStateNormal];
    SuoXiaoBtn.userInteractionEnabled = YES;
    
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake((screenW - 210/2)/2, CGRectGetMaxY(SuoXiaoBtn.frame) + 194/2, 210/2, 210/2)];
    [_pShowView addSubview:headView];
    headView.image =  [UIImage imageWithData:_model.Fpicture];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake((screenW - 210/2)/2, CGRectGetMaxY(headView.frame) + 36/2, 210/2, 48/2)];
    nameLabel.textColor = [UIColor whiteColor];
    [_pShowView addSubview:nameLabel];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [_pShowView bringSubviewToFront:nameLabel];
    nameLabel.text = _model.FName;

    CGFloat iY = screenH - 25 - 160/2;
    
    UIButton *jinyinBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, iY, 111/2, 160/2)];
    [_pShowView addSubview:jinyinBtn];
    [jinyinBtn setBackgroundImage:[UIImage imageNamed:@"jinyin"] forState:UIControlStateNormal];
    jinyinBtn.userInteractionEnabled = NO;
    
    UIButton *guaDuanBtn = [[UIButton alloc] initWithFrame:CGRectMake((screenW - 111/2)/2, iY, 111/2, 160/2)];
    [_pShowView addSubview:guaDuanBtn];
    [guaDuanBtn setBackgroundImage:[UIImage imageNamed:@"guaduan"] forState:UIControlStateNormal];
    [guaDuanBtn addTarget:self action:@selector(sendAndDismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *mianTiBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenW - 50 - 111/2, iY, 111/2, 160/2)];
    [_pShowView addSubview:mianTiBtn];
    [mianTiBtn setBackgroundImage:[UIImage imageNamed:@"mianti"] forState:UIControlStateNormal];
    mianTiBtn.userInteractionEnabled = NO;
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake((screenW - 111/2)/2, iY - 28 - 52/2, 111/2, 28)];
    [_pShowView addSubview:timeLabel];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    NSUInteger iM = [_minutes integerValue];
    NSUInteger iS = [_seconds integerValue];
    timeLabel.text = [NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)iM,(unsigned long)iS];
}

-(void)sendAndDismiss:(UIButton *)sender{
        if (self.didFinishSetVideoBlock) {
            self.didFinishSetVideoBlock(_minutes,_seconds);
        }
    [_pShowView removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark ==========textfield Delegate==========
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 100) {
        _minutes = textField.text;
    }else{
        _seconds = textField.text;
    }
    
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 100) {
        _minutes = textField.text;
    }else{
        _seconds = textField.text;
    }
    
    [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 100) {
        _minutes = textField.text;
    }else{
        _seconds = textField.text;
    }
    return YES;
}
@end
