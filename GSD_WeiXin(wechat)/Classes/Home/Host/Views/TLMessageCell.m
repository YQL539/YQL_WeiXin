//
//  TLMessageCell.m
//  iOSAppTemplate
//
//  Created by 李伯坤 on 15/10/16.
//  Copyright © 2015年 lbk. All rights reserved.
//

#import "TLMessageCell.h"
#import "UIView+TL.h"

@implementation TLMessageCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        [self addSubview:self.avatarImageView];
//        [self addSubview:self.messageBackgroundImageView];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
//    if (_message.ownerTyper == TLMessageOwnerTypeSelf) {
//        [self.avatarImageView setOrigin:CGPointMake(self.frameWidth - 10 - self.avatarImageView.frameWidth, 10)];
//    }
//    else if (_message.ownerTyper == TLMessageOwnerTypeOther) {
//        [self.avatarImageView setOrigin:CGPointMake(10, 10)];
//    }
}

#pragma mark - Getter and Stter
- (void) setMessage:(TLMessage *)message
{
    _message = message;
    

}

//- (UIImageView *)avatarImageView
//{
//    if (_avatarImageView == nil) {
//        float imageWidth = 40;
//        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
//        [_avatarImageView setHidden:YES];
//    }
//    return _avatarImageView;
//}
//
//- (UIImageView *) messageBackgroundImageView
//{
//    if (_messageBackgroundImageView == nil) {
//        _messageBackgroundImageView = [[UIImageView alloc] init];
//        [_messageBackgroundImageView setHidden:YES];
//    }
//    return _messageBackgroundImageView;
//}

@end
