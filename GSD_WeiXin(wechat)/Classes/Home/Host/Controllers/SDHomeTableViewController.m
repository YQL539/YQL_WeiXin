//
//  SDHomeTableViewController.m
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

#import "SDHomeTableViewController.h"
#import "SDContactsSearchResultController.h"

#import "SDAnalogDataGenerator.h"
#import "GlobalDefines.h"
#import "UIView+SDAutoLayout.h"

#import "SDHomeTableViewCell.h"
#import "SDEyeAnimationView.h"
#import "SDShortVideoController.h"
#import "SDChatTableViewController.h"
#import "SDAddSomeController.h"
#import "SDHomeDetailController.h"

#import "TLChatViewController.h"

#define kHomeTableViewControllerCellId @"HomeTableViewController"

#define kHomeObserveKeyPath @"contentOffset"

const CGFloat kHomeTableViewAnimationDuration = 0.25;

#define kCraticalProgressHeight 80

@interface SDHomeTableViewController () <UIGestureRecognizerDelegate,UISearchBarDelegate>

@property (nonatomic, weak) SDEyeAnimationView *eyeAnimationView;

@property (nonatomic, strong) SDShortVideoController *shortVideoController;

@property (nonatomic, assign) BOOL tableViewIsHidden;

@property (nonatomic, assign) CGFloat tabBarOriginalY;
@property (nonatomic, assign) CGFloat tableViewOriginalY;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSArray *dataList;

@end

@implementation SDHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = [SDHomeTableViewCell fixedHeight];
    
    [self.tableView registerClass:[SDHomeTableViewCell class] forCellReuseIdentifier:kHomeTableViewControllerCellId];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //添加
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"tianjia"] selImage:[UIImage imageNamed:@"tianjia"] target:self action:@selector(addClick)];
    
   [self searchCont];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupDataWithCount];
}

- (void)addClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择下列操作" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"添加聊天对象" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        SDAddSomeController *all = [[SDAddSomeController alloc] init];
        all.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:all animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"清空消息" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSArray *userList = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginDict"];
            NSMutableArray *userinfo = [NSMutableArray array];
            if (userList.count >0) {
                [userinfo addObjectsFromArray:userList];
                [userinfo removeAllObjects];
            }
            [[NSUserDefaults standardUserDefaults] setObject:userinfo forKey:@"LoginDict"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self setupDataWithCount];
       }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)searchCont
{
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:[SDContactsSearchResultController new]];
        self.searchController.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
        UISearchBar *bar = self.searchController.searchBar;
        bar.barStyle = UIBarStyleDefault;
        bar.translucent = YES;
        bar.barTintColor = Global_mainBackgroundColor;
        bar.tintColor = Global_tintColor;
        UIImageView *view = [[[bar.subviews objectAtIndex:0] subviews] firstObject];
        view.layer.borderColor = Global_mainBackgroundColor.CGColor;
        view.layer.borderWidth = 1;
        bar.layer.borderColor = [UIColor redColor].CGColor;
        bar.showsBookmarkButton = YES;
        [bar setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
        bar.delegate = self;
        CGRect rect = bar.frame;
        rect.size.height = 44;
        bar.frame = rect;
        self.tableView.tableHeaderView = bar;
}

- (void)setupDataWithCount
{
    NSArray *userList = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginDict"];
    self.dataList = [SDHomeTableViewCellModel mj_objectArrayWithKeyValuesArray:userList];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeTableViewControllerCellId];
    cell.model = self.dataList[indexPath.row];
    if (indexPath.row == (self.dataList.count -1)) {
        cell.separatorInset=UIEdgeInsetsZero;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SDHomeDetailController *home = [[SDHomeDetailController alloc] init];
//    home.model = self.dataList[indexPath.row];
//    home.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:home animated:YES];
    
    TLChatViewController *chat = [[TLChatViewController alloc] init];
    chat.model = self.dataList[indexPath.row];
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
    
    
//    UIViewController *vc = [SDChatTableViewController new];
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)startTableViewAnimationWithHidden:(BOOL)hidden
{
    CGFloat tableViewH = self.tableView.height;
    CGFloat tabBarY = 0;
    CGFloat tableViewY = 0;
    if (hidden) {
        tabBarY = tableViewH + self.tabBarOriginalY;
        tableViewY = tableViewH + self.tableViewOriginalY;
    } else {
        tabBarY = self.tabBarOriginalY;
        tableViewY = self.tableViewOriginalY;
    }
    [UIView animateWithDuration:kHomeTableViewAnimationDuration animations:^{
        self.tableView.top = tableViewY;
        self.navigationController.tabBarController.tabBar.top = tabBarY;
        self.navigationController.navigationBar.alpha = (hidden ? 0 : 1);
    } completion:^(BOOL finished) {
        self.eyeAnimationView.hidden = hidden;

    }];
    if (!hidden) {
        [self.shortVideoController hidde];
    } else {
        [self.shortVideoController show];
    }
    self.tableViewIsHidden = hidden;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return NO;
}

@end
