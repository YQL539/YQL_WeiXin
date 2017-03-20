//
//  TLUserHelper.m
//  iOSAppTemplate
//
//  Created by 李伯坤 on 15/10/19.
//  Copyright © 2015年 lbk. All rights reserved.
//

#import "TLUserHelper.h"

static TLUserHelper *userHelper = nil;

@implementation TLUserHelper

+ (TLUserHelper *)sharedUserHelper
{
    if (userHelper == nil) {
        userHelper = [[TLUserHelper alloc] init];
        
    }
    return userHelper;
}

- (SDHomeTableViewCellModel  *) user
{
    if (_user == nil) {
        _user = [[SDHomeTableViewCellModel  alloc] init];
        _user.nickName = @"自定义名字";
        //_user.userID = @"li-bokun";
        _user.picture = UIImagePNGRepresentation([UIImage imageNamed:@"1.jpg"]);
    }
    return _user;
}

@end
