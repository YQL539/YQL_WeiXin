//
//  SDAddSomeController.m
//  GSD_WeiXin(wechat)
//
//  Created by apple on 17/3/12.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import "SDAddSomeController.h"
#import "ALDActionSheet.h"

@interface SDAddSomeController ()<ALDActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (nonatomic,weak) UIScrollView *homeScroll;
@property (nonatomic,weak) UIButton *selectBtn;
@property (nonatomic,weak) UIImageView *oneImage;
@property (nonatomic,strong) NSMutableDictionary *homeDic;
@property (nonatomic,weak) UITextField *oneText;
@property (nonatomic,weak) UILabel *threeoneLabel;
@property (nonatomic,weak) UILabel *fouroneLabel;
@property (nonatomic,weak) UITextField *twoText;

//记住要不要置顶聊天
@property (nonatomic,assign) int topNum;
@property (nonatomic,assign) NSMutableArray *friendList;


@property (nonatomic,weak) UIImageView *onetwoImage;
@property (nonatomic,weak) UITextField *onetwoText;
@property (nonatomic,weak) UILabel *threeonetwoLabel;
@property (nonatomic,weak) UILabel *fouronetwoLabel;
@property (nonatomic,weak) UILabel *fiveonetwoLabel;
@property (nonatomic,weak) UILabel *threethreeLabel;
@property (nonatomic,weak) UILabel *fourfourLabel;


//是第几个
@property (nonatomic,assign) int fourT;

@property (nonatomic,weak) UIImageView *onetopImage;
@property (nonatomic,weak) UITextField *onetopText;
@property (nonatomic,weak) UILabel *threeonetopLabel;
@property (nonatomic,weak) UILabel *fouronetopLabel;
@property (nonatomic,weak) UITextField *twotopText;

@end

@implementation SDAddSomeController

- (NSMutableArray *)friendList
{
    if (_friendList==nil) {
        _friendList = [NSMutableArray array];
    }
    return _friendList;
}

- (NSMutableDictionary *)homeDic
{
    if (_homeDic == nil) {
        _homeDic = [NSMutableDictionary dictionary];
    }
    return _homeDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.title = @"添加聊天对象";
    //顶部
    [self setTopSome];
    //滚动栏
    [self setTopScroll];
}

//顶部
- (void)setTopSome
{
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenW, 44)];
    top.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:top];
    
    NSArray *topTwoArray = @[@"添加朋友",@"添加陌生人",@"添加群聊"];
    CGFloat topTwoW = screenW/3;
    for (int i= 0; i < 3; i++) {
        UIButton *topTwo = [[UIButton alloc] initWithFrame:CGRectMake(i*topTwoW , 0, topTwoW, 44)];
        [topTwo setTitle:topTwoArray[i] forState:UIControlStateNormal];
        [topTwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [topTwo setTitleColor:[UIColor colorWithHexString:@"#fe7181"] forState:UIControlStateSelected];
        [topTwo setBackgroundImage:[UIImage imageNamed:@"baise"] forState:UIControlStateNormal];
        [topTwo setBackgroundImage:[UIImage imageNamed:@"hongdi"] forState:UIControlStateSelected];
        topTwo.adjustsImageWhenHighlighted = NO;
        topTwo.tag = i;
        [topTwo addTarget:self action:@selector(topTwoClick:) forControlEvents:UIControlEventTouchDown];
        topTwo.titleLabel.font = [UIFont systemFontOfSize:15];
        [top addSubview:topTwo];
        if (i == 0) {
            [self topTwoClick:topTwo];
        }
    }
}

- (void)setTopScroll
{
    UIScrollView *homeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+44, screenW, screenH -64-44)];
    homeScroll.contentSize = CGSizeMake(3*screenW, 0);
    homeScroll.bounces = NO;
    homeScroll.scrollEnabled = NO;
    [self.view addSubview:homeScroll];
    self.homeScroll = homeScroll;
    //添加第一个
    [self homeSrollOne];
    //添加第二个
    [self homeSrollTwo];
    //添加第三个
    [self homeSrollThree];
}

- (void)topTwoClick:(UIButton *)sender
{
    if (!sender.isSelected) {
        sender.selected = YES;
        self.selectBtn.selected = NO;
        self.selectBtn = sender;
    }
    if (sender.tag == 0) {
        self.homeScroll.contentOffset = CGPointMake(0, 0);
    }else if(sender.tag == 1){
        self.homeScroll.contentOffset = CGPointMake(screenW, 0);
    }else{
        self.homeScroll.contentOffset = CGPointMake(2*screenW, 0);
    }
}

