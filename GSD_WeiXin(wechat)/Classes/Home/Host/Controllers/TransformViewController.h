//
//  TransformViewController.h
//  GSD_WeiXin(wechat)
//
//  Created by 胡锦吾 on 2017/3/22.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TransformViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,copy) NSString *moneyStatus;
@property (nonatomic,copy) NSString *moneyNum;
@property (nonatomic,copy) NSString *starTime;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic) void (^didFinishSetTransformBlock)(NSString *moneyNum,NSString *moneyState,NSString *starTime,NSString *endTime);


@end
