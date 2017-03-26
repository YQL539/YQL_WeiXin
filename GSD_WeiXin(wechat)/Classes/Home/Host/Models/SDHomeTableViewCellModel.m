//
//  SDHomeTableViewCellModel.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/10.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import "SDHomeTableViewCellModel.h"

@implementation SDHomeTableViewCellModel
-(void)encodeWithCoder:(NSCoder *)pCoder{
    [pCoder encodeObject:_picture forKey:@"picture"];
    [pCoder encodeObject:_Fpicture forKey:@"fpicture"];
    [pCoder encodeObject:_FName forKey:@"fname"];
    [pCoder encodeObject:_nickName forKey:@"nickname"];
    [pCoder encodeObject:_content forKey:@"content"];
    [pCoder encodeObject:_time forKey:@"time"];
    [pCoder encodeObject:_message forKey:@"message"];
}

-(id)initWithCoder:(NSCoder *)pCoder{
    _picture = [pCoder decodeObjectForKey:@"picture"];
    _Fpicture = [pCoder decodeObjectForKey:@"fpicture"];
    _FName = [pCoder decodeObjectForKey:@"fname"];
    _nickName = [pCoder decodeObjectForKey:@"nickname"];
    _content = [pCoder decodeObjectForKey:@"content"];
    _time = [pCoder decodeObjectForKey:@"time"];
    _message = [pCoder decodeObjectForKey:@"message"];
    return self;
}

@end