- (void)homeSrollOne
{
    UIScrollView *oneScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH -64-44)];
    oneScroll.backgroundColor = [UIColor colorWithHexString:@"#efeff5"];
    [self.homeScroll addSubview:oneScroll];
    
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, screenW, 88)];
    oneView.backgroundColor = [UIColor whiteColor];
    [oneScroll addSubview:oneView];
    
    UIView *oneoneDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 0.5)];
    oneoneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [oneView addSubview:oneoneDiv];
    
    UIView *onetwoDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 87.5, screenW, 0.5)];
    onetwoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [oneView addSubview:onetwoDiv];
    
    UIButton *oneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenW, 44)];
    [oneBtn addTarget:self action:@selector(oneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:oneBtn];
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    oneLabel.text = @"朋友头像";
    oneLabel.font = [UIFont systemFontOfSize:15];
    oneLabel.textColor = [UIColor blackColor];
    [oneBtn addSubview:oneLabel];
    
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(screenW -20, 16, 7, 12)];
    right.image = [UIImage imageNamed:@"jiantou"];
    [oneBtn addSubview:right];
    
    UIImageView *oneImage = [[UIImageView alloc] initWithFrame:CGRectMake(screenW - 20 -7 - 15 - 32, 6, 32, 32)];
    [oneBtn addSubview:oneImage];
    self.oneImage = oneImage;
    
    UIView *oneDiv = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, screenW -15, 0.5)];
    oneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [oneView addSubview:oneDiv];
    
    UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 44, screenW *0.5, 44)];
    twoLabel.text = @"朋友昵称";
    twoLabel.font = [UIFont systemFontOfSize:15];
    twoLabel.textColor = [UIColor blackColor];
    [oneView addSubview:twoLabel];
    
    UITextField *oneText = [[UITextField alloc] initWithFrame:CGRectMake(0, 44, screenW - 20, 44)];
    oneText.placeholder = @"请输入";
    oneText.delegate = self;
    oneText.returnKeyType = UIReturnKeyDone;
    oneText.font = [UIFont systemFontOfSize:15];
    oneText.textColor = [UIColor colorWithHexString:@"#999999"];
    [oneText setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    oneText.textAlignment = NSTextAlignmentRight;
    [oneView addSubview:oneText];
    self.oneText = oneText;
    
    CGFloat twoViewY = CGRectGetMaxY(oneView.frame) + 25;
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(0, twoViewY, screenW, 132)];
    twoView.backgroundColor = [UIColor whiteColor];
    [oneScroll addSubview:twoView];
    
    UIButton *twoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenW, 44)];
    [twoBtn addTarget:self action:@selector(twoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:twoBtn];
    
    UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    threeLabel.text = @"消息内容";
    threeLabel.font = [UIFont systemFontOfSize:15];
    threeLabel.textColor = [UIColor blackColor];
    [twoBtn addSubview:threeLabel];
    
    UIView *twooneDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 0.5)];
    twooneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [twoView addSubview:twooneDiv];
    
    UILabel *threeoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenW *0.4, 0, screenW *0.6 -7-20, 44)];
    threeoneLabel.font = [UIFont systemFontOfSize:15];
    threeoneLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    threeoneLabel.textAlignment = NSTextAlignmentRight;
    [twoBtn addSubview:threeoneLabel];
    self.threeoneLabel = threeoneLabel;
    
    UIImageView *threeright = [[UIImageView alloc] initWithFrame:CGRectMake(screenW -20, 16, 7, 12)];
    threeright.image = [UIImage imageNamed:@"jiantou"];
    [twoBtn addSubview:threeright];
    
    UIView *twotwoDiv = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, screenW, 0.5)];
    twotwoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [twoView addSubview:twotwoDiv];
    
    UIButton *threeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 44, screenW, 44)];
    [threeBtn addTarget:self action:@selector(threeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:threeBtn];
    
    UILabel *fourLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    fourLabel.text = @"消息发送时间";
    fourLabel.font = [UIFont systemFontOfSize:15];
    fourLabel.textColor = [UIColor blackColor];
    [threeBtn addSubview:fourLabel];
    
    UIImageView *fourright = [[UIImageView alloc] initWithFrame:CGRectMake(screenW -20, 16, 7, 12)];
    fourright.image = [UIImage imageNamed:@"jiantou"];
    [threeBtn addSubview:fourright];
    
    UILabel *fouroneLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenW *0.4, 0, screenW *0.6 -7-20, 44)];
    fouroneLabel.font = [UIFont systemFontOfSize:15];
    fouroneLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    fouroneLabel.textAlignment = NSTextAlignmentRight;
    [threeBtn addSubview:fouroneLabel];
    self.fouroneLabel = fouroneLabel;
    
    UIView *fourtwoDiv = [[UIView alloc] initWithFrame:CGRectMake(15, 87.5, screenW, 0.5)];
    fourtwoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [twoView addSubview:fourtwoDiv];
    
    UILabel *fiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 88, screenW *0.5, 44)];
    fiveLabel.text = @"未读消息数量";
    fiveLabel.font = [UIFont systemFontOfSize:15];
    fiveLabel.textColor = [UIColor blackColor];
    [twoView addSubview:fiveLabel];
    
    UITextField *twoText = [[UITextField alloc] initWithFrame:CGRectMake(0, 88, screenW - 20, 44)];
    twoText.text = @"0";
    twoText.font = [UIFont systemFontOfSize:15];
    twoText.delegate = self;
    twoText.textColor = [UIColor colorWithHexString:@"#999999"];
    [twoText setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    twoText.textAlignment = NSTextAlignmentRight;
    twoText.returnKeyType = UIReturnKeyDone;
    [twoView addSubview:twoText];
    self.twoText = twoText;
    
    UIView *fivetwoDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 131.5, screenW, 0.5)];
    fivetwoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [twoView addSubview:fivetwoDiv];
    
    CGFloat threeViewY = CGRectGetMaxY(twoView.frame) + 25;
    UIView *threeView = [[UIView alloc] initWithFrame:CGRectMake(0, threeViewY, screenW, 44)];
    threeView.backgroundColor = [UIColor whiteColor];
    [oneScroll addSubview:threeView];
    
    UILabel *sixLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    sixLabel.text = @"置顶聊天";
    sixLabel.font = [UIFont systemFontOfSize:15];
    sixLabel.textColor = [UIColor blackColor];
    [threeView addSubview:sixLabel];
    
    UIButton *sixBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenW-15 -44, 5.5, 44, 29)];
    [sixBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    [sixBtn setBackgroundImage:[UIImage imageNamed:@"on-拷贝"] forState:UIControlStateSelected];
    [sixBtn addTarget:self action:@selector(sixBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sixBtn.selected = NO;
    self.topNum = 0;
    [threeView addSubview:sixBtn];
    
    //完成
    CGFloat overBtnY = CGRectGetMaxY(threeView.frame) + 25;
    UIButton *overBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, overBtnY, screenW -30, 44)];
    [overBtn setTitle:@"完成" forState:UIControlStateNormal];
    overBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5959"];
    [overBtn addTarget:self action:@selector(overBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [overBtn.layer setMasksToBounds:YES];
    [overBtn.layer setCornerRadius:5];
    [oneScroll addSubview:overBtn];
    
    oneScroll.contentSize = CGSizeMake(0, CGRectGetMaxY(overBtn.frame) + 20);
}

//完成
- (void)overBtnClick
{
    if (self.homeDic[@"picture"]&&self.oneText.text.length&&self.fouroneLabel.text.length&&self.threeoneLabel.text.length) {
        self.homeDic[@"nickName"] = self.oneText.text;
        NSMutableArray *contentList = [NSMutableArray array];
        [contentList addObject:self.threeoneLabel.text];
        self.homeDic[@"content"] = contentList;
        self.homeDic[@"time"] = self.fouroneLabel.text;
        self.homeDic[@"message"] = self.twoText.text;
        NSArray *userList = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginDict"];
        NSMutableArray *userinfo = [NSMutableArray array];
        if (userList.count >0) {
            [userinfo addObjectsFromArray:userList];
            if (self.topNum == 0) {
                [userinfo addObject:self.homeDic];
            }else{
                [userinfo insertObject:self.homeDic atIndex:0];
            }
        }else{
            [userinfo addObject:self.homeDic];
        }
        [[NSUserDefaults standardUserDefaults] setObject:userinfo forKey:@"LoginDict"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
         [WKProgressHUD popMessage:@"至少选择朋友头像,朋友昵称,消息发送时间,聊天内容" inView:self.view duration:1.5 animated:YES];
    }
}

//置顶聊天
- (void)sixBtnClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.topNum = 1;
    }else{
        self.topNum = 0;
    }
}

- (void)homeSrollTwo
{
    UIScrollView *twoScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(screenW, 0, screenW, screenH -64-44)];
    twoScroll.backgroundColor = [UIColor colorWithHexString:@"#efeff5"];
    [self.homeScroll addSubview:twoScroll];
    
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, screenW, 88)];
    oneView.backgroundColor = [UIColor whiteColor];
    [twoScroll addSubview:oneView];
    
    UIView *oneoneDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 0.5)];
    oneoneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [oneView addSubview:oneoneDiv];
    
    UIView *onetwoDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 87.5, screenW, 0.5)];
    onetwoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [oneView addSubview:onetwoDiv];
    
    UIButton *oneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenW, 44)];
    [oneBtn addTarget:self action:@selector(onetwoScrollClick) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:oneBtn];
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    oneLabel.text = @"陌生人头像";
    oneLabel.font = [UIFont systemFontOfSize:15];
    oneLabel.textColor = [UIColor blackColor];
    [oneBtn addSubview:oneLabel];
    
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(screenW -20, 16, 7, 12)];
    right.image = [UIImage imageNamed:@"jiantou"];
    [oneBtn addSubview:right];
    
    UIImageView *onetwoImage = [[UIImageView alloc] initWithFrame:CGRectMake(screenW - 20 -7 - 15 - 32, 6, 32, 32)];
    [oneBtn addSubview:onetwoImage];
    self.onetwoImage = onetwoImage;
    
    UIView *oneDiv = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, screenW -15, 0.5)];
    oneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [oneView addSubview:oneDiv];
    
    UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 44, screenW *0.5, 44)];
    twoLabel.text = @"陌生人昵称";
    twoLabel.font = [UIFont systemFontOfSize:15];
    twoLabel.textColor = [UIColor blackColor];
    [oneView addSubview:twoLabel];
    
    UITextField *onetwoText = [[UITextField alloc] initWithFrame:CGRectMake(0, 44, screenW - 20, 44)];
    onetwoText.placeholder = @"请输入";
    onetwoText.delegate = self;
    onetwoText.returnKeyType = UIReturnKeyDone;
    onetwoText.font = [UIFont systemFontOfSize:15];
    onetwoText.textColor = [UIColor colorWithHexString:@"#999999"];
    [onetwoText setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    onetwoText.textAlignment = NSTextAlignmentRight;
    [oneView addSubview:onetwoText];
    self.onetwoText = onetwoText;
    
    CGFloat twoViewY = CGRectGetMaxY(oneView.frame) + 25;
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(0, twoViewY, screenW, 132)];
    twoView.backgroundColor = [UIColor whiteColor];
    [twoScroll addSubview:twoView];
    
    UIButton *twoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenW, 44)];
    [twoBtn addTarget:self action:@selector(twoBtnscrollClick) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:twoBtn];
    
    UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    threeLabel.text = @"打招呼消息1";
    threeLabel.font = [UIFont systemFontOfSize:15];
    threeLabel.textColor = [UIColor blackColor];
    [twoBtn addSubview:threeLabel];
    
    UIView *twooneDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 0.5)];
    twooneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [twoView addSubview:twooneDiv];
    
    UILabel *threeonetwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenW *0.4, 0, screenW *0.6 -7-20, 44)];
    threeonetwoLabel.font = [UIFont systemFontOfSize:15];
    threeonetwoLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    threeonetwoLabel.textAlignment = NSTextAlignmentRight;
    [twoBtn addSubview:threeonetwoLabel];
    self.threeonetwoLabel = threeonetwoLabel;
    
    UIImageView *threeright = [[UIImageView alloc] initWithFrame:CGRectMake(screenW -20, 16, 7, 12)];
    threeright.image = [UIImage imageNamed:@"jiantou"];
    [twoBtn addSubview:threeright];
    
    UIView *twotwoDiv = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, screenW, 0.5)];
    twotwoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [twoView addSubview:twotwoDiv];
    
    UIButton *threeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 44, screenW, 44)];
    [threeBtn addTarget:self action:@selector(threescrollBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:threeBtn];
    
    UILabel *fourLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    fourLabel.text = @"打招呼消息2";
    fourLabel.font = [UIFont systemFontOfSize:15];
    fourLabel.textColor = [UIColor blackColor];
    [threeBtn addSubview:fourLabel];
    
    UIImageView *fourright = [[UIImageView alloc] initWithFrame:CGRectMake(screenW -20, 16, 7, 12)];
    fourright.image = [UIImage imageNamed:@"jiantou"];
    [threeBtn addSubview:fourright];
    
    UILabel *fouronetwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenW *0.4, 0, screenW *0.6 -7-20, 44)];
    fouronetwoLabel.font = [UIFont systemFontOfSize:15];
    fouronetwoLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    fouronetwoLabel.textAlignment = NSTextAlignmentRight;
    [threeBtn addSubview:fouronetwoLabel];
    self.fouronetwoLabel = fouronetwoLabel;
    
    UIView *fourtwoDiv = [[UIView alloc] initWithFrame:CGRectMake(15, 87.5, screenW, 0.5)];
    fourtwoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [twoView addSubview:fourtwoDiv];
    
    UIButton *fourBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 88, screenW, 44)];
    [fourBtn addTarget:self action:@selector(fourscrollBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:fourBtn];
    
    UILabel *fourtwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    fourtwoLabel.text = @"打招呼消息3";
    fourtwoLabel.font = [UIFont systemFontOfSize:15];
    fourtwoLabel.textColor = [UIColor blackColor];
    [fourBtn addSubview:fourtwoLabel];
    
    UIImageView *fouroneright = [[UIImageView alloc] initWithFrame:CGRectMake(screenW -20, 16, 7, 12)];
    fouroneright.image = [UIImage imageNamed:@"jiantou"];
    [fourBtn addSubview:fouroneright];
    
    UILabel *fiveonetwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenW *0.4, 0, screenW *0.6 -7-20, 44)];
    fiveonetwoLabel.font = [UIFont systemFontOfSize:15];
    fiveonetwoLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    fiveonetwoLabel.textAlignment = NSTextAlignmentRight;
    [fourBtn addSubview:fiveonetwoLabel];
    self.fiveonetwoLabel = fiveonetwoLabel;
    
    UIView *fivetwoDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 131.5, screenW, 0.5)];
    fivetwoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [twoView addSubview:fivetwoDiv];

    
    CGFloat threeViewY = CGRectGetMaxY(twoView.frame) + 25;
    UIView *threeView = [[UIView alloc] initWithFrame:CGRectMake(0, threeViewY, screenW, 132)];
    threeView.backgroundColor = [UIColor whiteColor];
    [twoScroll addSubview:threeView];
    
    UIButton *threeoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenW, 44)];
    [threeoneBtn addTarget:self action:@selector(twoscrollallBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [threeView addSubview:threeoneBtn];
    
    UILabel *threeoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    threeoneLabel.text = @"打招呼时间";
    threeoneLabel.font = [UIFont systemFontOfSize:15];
    threeoneLabel.textColor = [UIColor blackColor];
    [threeoneBtn addSubview:threeoneLabel];
    
    UIView *twofiveDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 0.5)];
    twofiveDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [threeView addSubview:twofiveDiv];
    
    UILabel *threethreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenW *0.4, 0, screenW *0.6 -7-20, 44)];
    threethreeLabel.font = [UIFont systemFontOfSize:15];
    threethreeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    threethreeLabel.textAlignment = NSTextAlignmentRight;
    [threeoneBtn addSubview:threethreeLabel];
    self.threethreeLabel = threethreeLabel;
    
    UIImageView *threethreeright = [[UIImageView alloc] initWithFrame:CGRectMake(screenW -20, 16, 7, 12)];
    threethreeright.image = [UIImage imageNamed:@"jiantou"];
    [threeoneBtn addSubview:threethreeright];
    
    UIView *twosixDiv = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, screenW, 0.5)];
    twosixDiv .backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [threeView addSubview:twosixDiv];
    
    UIButton *threesixBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 44, screenW, 44)];
    [threesixBtn addTarget:self action:@selector(threescrollallBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [threeView addSubview:threesixBtn];
    
    UILabel *foursixLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    foursixLabel.text = @"通过好友时间";
    foursixLabel.font = [UIFont systemFontOfSize:15];
    foursixLabel.textColor = [UIColor blackColor];
    [threesixBtn addSubview:foursixLabel];
    
    UIImageView *foursixright = [[UIImageView alloc] initWithFrame:CGRectMake(screenW -20, 16, 7, 12)];
    foursixright.image = [UIImage imageNamed:@"jiantou"];
    [threesixBtn addSubview:foursixright];
    
    UILabel *fourfourLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenW *0.4, 0, screenW *0.6 -7-20, 44)];
    fourfourLabel.font = [UIFont systemFontOfSize:15];
    fourfourLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    fourfourLabel.textAlignment = NSTextAlignmentRight;
    [threesixBtn addSubview:fourfourLabel];
    self.fourfourLabel = fourfourLabel;
    
    UIView *foursevenDiv = [[UIView alloc] initWithFrame:CGRectMake(15, 87.5, screenW, 0.5)];
    foursevenDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [threeView addSubview:foursevenDiv];
    
    UILabel *sixLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 88, screenW *0.5, 44)];
    sixLabel.text = @"置顶聊天";
    sixLabel.font = [UIFont systemFontOfSize:15];
    sixLabel.textColor = [UIColor blackColor];
    [threeView addSubview:sixLabel];
    
    UIButton *sixBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenW-15 -44,88+ 5.5, 44, 29)];
    [sixBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    [sixBtn setBackgroundImage:[UIImage imageNamed:@"on-拷贝"] forState:UIControlStateSelected];
    [sixBtn addTarget:self action:@selector(sixBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sixBtn.selected = NO;
    self.topNum = 0;
    [threeView addSubview:sixBtn];
    
    UIView *fiveheightDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 131.5, screenW, 0.5)];
    fiveheightDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [threeView addSubview:fiveheightDiv];
    
    //完成
    CGFloat overBtnY = CGRectGetMaxY(threeView.frame) + 25;
    UIButton *overBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, overBtnY, screenW -30, 44)];
    [overBtn setTitle:@"完成" forState:UIControlStateNormal];
    overBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5959"];
    [overBtn addTarget:self action:@selector(overBtnscrollClick) forControlEvents:UIControlEventTouchUpInside];
    [overBtn.layer setMasksToBounds:YES];
    [overBtn.layer setCornerRadius:5];
    [twoScroll addSubview:overBtn];
    twoScroll.contentSize = CGSizeMake(0, CGRectGetMaxY(overBtn.frame) + 20);
}

