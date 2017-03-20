//
//  SDHomeDetailController.m
//  GSD_WeiXin(wechat)
//
//  Created by apple on 17/3/19.
//  Copyright © 2017年 GSD. All rights reserved.
//

#import "SDHomeDetailController.h"
#import "GlobalDefines.h"
#import "SDHomeTableViewCellModel.h"

@interface SDHomeDetailController ()

@end

@implementation SDHomeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.title = self.model.nickName;
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, screenH - 49, screenW, 49)];
    bottom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottom];
    
    UITableView *homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenW, screenH - 64 -49)];
    homeTable.backgroundColor = [UIColor colorWithHexString:@"#efeff5"];
    [self.view addSubview:homeTable];

}



@end
