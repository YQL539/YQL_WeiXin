//
//  TimeViewController.h
//  GSD_WeiXin(wechat)
//
//  Created by 胡锦吾 on 2017/3/24.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong) NSString *time;
@property (nonatomic) void (^didFinishSetTimeBlock)(NSString *time);

@end