- (void)overBtnscrollClick
{
    if (self.threeonetwoLabel.text.length||self.fouronetwoLabel.text.length||self.fiveonetwoLabel.text.length) {
        if (self.homeDic[@"picture"]&&self.onetwoText.text.length&&self.threethreeLabel.text.length&&self.fourfourLabel.text.length) {
            self.homeDic[@"nickName"] = self.onetwoText.text;
            NSMutableArray *contentList = [NSMutableArray array];
            if (self.threeonetwoLabel.text.length) {
                [contentList addObject:self.threeonetwoLabel.text];
            }
            if (self.fouronetwoLabel.text.length) {
                [contentList addObject:self.fouronetwoLabel.text];
            }
            if (self.fiveonetwoLabel.text.length) {
                [contentList addObject:self.fiveonetwoLabel.text];
            }
            [contentList addObject:[NSString stringWithFormat:@"你已添加了%@,现在可以开始聊天了。",self.onetwoText.text]];
            self.homeDic[@"content"] = contentList;
            self.homeDic[@"time"] = self.threethreeLabel.text;
            self.homeDic[@"alltime"] = self.fourfourLabel.text;
            NSArray *userList = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginDict"];
            NSMutableArray *userinfo = [NSMutableArray array];
            if (userList.count >0) {
                [userinfo addObjectsFromArray:userList];
                if (self.topNum == 0) {
                    [userinfo addObject:self.homeDic];
                }else{
                    [userinfo insertObject:self.homeDic atIndex:0];
                }
            }else{
                [userinfo addObject:self.homeDic];
            }
            [[NSUserDefaults standardUserDefaults] setObject:userinfo forKey:@"LoginDict"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [WKProgressHUD popMessage:@"至少选择陌生人头像,陌生人昵称,打招呼时间,通过好友时间" inView:self.view duration:1.5 animated:YES];
        }
    }else{
        [WKProgressHUD popMessage:@"至少1个打招呼消息" inView:self.view duration:1.5 animated:YES];
    }
}

- (void)twoscrollallBtnClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入时间" message:@"举例:昨天,3-10,上午10:00,下午3:00" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *textfields = alertController.textFields;
        UITextField *namefield = textfields[0];
        self.threethreeLabel.text = namefield.text;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)threescrollallBtnClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入时间" message:@"举例:昨天,3-10,上午10:00,下午3:00" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *textfields = alertController.textFields;
        UITextField *namefield = textfields[0];
        self.fourfourLabel.text = namefield.text;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

