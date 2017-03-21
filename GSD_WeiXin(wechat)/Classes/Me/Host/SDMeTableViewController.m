//
//  SDMeTableViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/10.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDMeTableViewController.h"
#import "SDMeController.h"
#import "SDNameModel.h"

@interface SDMeTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *weixin;

@end

@implementation SDMeTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    
    return [[UIStoryboard storyboardWithName:@"SDMeTableViewController" bundle:nil] instantiateInitialViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iconView.layer.cornerRadius = 5;
    self.iconView.clipsToBounds = YES;
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([CommonUtil IsExistFile:WECHAT_USER]) {
        NSDictionary *pMeDic = [[NSDictionary alloc] initWithContentsOfFile:WECHAT_USER];
        SDNameModel *model = [SDNameModel mj_objectWithKeyValues:pMeDic];
        self.headIcon.image = [UIImage imageWithData:model.picture];
        self.name.text = model.nickName;
        self.weixin.text = [NSString stringWithFormat:@"微信号: %@",model.weixin];
    }
//    if (userDic.count) {
//        SDNameModel *model = [SDNameModel mj_objectWithKeyValues:userDic];
//        self.headIcon.image = [UIImage imageWithData:model.picture];
//        self.name.text = model.nickName;
//        self.weixin.text = [NSString stringWithFormat:@"微信号: %@",model.weixin];
//    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row == 0) {
        SDMeController *me = [[SDMeController alloc] init];
        [self.navigationController pushViewController:me animated:YES];
        }
    }
}

@end
