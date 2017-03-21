//
//  TLTextMessageCell.h
//  iOSAppTemplate
//
//  Created by 李伯坤 on 15/10/16.
//  Copyright © 2015年 lbk. All rights reserved.
//

#import "TLMessageCell.h"
#import "MLEmojiLabel.h"
@interface TLTextMessageCell : TLMessageCell

@property (nonatomic, strong) MLEmojiLabel *messageTextLabel;
@property (nonatomic, copy) void (^didSelectLinkTextOperationBlock)(NSString *link, MLEmojiLabelLinkType type);
@end
