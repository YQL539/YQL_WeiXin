//
//  SDContactsTableViewController.m
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

#import "SDContactsTableViewController.h"
#import "SDContactsSearchResultController.h"

#import "SDContactModel.h"
#import "SDAnalogDataGenerator.h"

#import "SDContactsTableViewCell.h"

#import "GlobalDefines.h"
#import "SDContactAddController.h"
#import "SDHomeTableViewCellModel.h"

#define KCNSSTRING_ISEMPTY(str) (str == nil || [str isEqual:[NSNull null]] || str.length <= 0)

@interface SDContactsTableViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic,strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) NSMutableArray *sectionTitlesArray;

@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,strong) NSArray *dataoneArray;

@property (nonatomic,strong) NSDictionary *allKeysDict;

@property (nonatomic,strong) NSMutableArray *sectionList;

@end

@implementation SDContactsTableViewController

- (NSMutableArray *)sectionList
{
    if (_sectionList == nil) {
        _sectionList = [NSMutableArray array];
    }
    return _sectionList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.tableView.rowHeight = [SDContactsTableViewCell fixedHeight];
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionHeaderHeight = 25;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self genDataWithCount];
}

- (void)genDataWithCount
{
    if (self.sectionList.count >0) {
        [self.sectionList removeAllObjects];
    }
    NSArray *userList = [[NSUserDefaults standardUserDefaults] objectForKey:@"tongxunlu"];
    self.dataList = [SDHomeTableViewCellModel mj_objectArrayWithKeyValuesArray:userList];
    NSMutableArray *strArr = [NSMutableArray array];
    for (SDHomeTableViewCellModel *model in self.dataList) {
        [strArr addObject:model.nickName];
    }
    self.allKeysDict = [self createCharacter:strArr];
    self.dataoneArray = [self.allKeysDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        NSString *letter1 = obj1;
        NSString *letter2 = obj2;
        if (KCNSSTRING_ISEMPTY(letter2)) {
            return NSOrderedDescending;
        }else if ([letter1 characterAtIndex:0] < [letter2 characterAtIndex:0]) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    NSArray *dicts = @[@{@"nickName" : @"新的朋友", @"picture" :UIImagePNGRepresentation([UIImage imageNamed:@"plugins_FriendNotify"])},
                       @{@"nickName" : @"群聊", @"picture" : UIImagePNGRepresentation([UIImage imageNamed:@"add_friend_icon_addgroup"])},
                       @{@"nickName" : @"标签", @"picture" :UIImagePNGRepresentation([UIImage imageNamed:@"Contact_icon_ContactTag"])},
                       @{@"nickName" : @"公众号", @"picture" : UIImagePNGRepresentation([UIImage imageNamed:@"add_friend_icon_offical"])}];
    NSMutableArray *operrationModels = [NSMutableArray array];
    for (NSDictionary *dict in dicts) {
        SDHomeTableViewCellModel *model = [SDHomeTableViewCellModel mj_objectWithKeyValues:dict];
        [operrationModels addObject:model];
    }
    [self.sectionList addObject:operrationModels];
    
    for (int t = 0; t < self.dataoneArray.count; t++) {
        NSArray *hostList = self.allKeysDict[self.dataoneArray[t]];
        NSMutableArray *hostArray = [NSMutableArray array];
        for(int m=0; m< hostList.count;m++){
            for (SDHomeTableViewCellModel *model in self.dataList) {
                if (model.nickName == hostList[m]) {
                    [hostArray addObject:model];
                }
            }
        }
        [self.sectionList addObject:hostArray];
    }
    [self.tableView reloadData];
}

//这个方法就是将你获取的数据汉字抽取出来，获取首字母，放进字典，键是首字母，值是汉字
- (NSDictionary *)createCharacter:(NSMutableArray *)strArr
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *string in strArr) {
        if ([string length]) {
            NSMutableString *mutableStr = [[NSMutableString alloc]initWithString:string];
            
            if (CFStringTransform((__bridge CFMutableStringRef)mutableStr,0,kCFStringTransformMandarinLatin,NO)) {
            }
            if (CFStringTransform((__bridge CFMutableStringRef)mutableStr,0,kCFStringTransformStripDiacritics,NO)) {
                NSString *str = [NSString stringWithString:mutableStr];
                str = [str uppercaseString];
                NSMutableArray *subArray = [dict objectForKey:[str substringToIndex:1]];
                if (!subArray) {
                    subArray = [NSMutableArray array];
                    [dict setObject:subArray forKey:[str substringToIndex:1]];
                }
                [subArray addObject:string];
            }
        }
    }
    return dict;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.sectionList.count>0) {
        return self.dataoneArray.count + 1;
    }
    return self.dataoneArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *list = self.sectionList[section];
    return list.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section>0) {
        return self.dataoneArray[section -1];
    }else{
        return nil;
    }
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.dataoneArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"SDContacts";
    SDContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SDContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SDHomeTableViewCellModel *model = self.sectionList[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"朋友设置" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"添加朋友" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                SDContactAddController *add = [[SDContactAddController alloc] init];
                [self.navigationController pushViewController:add animated:YES];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"清空列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSArray *userList = [[NSUserDefaults standardUserDefaults] objectForKey:@"tongxunlu"];
                NSMutableArray *userinfo = [NSMutableArray array];
                if (userList.count >0) {
                    [userinfo addObjectsFromArray:userList];
                    [userinfo removeAllObjects];
                }
                [[NSUserDefaults standardUserDefaults] setObject:userinfo forKey:@"tongxunlu"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self genDataWithCount];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            NSLog(@"聊天");
        }
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return NO;
}


@end
