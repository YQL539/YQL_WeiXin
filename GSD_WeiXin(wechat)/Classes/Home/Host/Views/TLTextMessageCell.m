//
//  TLTextMessageCell.m
//  iOSAppTemplate
//
//  Created by 李伯坤 on 15/10/16.
//  Copyright © 2015年 lbk. All rights reserved.
//

#import "TLTextMessageCell.h"
#import "UIView+SDAutoLayout.h"

#define kLabelMargin 20.f
#define kLabelTopMargin 8.f
#define kLabelBottomMargin 20.f

#define kChatCellItemMargin 10.f

#define kChatCellIconImageViewWH 35.f

#define kMaxContainerWidth 220.f
#define kMaxLabelWidth (kMaxContainerWidth - kLabelMargin * 2)

#define kMaxChatImageViewWidth 200.f
#define kMaxChatImageViewHeight 300.f

#define kRedPacketImageViewWidth 400.f
#define kRedPacketImageViewHeight 140.f

@interface TLTextMessageCell ()

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *messageImageView;
@property (nonatomic, strong) UIImageView *containerBackgroundImageView;
@property (nonatomic, strong) UIImageView *maskImageView;
@end
@implementation TLTextMessageCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.messageTextLabel];
        [self setSubView];
        
    }
    return self;
}

- (void)setSubView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    
    _messageTextLabel  = [UILabel new];
    _messageTextLabel.font = [UIFont systemFontOfSize:16.0f];
    _messageTextLabel.numberOfLines = 0;
    _messageTextLabel.isAttributedContent = YES;
    [_container addSubview:_messageTextLabel];
    
    _messageImageView = [UIImageView new];
    [_container addSubview:_messageImageView];

    _containerBackgroundImageView = [UIImageView new];
    [_container insertSubview:_containerBackgroundImageView atIndex:0];
    _maskImageView = [UIImageView new];
    
    [self setupAutoHeightWithBottomView:_container bottomMargin:0];
    
    // 设置containerBackgroundImageView填充父view
    _containerBackgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

- (void)setMessageOriginWithModel:(TLMessage *)TLMessage
{
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
    // 根据model设置cell左浮动或者右浮动样式
    [self setMessageOriginWithModel:TLMessage];
    self.iconImageView.image = [UIImage imageWithData:TLMessage.from.picture];
    if (TLMessage.messageType == TLMessageTypeImage) {
        [self setImageCell:TLMessage];
    } else if (TLMessage.messageType == TLMessageTypeText) {
        [self setTextCell:TLMessage];
    }else if (TLMessage.messageType == TLMessageTypeRedPacket){
        [self setRedPacketCell:TLMessage];
    }
}

#pragma mark ======聊天cell设置=====
-(void)setTextCell:(TLMessage *)TLMessage{
    // 没有图片有文字情况下设置文字自动布局
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
    // 有图片的先看下设置图片自动布局
    // cell重用时候清除只有文字的情况下设置的container宽度自适应约束
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
    [self.container clearAutoWidthSettings];
    self.messageImageView.hidden = NO;
    UIImage *img = [UIImage imageWithData:TLMessage.picture];//红包图片
//    self.messageImageView.image = img;
    self.messageImageView.backgroundColor = [UIColor redColor];
    // 根据图片的宽高尺寸设置图片约束
    CGFloat h = kRedPacketImageViewHeight;
    CGFloat w = kRedPacketImageViewWidth;
    
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

























//- (void) layoutSubviews
//{
//    [super layoutSubviews];
//    float y = self.avatarImageView.originY + 11;
//    float x = self.avatarImageView.originX + (self.message.ownerTyper == TLMessageOwnerTypeSelf ? - self.messageTextLabel.frameWidth - 27 : self.avatarImageView.frameWidth + 23);
//    [self.messageTextLabel setOrigin:CGPointMake(x, y)];
//    
//    x -= 18;                                    // 左边距离头像 5
//    y = self.avatarImageView.originY - 5;       // 上边与头像对齐 (北京图像有5个像素偏差)
//    float h = MAX(self.messageTextLabel.frameHeight + 30, self.avatarImageView.frameHeight + 10);
//    [self.messageBackgroundImageView setFrame:CGRectMake(x, y, self.messageTextLabel.frameWidth + 40, h)];
//}
//
//
//- (UILabel *) messageTextLabel
//{
//    if (_messageTextLabel == nil) {
//        _messageTextLabel = [[UILabel alloc] init];
//        [_messageTextLabel setFont:[UIFont systemFontOfSize:16.0f]];
//        [_messageTextLabel setNumberOfLines:0];
//    }
//    return _messageTextLabel;
//}
@end
