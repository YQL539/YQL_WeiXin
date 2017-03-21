//
//  TLImageMessageCell.m
//  iOSAppTemplate
//
//  Created by 李伯坤 on 15/10/16.
//  Copyright © 2015年 lbk. All rights reserved.
//

#import "TLImageMessageCell.h"

@implementation TLImageMessageCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self insertSubview:self.messageImageView belowSubview:self.messageBackgroundImageView];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    float y = self.avatarImageView.originY - 3;
    if (self.message.ownerTyper == TLMessageOwnerTypeSelf) {
        float x = self.avatarImageView.originX - self.messageImageView.frameWidth - 5;
        [self.messageImageView setOrigin:CGPointMake(x , y)];
        [self.messageBackgroundImageView setFrame:CGRectMake(x, y, self.message.messageSize.width+ 10, self.message.messageSize.height + 10)];
    }
    else if (self.message.ownerTyper == TLMessageOwnerTypeOther) {
        float x = self.avatarImageView.originX + self.avatarImageView.frameWidth + 5;
        [self.messageImageView setOrigin:CGPointMake(x, y)];
        [self.messageBackgroundImageView setFrame:CGRectMake(x, y, self.message.messageSize.width+ 10, self.message.messageSize.height + 10)];
    }
}

#pragma mark - Getter and Setter
- (void) setMessage:(TLMessage *)message
{
    NSLog(@"%@",message);
    [super setMessage:message];
    self.messageImageView.image = [UIImage imageWithData:message.picture];
    
    
    [self.messageImageView setSize:CGSizeMake(200, 100)];
    
    switch (self.message.ownerTyper) {
        case TLMessageOwnerTypeSelf:
            self.messageBackgroundImageView.image = [[UIImage imageNamed:@"message_sender_background_reversed"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
            break;
        case TLMessageOwnerTypeOther:
            [self.messageBackgroundImageView setImage:[[UIImage imageNamed:@"message_receiver_background_reversed"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch]];
            break;
        default:
            break;
    }
}

- (UIImageView *) messageImageView
{
    if (_messageImageView == nil) {
        _messageImageView = [[UIImageView alloc] init];
        [_messageImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_messageImageView setClipsToBounds:YES];
    }
    return _messageImageView;
}


@end
