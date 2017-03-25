//
//  TLChatMessageViewContrller.h
//  iOSAppTemplate
//
//  Created by 李伯坤 on 15/9/24.
//  Copyright (c) 2015年 lbk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLMessage.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
//聊天的tableview
//@class TLChatMessageViewContrller;
//@protocol TLChatMessageViewControllerDelegate <NSObject>
//- (void) didTapChatMessageView:(TLChatMessageViewContrller *)chatMessageViewController;
//@end

@interface TLChatMessageViewContrller : UITableViewController

//@property (nonatomic, assign) id<TLChatMessageViewControllerDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSString *FName;


- (void) addNewMessage:(TLMessage *)message;
- (void) scrollToBottom;

@end
