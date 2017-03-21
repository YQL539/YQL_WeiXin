//
//  TLChatViewController.m
//  iOSAppTemplate
//
//  Created by 李伯坤 on 15/9/24.
//  Copyright (c) 2015年 lbk. All rights reserved.
//

#import "TLChatViewController.h"
#import "TLChatMessageViewContrller.h"
#import "TLChatBoxViewController.h"
#import "TLUserHelper.h"
#import "MobClick.h"

@interface TLChatViewController () <TLChatMessageViewControllerDelegate, TLChatBoxViewControllerDelegate>
{
    CGFloat viewHeight;
}

@property (nonatomic, strong) TLChatMessageViewContrller *chatMessageVC;
@property (nonatomic, strong) TLChatBoxViewController *chatBoxVC;
@property (nonatomic,assign) TLMessageOwnerType OwnerType;
@property (nonatomic,strong) SDHomeTableViewCellModel  *MeRole;
@property (nonatomic,strong) SDHomeTableViewCellModel  *FriendRole;
@property (nonatomic,strong) SDHomeTableViewCellModel  *SenderRole;
@end

@implementation TLChatViewController

#pragma mark - LifeCycle
- (void) viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [self setHidesBottomBarWhenPushed:YES];
    _OwnerType = TLMessageOwnerTypeSelf;
    _SenderRole = [[SDHomeTableViewCellModel  alloc] init];
    _MeRole =[[SDHomeTableViewCellModel  alloc] init];
    
    if ([CommonUtil IsExistFile:WECHAT_USER]) {
        NSDictionary *pMeDic = [[NSDictionary alloc] initWithContentsOfFile:WECHAT_USER];
        _MeRole.picture = pMeDic[@"picture"];
    }
    
    NSString *FName = _model.nickName;
    _FriendRole = [[SDHomeTableViewCellModel  alloc] init];
    _FriendRole.nickName = FName;
    if ([CommonUtil IsExistFile:WECHAT_FRIEND(FName)]) {
        NSDictionary *pDic = [[NSDictionary alloc] initWithContentsOfFile:WECHAT_FRIEND(FName)];
        _FriendRole.picture = pDic[@"picture"];
    }
    _SenderRole = _MeRole;
    viewHeight = HEIGHT_SCREEN - HEIGHT_NAVBAR - HEIGHT_STATUSBAR;
    
    [self.view addSubview:self.chatMessageVC.view];
    [self addChildViewController:self.chatMessageVC];
    [self.view addSubview:self.chatBoxVC.view];
    [self addChildViewController:self.chatBoxVC];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [MobClick beginLogPageView:self.navigationItem.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.navigationItem.title];
}

#pragma mark - TLChatMessageViewControllerDelegate
- (void) didTapChatMessageView:(TLChatMessageViewContrller *)chatMessageViewController
{
    [self.chatBoxVC resignFirstResponder];
}

#pragma mark - TLChatBoxViewControllerDelegate
- (void) chatBoxViewController:(TLChatBoxViewController *)chatboxViewController sendMessage:(TLMessage *)message
{
    message.from = _SenderRole;
    message.ownerTyper = _OwnerType;
    NSLog(@"_owertype=%ld",_OwnerType);
    [self.chatMessageVC addNewMessage:message];
    //自动回复的内容
//    TLMessage *recMessage = [[TLMessage alloc] init];
//    recMessage.messageType = message.messageType;
//    recMessage.ownerTyper = TLMessageOwnerTypeOther;
//    recMessage.date = [NSDate date];
//    recMessage.text = message.text;
//    recMessage.picture = message.picture;
//    recMessage.from = message.from;
//    [self.chatMessageVC addNewMessage:recMessage];
    
    [self.chatMessageVC scrollToBottom];
}

-(void)SwitchRole{
    if (_OwnerType == TLMessageOwnerTypeSelf) {
        _OwnerType = TLMessageOwnerTypeOther;
        _SenderRole = _FriendRole;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已切换到好友" message:@"再次点击切换至自己" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else if (_OwnerType == TLMessageOwnerTypeOther){
        _OwnerType = TLMessageOwnerTypeSelf;
        _SenderRole = _MeRole;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已切换到自己" message:@"再次点击切换至好友" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (void) chatBoxViewController:(TLChatBoxViewController *)chatboxViewController didChangeChatBoxHeight:(CGFloat)height
{
    self.chatMessageVC.view.frameHeight = viewHeight - height;
    self.chatBoxVC.view.originY = self.chatMessageVC.view.originY + self.chatMessageVC.view.frameHeight;
    [self.chatMessageVC scrollToBottom];
}

#pragma mark - Getter and Setter
- (void)setModel:(SDHomeTableViewCellModel *)model
{
    _model = model;
    [self.navigationItem setTitle:model.nickName];
}

- (TLChatMessageViewContrller *) chatMessageVC
{
    if (_chatMessageVC == nil) {
        _chatMessageVC = [[TLChatMessageViewContrller alloc] init];
        [_chatMessageVC.view setFrame:CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, WIDTH_SCREEN, viewHeight - HEIGHT_TABBAR)];
        [_chatMessageVC setDelegate:self];
    }
    return _chatMessageVC;
}

- (TLChatBoxViewController *) chatBoxVC
{
    if (_chatBoxVC == nil) {
        _chatBoxVC = [[TLChatBoxViewController alloc] init];
        [_chatBoxVC.view setFrame:CGRectMake(0, HEIGHT_SCREEN - HEIGHT_TABBAR, WIDTH_SCREEN, HEIGHT_SCREEN)];
        [_chatBoxVC setDelegate:self];
    }
    return _chatBoxVC;
}

@end
