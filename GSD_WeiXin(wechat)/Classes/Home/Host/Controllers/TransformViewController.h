//
//  TransformViewController.h
//  GSD_WeiXin(wechat)
//
//  Created by 胡锦吾 on 2017/3/22.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TransformViewController : UIViewController<UITextFieldDelegate>
//@property (nonatomic,assign) NSInteger ownerType;
@property (nonatomic,strong) NSString *moneyStatus;
@property (nonatomic,strong) NSString *moneyNum;
@property (nonatomic) void (^didFinishSetRedPacketBlock)(NSString *moneyNum,NSString *moneyState);


@end
