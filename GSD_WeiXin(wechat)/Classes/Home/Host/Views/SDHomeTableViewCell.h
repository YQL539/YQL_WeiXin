//
//  SDHomeTableViewCell.h
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/10.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "SDHomeTableViewCellModel.h"

@protocol SDHomeTableViewCellDelegate <NSObject>
-(void)deleteTheCell:(NSIndexPath *)indexPath;
@end
@interface SDHomeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic, strong) SDHomeTableViewCellModel *model;
@property id<SDHomeTableViewCellDelegate>delegate;
+ (CGFloat)fixedHeight;

@end
