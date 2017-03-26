//
//  TLMessage.m
//  iOSAppTemplate
//
//  Created by 李伯坤 on 15/10/16.
//  Copyright © 2015年 lbk. All rights reserved.
//

#import "TLMessage.h"
#import "TLChatHelper.h"

static UILabel *label = nil;

@implementation TLMessage

- (id) init
{
    if (self = [super init]) {
        if (label == nil) {
            label = [[UILabel alloc] init];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:16.0f]];
        }
    }
    return self;
}

#pragma mark - Setter
- (void) setText:(NSString *)text
{
    _text = text;
    if (text.length > 0) {
        _attrText = [TLChatHelper formatMessageString:text];
    }
}


-(void)encodeWithCoder:(NSCoder *)pCoder{
    [pCoder encodeObject:_from forKey:@"from"];
    [pCoder encodeObject:_date forKey:@"date"];
    [pCoder encodeObject:_dateString forKey:@"dateString"];
    [pCoder encodeInt64:_messageType forKey:@"messageType"];
    [pCoder encodeInt64:_ownerTyper forKey:@"ownerTyper"];
    [pCoder encodeObject:_text forKey:@"text"];
    [pCoder encodeObject:_attrText forKey:@"attrText"];
    [pCoder encodeObject:_picture forKey:@"picture"];
    [pCoder encodeObject:_image forKey:@"image"];
    [pCoder encodeInt64:_voiceSeconds forKey:@"voiceSeconds"];
    [pCoder encodeInt64:_readState forKey:@"readState"];

    [pCoder encodeObject:_videoMinutes forKey:@"videoMinutes"];
    [pCoder encodeObject:_videoSeconds forKey:@"videoSeconds"];
    [pCoder encodeObject:_RedPacketString forKey:@"RedPacketString"];
    [pCoder encodeObject:_transformNum forKey:@"transformNum"];
    [pCoder encodeObject:_transformString forKey:@"transformString"];
    [pCoder encodeObject:_transformStarTime forKey:@"transformStarTime"];
    [pCoder encodeObject:_transformEndTime forKey:@"transformEndTime"];
    [pCoder encodeObject:_transformFName forKey:@"transformFName"];
    [pCoder encodeObject:_transformFpicture forKey:@"transformFpicture"];
}

-(id)initWithCoder:(NSCoder *)pCoder{
    _from = [pCoder decodeObjectForKey:@"from"];
    _date = [pCoder decodeObjectForKey:@"date"];
    _dateString = [pCoder decodeObjectForKey:@"dateString"];
    _messageType = [pCoder decodeInt64ForKey:@"messageType"];
    _readState = [pCoder decodeInt64ForKey:@"readState"];
    _ownerTyper = [pCoder decodeInt64ForKey:@"ownerTyper"];
    _text = [pCoder decodeObjectForKey:@"text"];
    _attrText = [pCoder decodeObjectForKey:@"attrText"];
    _picture = [pCoder decodeObjectForKey:@"picture"];
    _image = [pCoder decodeObjectForKey:@"image"];
    _voiceSeconds = [pCoder decodeInt64ForKey:@"voiceSeconds"];
    _videoMinutes = [pCoder decodeObjectForKey:@"videoMinutes"];
    _videoSeconds = [pCoder decodeObjectForKey:@"videoSeconds"];
    _RedPacketString = [pCoder decodeObjectForKey:@"RedPacketString"];
    _transformNum = [pCoder decodeObjectForKey:@"transformNum"];
    _transformString = [pCoder decodeObjectForKey:@"transformString"];
    _transformStarTime = [pCoder decodeObjectForKey:@"transformStarTime"];
    _transformEndTime = [pCoder decodeObjectForKey:@"transformEndTime"];
    _transformFName = [pCoder decodeObjectForKey:@"transformFName"];
    _transformFpicture = [pCoder decodeObjectForKey:@"transformFpicture"];
    return self;
}

@end
