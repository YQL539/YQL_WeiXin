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

//@property (nonatomic, strong) UITapGestureRecognizer *tapGR;

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
    if ([CommonUtil IsExistFile:WECHAT_FRIENDCHAT(_FName)]) {
        // data.
        NSData *data = [NSData dataWithContentsOfFile:WECHAT_FRIENDCHAT(_FName)];
        
        // 反归档.
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        // 获取@"model" 所对应的数据
        NSArray *pArray = [unarchiver decodeObjectForKey:@"model"];
        
        // 反归档结束.
        [unarchiver finishDecoding];
        [self.data addObjectsFromArray:pArray];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 创建归档时所需的data 对象.
    NSMutableData *data = [NSMutableData data];
    
    // 归档类.
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    // 开始归档（@"model" 是key值，也就是通过这个标识来找到写入的对象)
    [archiver encodeObject:self.data forKey:@"model"];
    
    // 归档结束.
    [archiver finishEncoding];
    
    [data writeToFile:WECHAT_FRIENDCHAT(_FName) atomically:YES];
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
    if (clickmessage.ownerTyper == TLMessageOwnerTypeOther) {
        //我领取别人的红包
        TLMessage *newMessage = [[TLMessage alloc] init];
        newMessage.messageType = TLMessageTypeReceveRedPacket;
        newMessage.ownerTyper = TLMessageOwnerTypeOther;
        newMessage.date = [NSDate date];
        [self addNewMessage:newMessage];
        [self scrollToBottom];
    }else if (clickmessage.ownerTyper == TLMessageOwnerTypeSelf){
        //别人领取我的红包
        TLMessage *newMessage = [[TLMessage alloc] init];
        newMessage.messageType = TLMessageTypeReceveRedPacket;
        newMessage.ownerTyper = TLMessageOwnerTypeSelf;
        newMessage.date = [NSDate date];
        [self addNewMessage:newMessage];
        [self scrollToBottom];
    }
}

-(void)didSelectedTransfer:(TLMessage *)clickmessage{
    if (clickmessage.ownerTyper == TLMessageOwnerTypeOther) {
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
    }else if (clickmessage.ownerTyper == TLMessageOwnerTypeSelf){
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

#pragma mark - Event Response
//- (void) didTapView
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(didTapChatMessageView:)]) {
//        [_delegate didTapChatMessageView:self];
//    }
//}
//
//#pragma mark - Getter
//- (UITapGestureRecognizer *) tapGR
//{
//    if (_tapGR == nil) {
//        _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
//    }
//    return _tapGR;
//}

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
