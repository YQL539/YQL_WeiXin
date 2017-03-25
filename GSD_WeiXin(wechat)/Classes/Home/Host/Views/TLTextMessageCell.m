//
//  TLTextMessageCell.m
//  iOSAppTemplate
//
//  Created by 李伯坤 on 15/10/16.
//  Copyright © 2015年 lbk. All rights reserved.
//

#import "TLTextMessageCell.h"
#import "UIView+SDAutoLayout.h"
#import "UIView+TL.h"
#define kLabelMargin 20.f
#define kLabelTopMargin 8.f
#define kLabelBottomMargin 20.f

#define kChatCellItemMargin 10.f

#define kChatCellIconImageViewWH 35.f

#define kMaxContainerWidth 220.f
#define kMaxLabelWidth (kMaxContainerWidth - kLabelMargin * 2)

#define kMaxChatImageViewWidth 200.f
#define kMaxChatImageViewHeight 300.f

#define kRedWeight 0.68
#define KRedHeight 0.34

#define kVideoWeight 0.4

#define kReceiveRedWeight 0.45
#define KReceiveRedHeight 0.17

@interface TLTextMessageCell ()

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *messageImageView;
@property (nonatomic, strong) UIImageView *containerBackgroundImageView;
@property (nonatomic, strong) UIImageView *maskImageView;
//@property (nonatomic,strong) UILabel *ShowLabel;
@property (nonatomic, assign) NSUInteger voiceMaxWidth;
@property (nonatomic, assign) NSUInteger voiceMinWidth;
@end
@implementation TLTextMessageCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        _voiceMaxWidth = screenW*0.7;
        _voiceMinWidth = screenW * 0.15;
        [self setSubView];
        
    }
    return self;
}

- (void)setSubView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _container = [UIView new];
    _container.userInteractionEnabled = YES;
    [self.contentView addSubview:_container];
    
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    
    _messageTextLabel  = [UILabel new];
    _messageTextLabel.font = [UIFont systemFontOfSize:16.0f];
    _messageTextLabel.numberOfLines = 0;
    _messageTextLabel.isAttributedContent = YES;
    [_container addSubview:_messageTextLabel];
    
    _messageImageView = [UIImageView new];
    _messageImageView.userInteractionEnabled = YES;
    [_container addSubview:_messageImageView];

//    _ShowLabel = [UILabel new];
//    [_container addSubview:_ShowLabel];
    
    
    _containerBackgroundImageView = [UIImageView new];
    _containerBackgroundImageView.userInteractionEnabled = YES;
    [_container insertSubview:_containerBackgroundImageView atIndex:0];
    _maskImageView = [UIImageView new];
    
    [self setupAutoHeightWithBottomView:_container bottomMargin:0];
    
    // 设置containerBackgroundImageView填充父view
    _containerBackgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

