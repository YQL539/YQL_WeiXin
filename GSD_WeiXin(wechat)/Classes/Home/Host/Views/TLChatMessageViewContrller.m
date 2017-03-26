//
//  TLChatMessageViewContrller.m
//  iOSAppTemplate
//
//  Created by 李伯坤 on 15/9/24.
//  Copyright (c) 2015年 lbk. All rights reserved.
//

#import "TLChatMessageViewContrller.h"

#import "TLTextMessageCell.h"
#import "SDWebViewController.h"
#import "UIView+SDAutoLayout.h"

@interface TLChatMessageViewContrller ()
@property (nonatomic ,assign) BOOL isExist;
@end

@implementation TLChatMessageViewContrller

#pragma mark - LifeCycle
- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:DEFAULT_CHAT_BACKGROUND_COLOR];
//    [self.view addGestureRecognizer:self.tapGR];
//    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self getLocalFile];
}

-(void)getLocalFile{
    NSString *FName = _model.FName;
    _isExist = [CommonUtil IsExistFile:WECHAT_FRIENDCHAT(FName)];
    if (_isExist) {
        NSData *data = [NSData dataWithContentsOfFile:WECHAT_FRIENDCHAT(FName)];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *pArray = [unarchiver decodeObjectForKey:@"model"];
        [unarchiver finishDecoding];
        [self.data addObjectsFromArray:pArray];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isExist == NO) {
        [self firstLoadsendTimeMessage];
        [self firstLoadsendTextMessage];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.data forKey:@"model"];
    [archiver finishEncoding];
    
    [data writeToFile:WECHAT_FRIENDCHAT(_model.FName) atomically:YES];
}
#pragma mark - Public Methods
- (void) addNewMessage:(TLMessage *)message
{
    [self.data addObject:message];
    [self.tableView reloadData];
}

- (void) scrollToBottom
{
    if (_data.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_data.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)firstLoadsendTimeMessage
{
    TLMessage *message = [[TLMessage alloc]init];
    message.messageType = TLMessageTypeTime;
    message.ownerTyper = TLMessageOwnerTypeOther;
    message.dateString = _Fmodel.time;
    [self addNewMessage:message];
    [self scrollToBottom];
}

- (void)firstLoadsendTextMessage
{
    TLMessage *message = [[TLMessage alloc]init];
    message.ownerTyper = TLMessageOwnerTypeOther;
    message.messageType = TLMessageTypeText;
    message.from = _Fmodel;
    message.date = [NSDate date];
    [message setText:_Fmodel.message];
    [self addNewMessage:message];
    [self scrollToBottom];
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TLMessage *message = _data[indexPath.row];
    NSString *indentify = [NSString stringWithFormat:@"Cell===%ld%ld",indexPath.section ,(long)indexPath.row];
    
    TLTextMessageCell *cell = [[TLTextMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
    cell.message = message;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    // 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    cell.sd_tableView = tableView;
    cell.sd_indexPath = indexPath;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TLMessage *clickmessage = _data[indexPath.row];
    switch (clickmessage.messageType) {
        case TLMessageTypeRedPacket:
        {
            [self didSelectedRedPacket:clickmessage];
            break;
        }
        case TLMessageTypeTransfer:
        {
            [self didSelectedTransfer:clickmessage];
            break;
        }
        default:
            break;
    }
}

-(void)didSelectedRedPacket:(TLMessage *)clickmessage{
    
    if (clickmessage.ownerTyper == TLMessageOwnerTypeOther && clickmessage.readState != TLMessageReaded) {
        //我领取别人的红包
        TLMessage *newMessage = [[TLMessage alloc] init];
        newMessage.messageType = TLMessageTypeReceveRedPacket;
        newMessage.ownerTyper = TLMessageOwnerTypeOther;
        newMessage.date = [NSDate date];
        [self addNewMessage:newMessage];
        [self scrollToBottom];
    }else if (clickmessage.ownerTyper == TLMessageOwnerTypeSelf && clickmessage.readState != TLMessageReaded){
        //别人领取我的红包
        TLMessage *newMessage = [[TLMessage alloc] init];
        newMessage.messageType = TLMessageTypeReceveRedPacket;
        newMessage.ownerTyper = TLMessageOwnerTypeSelf;
        newMessage.date = [NSDate date];
        [self addNewMessage:newMessage];
        [self scrollToBottom];
    }
    clickmessage.readState = TLMessageReaded;
}

-(void)didSelectedTransfer:(TLMessage *)clickmessage{
    if (clickmessage.ownerTyper == TLMessageOwnerTypeOther&& clickmessage.readState != TLMessageReaded) {
        //我收别人的钱
        TLMessage *newMessage = [[TLMessage alloc] init];
        newMessage.messageType = TLMessageTypeReceiveTransfer;
        newMessage.ownerTyper = TLMessageOwnerTypeSelf;
        newMessage.date = [NSDate date];
        newMessage.transformNum = clickmessage.transformNum;
        newMessage.transformFpicture = clickmessage.from.Fpicture;
        newMessage.transformFName = clickmessage.from.FName;
        [self addNewMessage:newMessage];
        [self scrollToBottom];
    }else if (clickmessage.ownerTyper == TLMessageOwnerTypeSelf&& clickmessage.readState != TLMessageReaded){
        //别人收我的钱
        TLMessage *newMessage = [[TLMessage alloc] init];
        newMessage.messageType = TLMessageTypeReceiveTransfer;
        newMessage.ownerTyper = TLMessageOwnerTypeOther;
        newMessage.transformFpicture = clickmessage.from.Fpicture;
        newMessage.transformFName = clickmessage.from.FName;
        newMessage.transformNum = clickmessage.transformNum;
        newMessage.date = [NSDate date];
        [self addNewMessage:newMessage];
        [self scrollToBottom];
    }
    clickmessage.readState = TLMessageReaded;
}
#pragma mark - UITableViewCellDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TLMessage *message = _data[indexPath.row];
    CGFloat iHeight = [tableView cellHeightForIndexPath:indexPath model:message keyPath:@"message" cellClass:[TLTextMessageCell class] contentViewWidth:[self cellContentViewWith]];
    NSLog(@"heightForRowAtIndexPath%f",iHeight);
    return iHeight;
}

#pragma mark - UIScrollViewDelegate
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (NSMutableArray *) data
{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

@end