//陌生人头像
- (void)onetwoScrollClick
{
    self.fourT = 2;
    //推出我的个人信息拍照
    ALDActionSheet *sheet = [[ALDActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"拍照", @"从相册选择", nil];
    //显示出来
    [sheet show];
}

- (void)twoBtnscrollClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入消息内容" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *textfields = alertController.textFields;
        UITextField *namefield = textfields[0];
        self.threeonetwoLabel.text = namefield.text;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)threescrollBtnClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入消息内容" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *textfields = alertController.textFields;
        UITextField *namefield = textfields[0];
        self.fouronetwoLabel.text = namefield.text;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)fourscrollBtnClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入消息内容" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *textfields = alertController.textFields;
        UITextField *namefield = textfields[0];
        self.fiveonetwoLabel.text = namefield.text;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)homeSrollThree
{
    UIScrollView *threeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(2*screenW, 0, screenW, screenH -64-44)];
    threeScroll.backgroundColor = [UIColor colorWithHexString:@"#efeff5"];
    [self.homeScroll addSubview:threeScroll];
    
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, screenW, 88)];
    oneView.backgroundColor = [UIColor whiteColor];
    [threeScroll addSubview:oneView];
    
    UIView *oneoneDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 0.5)];
    oneoneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [oneView addSubview:oneoneDiv];
    
    UIView *onetwoDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 87.5, screenW, 0.5)];
    onetwoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [oneView addSubview:onetwoDiv];
    
    UIButton *oneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenW, 44)];
    [oneBtn addTarget:self action:@selector(oneBtntopClick) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:oneBtn];
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    oneLabel.text = @"群聊头像";
    oneLabel.font = [UIFont systemFontOfSize:15];
    oneLabel.textColor = [UIColor blackColor];
    [oneBtn addSubview:oneLabel];
    
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(screenW -20, 16, 7, 12)];
    right.image = [UIImage imageNamed:@"jiantou"];
    [oneBtn addSubview:right];
    
    UIImageView *onetopImage = [[UIImageView alloc] initWithFrame:CGRectMake(screenW - 20 -7 - 15 - 32, 6, 32, 32)];
    [oneBtn addSubview:onetopImage];
    self.onetopImage = onetopImage;
    
    UIView *oneDiv = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, screenW -15, 0.5)];
    oneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [oneView addSubview:oneDiv];
    
    UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 44, screenW *0.5, 44)];
    twoLabel.text = @"群聊昵称";
    twoLabel.font = [UIFont systemFontOfSize:15];
    twoLabel.textColor = [UIColor blackColor];
    [oneView addSubview:twoLabel];
    
    UITextField *onetopText = [[UITextField alloc] initWithFrame:CGRectMake(0, 44, screenW - 20, 44)];
    onetopText.placeholder = @"请输入";
    onetopText.delegate = self;
    onetopText.returnKeyType = UIReturnKeyDone;
    onetopText.font = [UIFont systemFontOfSize:15];
    onetopText.textColor = [UIColor colorWithHexString:@"#999999"];
    [onetopText setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    onetopText.textAlignment = NSTextAlignmentRight;
    [oneView addSubview:onetopText];
    self.onetopText = onetopText;
    
    CGFloat twoViewY = CGRectGetMaxY(oneView.frame) + 25;
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(0, twoViewY, screenW, 132)];
    twoView.backgroundColor = [UIColor whiteColor];
    [threeScroll addSubview:twoView];
    
    UIButton *twoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenW, 44)];
    [twoBtn addTarget:self action:@selector(twoBtntopClick) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:twoBtn];
    
    UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    threeLabel.text = @"消息内容";
    threeLabel.font = [UIFont systemFontOfSize:15];
    threeLabel.textColor = [UIColor blackColor];
    [twoBtn addSubview:threeLabel];
    
    UIView *twooneDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 0.5)];
    twooneDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [twoView addSubview:twooneDiv];
    
    UILabel *threeonetopLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenW *0.4, 0, screenW *0.6 -7-20, 44)];
    threeonetopLabel.font = [UIFont systemFontOfSize:15];
    threeonetopLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    threeonetopLabel.textAlignment = NSTextAlignmentRight;
    [twoBtn addSubview:threeonetopLabel];
    self.threeonetopLabel = threeonetopLabel;
    
    UIImageView *threeright = [[UIImageView alloc] initWithFrame:CGRectMake(screenW -20, 16, 7, 12)];
    threeright.image = [UIImage imageNamed:@"jiantou"];
    [twoBtn addSubview:threeright];
    
    UIView *twotwoDiv = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, screenW, 0.5)];
    twotwoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [twoView addSubview:twotwoDiv];
    
    UIButton *threeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 44, screenW, 44)];
    [threeBtn addTarget:self action:@selector(threeBtntopClick) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:threeBtn];
    
    UILabel *fourLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    fourLabel.text = @"消息发送时间";
    fourLabel.font = [UIFont systemFontOfSize:15];
    fourLabel.textColor = [UIColor blackColor];
    [threeBtn addSubview:fourLabel];
    
    UIImageView *fourright = [[UIImageView alloc] initWithFrame:CGRectMake(screenW -20, 16, 7, 12)];
    fourright.image = [UIImage imageNamed:@"jiantou"];
    [threeBtn addSubview:fourright];
    
    UILabel *fouronetopLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenW *0.4, 0, screenW *0.6 -7-20, 44)];
    fouronetopLabel.font = [UIFont systemFontOfSize:15];
    fouronetopLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    fouronetopLabel.textAlignment = NSTextAlignmentRight;
    [threeBtn addSubview:fouronetopLabel];
    self.fouronetopLabel =fouronetopLabel;
    
    UIView *fourtwoDiv = [[UIView alloc] initWithFrame:CGRectMake(15, 87.5, screenW, 0.5)];
    fourtwoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [twoView addSubview:fourtwoDiv];
    
    UILabel *fiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 88, screenW *0.5, 44)];
    fiveLabel.text = @"未读消息数量";
    fiveLabel.font = [UIFont systemFontOfSize:15];
    fiveLabel.textColor = [UIColor blackColor];
    [twoView addSubview:fiveLabel];
    
    UITextField *twotopText = [[UITextField alloc] initWithFrame:CGRectMake(0, 88, screenW - 20, 44)];
    twotopText.text = @"0";
    twotopText.font = [UIFont systemFontOfSize:15];
    twotopText.delegate = self;
    twotopText.textColor = [UIColor colorWithHexString:@"#999999"];
    [twotopText setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    twotopText.textAlignment = NSTextAlignmentRight;
    twotopText.returnKeyType = UIReturnKeyDone;
    [twoView addSubview:twotopText];
    self.twotopText = twotopText;
    
    UIView *fivetwoDiv = [[UIView alloc] initWithFrame:CGRectMake(0, 131.5, screenW, 0.5)];
    fivetwoDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [twoView addSubview:fivetwoDiv];
    
    CGFloat threeViewY = CGRectGetMaxY(twoView.frame) + 25;
    UIView *threeView = [[UIView alloc] initWithFrame:CGRectMake(0, threeViewY, screenW, 88)];
    threeView.backgroundColor = [UIColor whiteColor];
    [threeScroll addSubview:threeView];
    
    UILabel *sixLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenW *0.5, 44)];
    sixLabel.text = @"置顶聊天";
    sixLabel.font = [UIFont systemFontOfSize:15];
    sixLabel.textColor = [UIColor blackColor];
    [threeView addSubview:sixLabel];
    
    UIButton *sixBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenW-15 -44, 5.5, 44, 29)];
    [sixBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    [sixBtn setBackgroundImage:[UIImage imageNamed:@"on-拷贝"] forState:UIControlStateSelected];
    [sixBtn addTarget:self action:@selector(sixBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sixBtn.selected = NO;
    self.topNum = 0;
    [threeView addSubview:sixBtn];
    
    UIView *fiveappDiv = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, screenW -15, 0.5)];
    fiveappDiv.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [threeView addSubview:fiveappDiv];
    
    UILabel *sevenLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,44, screenW *0.5, 44)];
    sevenLabel.text = @"消息免打扰";
    sevenLabel.font = [UIFont systemFontOfSize:15];
    sevenLabel.textColor = [UIColor blackColor];
    [threeView addSubview:sevenLabel];
    
    UIButton *sevenBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenW-15 -44, 44+5.5, 44, 29)];
    [sevenBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    [sevenBtn setBackgroundImage:[UIImage imageNamed:@"on-拷贝"] forState:UIControlStateSelected];
    [sevenBtn addTarget:self action:@selector(sixBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sevenBtn.selected = NO;
   // self.topNum = 0;
    [threeView addSubview:sevenBtn];
    
    //完成
    CGFloat overBtnY = CGRectGetMaxY(threeView.frame) + 25;
    UIButton *overBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, overBtnY, screenW -30, 44)];
    [overBtn setTitle:@"完成" forState:UIControlStateNormal];
    overBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5959"];
    [overBtn addTarget:self action:@selector(overBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [overBtn.layer setMasksToBounds:YES];
    [overBtn.layer setCornerRadius:5];
    [threeScroll addSubview:overBtn];
    threeScroll.contentSize = CGSizeMake(0, CGRectGetMaxY(overBtn.frame) +20);
}

- (void)twoBtntopClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入消息内容" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *textfields = alertController.textFields;
        UITextField *namefield = textfields[0];
        self.threeonetopLabel.text = namefield.text;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)threeBtntopClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入时间" message:@"举例:昨天,3-10,上午10:00,下午3:00" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *textfields = alertController.textFields;
        UITextField *namefield = textfields[0];
        self.fouronetopLabel.text = namefield.text;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

//群聊头像
- (void)oneBtntopClick
{
    self.fourT = 3;
    //推出我的个人信息拍照
    ALDActionSheet *sheet = [[ALDActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"拍照", @"从相册选择", nil];
    //显示出来
    [sheet show];
}

//朋友头像
- (void)oneBtnClick
{
    self.fourT = 1;
    //推出我的个人信息拍照
    ALDActionSheet *sheet = [[ALDActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"拍照", @"从相册选择", nil];
    //显示出来
    [sheet show];
    
}

-(void)actionSheet:(ALDActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            //拍照
            [self takePhoto];
            break;
        case 2:
            //从相册选择
            [self localPhoto];
            break;
        default:
            break;
    }
}

-(void)localPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate    = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
    }];
}

-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //资源类型为照相机
        picker.sourceType = sourceType;
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else {
        
    }
}

//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    if (self.fourT == 1) {
        self.oneImage.image = image;
    }else if (self.fourT ==2){
        self.onetwoImage.image = image;
    }else if (self.fourT == 3){
        self.onetopImage.image = image;
    }
    self.homeDic[@"picture"] = UIImagePNGRepresentation(image);
    //关闭相册界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.oneText resignFirstResponder];
    [self.twoText resignFirstResponder];
    [self.onetwoText resignFirstResponder];
    [self.onetopText resignFirstResponder];
    [self.twotopText resignFirstResponder];
    return YES;
}

- (void)twoBtnClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入消息内容" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *textfields = alertController.textFields;
        UITextField *namefield = textfields[0];
        self.threeoneLabel.text = namefield.text;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)threeBtnClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入时间" message:@"举例:昨天,3-10,上午10:00,下午3:00" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *textfields = alertController.textFields;
        UITextField *namefield = textfields[0];
        self.fouroneLabel.text = namefield.text;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