- (void)setMessageOriginWithModel:(TLMessage *)TLMessage
{
    //设置聊天头像的方向
    if (TLMessage.ownerTyper == TLMessageOwnerTypeSelf) {
        // 发出去的消息设置居右样式
        self.iconImageView.sd_resetLayout
        .rightSpaceToView(self.contentView, kChatCellItemMargin)
        .topSpaceToView(self.contentView, kChatCellItemMargin)
        .widthIs(kChatCellIconImageViewWH)
        .heightIs(kChatCellIconImageViewWH);
        
        _container.sd_resetLayout.topEqualToView(self.iconImageView).rightSpaceToView(self.iconImageView, kChatCellItemMargin);
        
        _containerBackgroundImageView.image = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
    } else if (TLMessage.ownerTyper == TLMessageOwnerTypeOther) {
        
        // 收到的消息设置居左样式
        self.iconImageView.sd_resetLayout
        .leftSpaceToView(self.contentView, kChatCellItemMargin)
        .topSpaceToView(self.contentView, kChatCellItemMargin)
        .widthIs(kChatCellIconImageViewWH)
        .heightIs(kChatCellIconImageViewWH);
        
        _container.sd_resetLayout.topEqualToView(self.iconImageView).leftSpaceToView(self.iconImageView, kChatCellItemMargin);
        
        _containerBackgroundImageView.image = [[UIImage imageNamed:@"ReceiverTextNodeBkg"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
    }
    _maskImageView.image = _containerBackgroundImageView.image;
}

-(void)setMessage:(TLMessage *)TLMessage 
{
    //按消息类型设置聊天的cell
    switch (TLMessage.messageType) {
        case TLMessageTypeText:
            [self setTextCell:TLMessage];
            break;
        case TLMessageTypeImage:
            [self setImageCell:TLMessage];
            break;
        case TLMessageTypeRedPacket:
            [self setRedPacketCell:TLMessage];
            break;
        case TLMessageTypeReceveRedPacket:
            [self setReceiveRedPacketCell:TLMessage];
            break;
        case TLMessageTypeTransfer:
            [self setTransformCell:TLMessage];
            break;
        case TLMessageTypeReceiveTransfer:
            [self setReceiveTransformCell:TLMessage];
            break;
        case TLMessageTypeTime:
            [self setTimeCell:TLMessage];
            break;
        case TLMessageTypeVoice:
            [self setVoiceCell:TLMessage];
            break;
        case TLMessageTypeCheHui:
            [self setCheHuiCell:TLMessage];
            break;
        case TLMessageTypeVideo:
            [self setVideoCell:TLMessage];
            break;
        default:
            break;
    }
}

#pragma mark ======聊天cell设置=====
-(void)setTextCell:(TLMessage *)TLMessage{
    // 根据model设置cell左浮动或者右浮动样式
    [self setMessageOriginWithModel:TLMessage];
    //头像
    self.iconImageView.image = [UIImage imageWithData:TLMessage.from.picture];
    // 清除展示图片时候用到的mask
    [_container.layer.mask removeFromSuperlayer];
    
    self.messageImageView.hidden = YES;
    [_messageTextLabel setAttributedText:TLMessage.attrText];
    // 清除展示图片时候_containerBackgroundImageView用到的didFinishAutoLayoutBlock
    _containerBackgroundImageView.didFinishAutoLayoutBlock = nil;
    
    _messageTextLabel.sd_resetLayout
    .leftSpaceToView(_container, kLabelMargin)
    .topSpaceToView(_container, kLabelTopMargin)
    .autoHeightRatio(0); // 设置label纵向自适应
    // 设置label横向自适应
    [_messageTextLabel setSingleLineAutoResizeWithMaxWidth:kMaxContainerWidth];
    // container以label为rightView宽度自适应
    [_container setupAutoWidthWithRightView:_messageTextLabel rightMargin:kLabelMargin];
    // container以label为bottomView高度自适应
    [_container setupAutoHeightWithBottomView:_messageTextLabel bottomMargin:kLabelBottomMargin];
    
}

-(void)setImageCell:(TLMessage *)TLMessage{
    // 根据model设置cell左浮动或者右浮动样式
    [self setMessageOriginWithModel:TLMessage];
    // 有图片的先看下设置图片自动布局
    // cell重用时候清除只有文字的情况下设置的container宽度自适应约束
    //头像
    self.iconImageView.image = [UIImage imageWithData:TLMessage.from.picture];
    [self.container clearAutoWidthSettings];
    self.messageImageView.hidden = NO;
    UIImage *img = [UIImage imageWithData:TLMessage.picture];
    self.messageImageView.image = img;
    // 根据图片的宽高尺寸设置图片约束
    CGFloat standardWidthHeightRatio = kMaxChatImageViewWidth / kMaxChatImageViewHeight;
    CGFloat widthHeightRatio = 0;
    UIImage *image = img;
    CGFloat h = image.size.height;
    CGFloat w = image.size.width;
    if (w > kMaxChatImageViewWidth || w > kMaxChatImageViewHeight) {
        widthHeightRatio = w / h;
        if (widthHeightRatio > standardWidthHeightRatio) {
            w = kMaxChatImageViewWidth;
            h = w * (image.size.height / image.size.width);
        } else {
            h = kMaxChatImageViewHeight;
            w = h * widthHeightRatio;
        }
    }
    self.messageImageView.size_sd = CGSizeMake(w, h);
    _container.sd_layout.widthIs(w).heightIs(h);
    // 设置container以messageImageView为bottomView高度自适应
    [_container setupAutoHeightWithBottomView:self.messageImageView bottomMargin:kChatCellItemMargin];
    // container按照maskImageView裁剪
    self.container.layer.mask = self.maskImageView.layer;
    __weak typeof(self) weakself = self;
    [_containerBackgroundImageView setDidFinishAutoLayoutBlock:^(CGRect frame) {
        // 在_containerBackgroundImageView的frame确定之后设置maskImageView的size等于containerBackgroundImageView的size
        weakself.maskImageView.size_sd = frame.size;
    }];
}

-(void)setRedPacketCell:(TLMessage *)TLMessage{
    // 根据model设置cell左浮动或者右浮动样式
    [self setMessageOriginWithModel:TLMessage];
    //头像
    self.iconImageView.image = [UIImage imageWithData:TLMessage.from.picture];
    [self.container clearAutoWidthSettings];
    self.messageImageView.hidden = NO;
    // 根据图片的宽高尺寸设置图片约束
    CGFloat w = kRedWeight * screenW;
    CGFloat h = w * KRedHeight;
    UIImage *img = [[UIImage alloc]init];
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    stateLabel.text = TLMessage.RedPacketString;
    stateLabel.textColor = [UIColor whiteColor];
    stateLabel.backgroundColor = [UIColor clearColor];
    [self.messageImageView addSubview:stateLabel];
    if (TLMessage.ownerTyper == TLMessageOwnerTypeSelf) {
         img = [UIImage imageNamed:@"zijifahong"];
        stateLabel.sd_layout.leftSpaceToView(self.messageImageView,53)
        .topSpaceToView(self.messageImageView,14)
        .widthIs(w - 53-10)
        .heightIs(22);
    }else if (TLMessage.ownerTyper == TLMessageOwnerTypeOther){
        img = [UIImage imageNamed:@"shouhongbao"];
        stateLabel.sd_layout.leftSpaceToView(self.messageImageView,53+8)
        .topSpaceToView(self.messageImageView,14)
        .widthIs(w - 53-10)
        .heightIs(22);
    }
    self.messageImageView.image = img;
    self.messageImageView.contentMode = UIViewContentModeScaleAspectFit;
    _containerBackgroundImageView.hidden = YES;
    
    self.messageImageView.size_sd = CGSizeMake(w, h);
    _container.sd_layout.widthIs(w).heightIs(h);

    // 设置container以messageImageView为bottomView高度自适应
    [_container setupAutoHeightWithBottomView:self.messageImageView bottomMargin:kChatCellItemMargin];
    // container按照maskImageView裁剪
    self.container.layer.mask = self.maskImageView.layer;
    __weak typeof(self) weakself = self;
    [_containerBackgroundImageView setDidFinishAutoLayoutBlock:^(CGRect frame) {
        weakself.maskImageView.size_sd = frame.size;
    }];
}

-(void)setReceiveRedPacketCell:(TLMessage *)TLMessage{
    // 根据图片的宽高尺寸设置图片约束
    [self.container clearAutoHeigtSettings];
    CGFloat w = kReceiveRedWeight * screenW;
    CGFloat h = w * KReceiveRedHeight;
    UIImage *img = [[UIImage alloc]init];
    if (TLMessage.ownerTyper == TLMessageOwnerTypeSelf) {
        img = [UIImage imageNamed:@"duifanglingqu"];
    }else if (TLMessage.ownerTyper == TLMessageOwnerTypeOther){
        img = [UIImage imageNamed:@"nilingqule"];
    }
    UIImageView *pShowView = [[UIImageView alloc]initWithImage:img];
    [self addSubview:pShowView];
    [pShowView setImage:img];

    pShowView.sd_layout
    .leftSpaceToView(self, (screenW - w)/2)
    .heightIs(h)
    .widthIs(w);
    [_container setupAutoHeightWithBottomView:pShowView bottomMargin:0];
    self.container.layer.mask = self.maskImageView.layer;
    __weak typeof(self) weakself = self;
    [_containerBackgroundImageView setDidFinishAutoLayoutBlock:^(CGRect frame) {
        weakself.maskImageView.size_sd = frame.size;
    }];
}
-(void)setTransformCell:(TLMessage *)TLMessage{
    // 根据model设置cell左浮动或者右浮动样式
    [self setMessageOriginWithModel:TLMessage];
    //头像
    self.iconImageView.image = [UIImage imageWithData:TLMessage.from.picture];
    [self.container clearAutoWidthSettings];
    self.messageImageView.hidden = NO;
    // 根据图片的宽高尺寸设置图片约束
    CGFloat w = kRedWeight * screenW;
    CGFloat h = w * KRedHeight;
    UIImage *img = [[UIImage alloc]init];
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    stateLabel.text = TLMessage.transformString;
    stateLabel.textColor = [UIColor whiteColor];
    stateLabel.numberOfLines = 1;
    stateLabel.backgroundColor = [UIColor clearColor];
    [self.messageImageView addSubview:stateLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[TLMessage.transformNum  floatValue]];
    moneyLabel.numberOfLines = 1;
    moneyLabel.textColor = [UIColor whiteColor];
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.font = [UIFont systemFontOfSize:12];
    [self.messageImageView addSubview:moneyLabel];
    if (TLMessage.ownerTyper == TLMessageOwnerTypeSelf) {
        img = [UIImage imageNamed:@"zijizhuang"];
        if (TLMessage.transformString.length == 0) {
            stateLabel.text = @"转账给对方";
        }
        stateLabel.sd_layout.leftSpaceToView(self.messageImageView,53+8)
        .topSpaceToView(self.messageImageView,14)
        .widthIs(w - 53-18)
        .heightIs(22);
        moneyLabel.sd_layout.leftSpaceToView(self.messageImageView,53+8)
        .topSpaceToView(self.messageImageView,14+22)
        .widthIs(w - 53-18)
        .heightIs(14);
    }else if (TLMessage.ownerTyper == TLMessageOwnerTypeOther){
        img = [UIImage imageNamed:@"weixinzhuangzhang"];
        if (TLMessage.transformString.length == 0) {
            stateLabel.text = @"转账给你";
        }
        stateLabel.sd_layout.leftSpaceToView(self.messageImageView,53+18)
        .topSpaceToView(self.messageImageView,14)
        .widthIs(w - 53-20)
        .heightIs(22);
        
        moneyLabel.sd_layout.leftSpaceToView(self.messageImageView,53+18)
        .topSpaceToView(self.messageImageView,14+22)
        .widthIs(w - 53-20)
        .heightIs(14);
    }
    self.messageImageView.image = img;
    self.messageImageView.contentMode = UIViewContentModeScaleAspectFit;
    _containerBackgroundImageView.hidden = YES;
    
    self.messageImageView.size_sd = CGSizeMake(w, h);
    _container.sd_layout.widthIs(w).heightIs(h);
    // 设置container以messageImageView为bottomView高度自适应
    [_container setupAutoHeightWithBottomView:self.messageImageView bottomMargin:kChatCellItemMargin];
    __weak typeof(self) weakself = self;
    [_containerBackgroundImageView setDidFinishAutoLayoutBlock:^(CGRect frame) {
        weakself.maskImageView.size_sd = frame.size;
    }];
}

-(void)setReceiveTransformCell:(TLMessage *)TLMessage{
    // 根据model设置cell左浮动或者右浮动样式
    [self setMessageOriginWithModel:TLMessage];
    //头像
    self.iconImageView.image = [UIImage imageWithData:TLMessage.transformFpicture];
    [self.container clearAutoWidthSettings];
    self.messageImageView.hidden = NO;
    // 根据图片的宽高尺寸设置图片约束
    CGFloat w = kRedWeight * screenW;
    CGFloat h = w * KRedHeight;
    UIImage *img = [[UIImage alloc]init];
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    stateLabel.text = TLMessage.transformString;
    stateLabel.textColor = [UIColor whiteColor];
    stateLabel.text = @"已收钱";
    stateLabel.backgroundColor = [UIColor clearColor];
    [self.messageImageView addSubview:stateLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[TLMessage.transformNum  floatValue]];
    moneyLabel.textColor = [UIColor whiteColor];
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.font = [UIFont systemFontOfSize:12];
    [self.messageImageView addSubview:moneyLabel];
    if (TLMessage.ownerTyper == TLMessageOwnerTypeOther) {
        //好友收了我的钱
        img = [UIImage imageNamed:@"haoyoushouqian"];
        stateLabel.sd_layout.leftSpaceToView(self.messageImageView,53+12)
        .topSpaceToView(self.messageImageView,14)
        .widthIs(w - 53-18)
        .heightIs(18);
        moneyLabel.sd_layout.leftSpaceToView(self.messageImageView,53+12)
        .topSpaceToView(self.messageImageView,14+18)
        .widthIs(w - 53-18)
        .heightIs(14);
        
    }else if (TLMessage.ownerTyper == TLMessageOwnerTypeSelf){
        //我收钱
        img = [UIImage imageNamed:@"woshouqian"];
        stateLabel.sd_layout.leftSpaceToView(self.messageImageView,53+10)
        .topSpaceToView(self.messageImageView,14)
        .widthIs(w - 53-20)
        .heightIs(18);
        
        moneyLabel.sd_layout.leftSpaceToView(self.messageImageView,53+10)
        .topSpaceToView(self.messageImageView,14+18)
        .widthIs(w - 53-20)
        .heightIs(14);
    }
    self.messageImageView.image = img;
    self.messageImageView.contentMode = UIViewContentModeScaleAspectFit;
    _containerBackgroundImageView.hidden = YES;
    
    self.messageImageView.size_sd = CGSizeMake(w, h);
    _container.sd_layout.widthIs(w).heightIs(h);
    // 设置container以messageImageView为bottomView高度自适应
    [_container setupAutoHeightWithBottomView:self.messageImageView bottomMargin:kChatCellItemMargin];
    __weak typeof(self) weakself = self;
    [_containerBackgroundImageView setDidFinishAutoLayoutBlock:^(CGRect frame) {
        weakself.maskImageView.size_sd = frame.size;
    }];
}

-(void)setTimeCell:(TLMessage *)TLMessage{
    // 根据图片的宽高尺寸设置图片约束
    [_container.layer.mask removeFromSuperlayer];
    [self.container clearAutoWidthSettings];
    CGSize size =[CommonUtil GetTextSize:TLMessage.dateString fontname:FONTNAME fontsize:12 width:CGFLOAT_MAX height:CGFLOAT_MAX];

    UILabel *ShowLabel = [UILabel new];
    [self addSubview:ShowLabel];
    ShowLabel.backgroundColor = [CommonUtil GetColor:@"CECECE"];
    ShowLabel.textColor = [UIColor whiteColor];
    ShowLabel.textAlignment = NSTextAlignmentCenter;
    ShowLabel.font = [UIFont fontWithName:FONTNAME size:12];
    ShowLabel.layer.cornerRadius = 3;
    ShowLabel.layer.masksToBounds = YES;
    ShowLabel.text = TLMessage.dateString;
    
    _containerBackgroundImageView.didFinishAutoLayoutBlock = nil;
    _container.sd_layout.heightIs(size.height);
    ShowLabel.sd_layout
    .leftSpaceToView(self, (screenW - size.width - 30)/2)
    .heightIs(size.height)
    .widthIs(size.width + 30);
    _containerBackgroundImageView.hidden = YES;
    [_container setupAutoHeightWithBottomView:ShowLabel bottomMargin:0];
}

-(void)setCheHuiCell:(TLMessage *)TLMessage{
    // 根据图片的宽高尺寸设置图片约束
    [_container.layer.mask removeFromSuperlayer];
    NSString *message = @"";
    if (TLMessage.ownerTyper == TLMessageOwnerTypeOther) {
        message = [NSString stringWithFormat:@"\"%@\"撤回了一条消息",TLMessage.from.nickName];
    }else if (TLMessage.ownerTyper == TLMessageOwnerTypeSelf){
        message = @"你撤回了一条消息";
    }
    
    CGSize size =[CommonUtil GetTextSize:message fontname:FONTNAME fontsize:12 width:CGFLOAT_MAX height:CGFLOAT_MAX];
    UILabel *ShowLabel = [UILabel new];
    [self addSubview:ShowLabel];
    ShowLabel.backgroundColor = [CommonUtil GetColor:@"CECECE"];
    ShowLabel.textColor = [UIColor whiteColor];
    ShowLabel.textAlignment = NSTextAlignmentCenter;
    ShowLabel.font = [UIFont fontWithName:FONTNAME size:12];
    ShowLabel.layer.cornerRadius = 3;
    ShowLabel.layer.masksToBounds = YES;
    ShowLabel.text = message;
    
    _containerBackgroundImageView.didFinishAutoLayoutBlock = nil;
    _container.sd_layout.heightIs(size.height);
    ShowLabel.sd_layout
    .leftSpaceToView(self, (screenW - size.width - 30)/2)
    .heightIs(size.height)
    .widthIs(size.width + 30);
    _containerBackgroundImageView.hidden = YES;
    [_container setupAutoHeightWithBottomView:ShowLabel bottomMargin:0];
    
}

-(void)setVoiceCell:(TLMessage *)TLMessage{
    // 根据model设置cell左浮动或者右浮动样式
    [self setMessageOriginWithModel:TLMessage];
    //头像
    self.iconImageView.image = [UIImage imageWithData:TLMessage.from.picture];
    [self.container clearAutoWidthSettings];
    self.messageImageView.hidden = NO;
    NSInteger iLength = TLMessage.voiceSeconds;
    CGFloat dSoundWidth = _voiceMinWidth + (_voiceMaxWidth/60 * iLength);
    if (dSoundWidth > _voiceMaxWidth) {
        dSoundWidth = _voiceMaxWidth;
    }
    // 根据图片的宽高尺寸设置图片约束
    CGFloat w = dSoundWidth;
    CGFloat h = kChatCellIconImageViewWH;
    UILabel *timeLabel = [UILabel new];
    [_container addSubview:timeLabel];
    timeLabel.text = [NSString stringWithFormat:@"%lu''",(unsigned long)TLMessage.voiceSeconds];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.font = [UIFont systemFontOfSize:14];
    if (TLMessage.ownerTyper == TLMessageOwnerTypeOther) {
        self.messageImageView.image = [[UIImage imageNamed:@"yuyinshoul"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.sd_layout.leftSpaceToView(self.messageImageView,2).bottomSpaceToView(_container,5).heightIs(h).widthIs(50);
    }else if (TLMessage.ownerTyper == TLMessageOwnerTypeSelf){
        self.messageImageView.image = [[UIImage imageNamed:@"yuyingfal.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.sd_layout.rightSpaceToView(self.messageImageView,2).bottomSpaceToView(_container,5).heightIs(h).widthIs(50);
    }
    
    self.messageImageView.size_sd = CGSizeMake(w, h);
    _container.sd_layout.widthIs(w+50).heightIs(h);
    _containerBackgroundImageView.hidden = YES;
    [_container setupAutoWidthWithRightView:_messageImageView rightMargin:0];
    // 设置container以messageImageView为bottomView高度自适应
    [_container setupAutoHeightWithBottomView:self.messageImageView bottomMargin:kChatCellItemMargin];
}


-(void)setVideoCell:(TLMessage *)TLMessage{
    // 根据model设置cell左浮动或者右浮动样式
    [self setMessageOriginWithModel:TLMessage];
    //头像
    self.iconImageView.image = [UIImage imageWithData:TLMessage.from.picture];
    [self.container clearAutoWidthSettings];
    self.messageImageView.hidden = NO;
    
    // 根据图片的宽高尺寸设置图片约束
    CGFloat w = kVideoWeight * screenW;;
    CGFloat h = kChatCellIconImageViewWH;
    UILabel *pLabel = [UILabel new];
    pLabel.font = [UIFont systemFontOfSize:14];
    NSUInteger iMin = [TLMessage.videoMinutes integerValue];
    NSUInteger iSec = [TLMessage.videoSeconds integerValue];
    pLabel.text = [NSString stringWithFormat:@"通话时长 %02lu:%02lu 图片",(unsigned long)iMin,(unsigned long)iSec];
    pLabel.backgroundColor = [UIColor clearColor];
    [self.messageImageView addSubview:pLabel];
    pLabel.sd_layout.leftSpaceToView(self.messageImageView,10).widthIs(w).heightIs(h);
    
    if (TLMessage.ownerTyper == TLMessageOwnerTypeOther) {
        self.messageImageView.image = [[UIImage imageNamed:@"yuyinshoul"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
        
    }else if (TLMessage.ownerTyper == TLMessageOwnerTypeSelf){
        self.messageImageView.image = [[UIImage imageNamed:@"yuyingfal.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:30];
        
    }
    
    self.messageImageView.size_sd = CGSizeMake(w, h);
    _container.sd_layout.widthIs(w).heightIs(h);
    _containerBackgroundImageView.hidden = YES;
    [_container setupAutoWidthWithRightView:_messageImageView rightMargin:0];
    // 设置container以messageImageView为bottomView高度自适应
    [_container setupAutoHeightWithBottomView:self.messageImageView bottomMargin:kChatCellItemMargin];

}


@end
