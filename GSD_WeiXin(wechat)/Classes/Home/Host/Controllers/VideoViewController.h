//
//  VideoViewController.h
//  GSD_WeiXin(wechat)
//
//  Created by 胡锦吾 on 2017/3/26.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong) NSString *minutes;
@property (nonatomic,strong) NSString *seconds;
@property (nonatomic) void (^didFinishSetVideoBlock)(NSString *minutes,NSString *seconds);



@end
