//
//  WKWaitingProgressHUD.m
//  WKProgressHUD
//
//  Created by Welkin Xie on 3/8/16.
//  Copyright © 2016 WelkinXie. All rights reserved.
//

#import "WKWaitingProgressHUD.h"

@implementation WKWaitingProgressHUD

- (void)addIndicator {
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.indicatorView startAnimating];
}

- (void)addText {
    if (self.text.length > 0) {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.text = self.text;
        self.textLabel.textColor = [UIColor whiteColor];
        
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.textLabel sizeToFit];
        
        NSUInteger line = CGRectGetWidth(self.textLabel.frame) / (CGRectGetWidth([UIScreen mainScreen].bounds) - 130);
        if (line >= 1) {
            self.textLabel.numberOfLines = line + 1;
            self.textLabel.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 130, CGRectGetHeight(self.textLabel.frame));
            CGSize size = [self.textLabel sizeThatFits:self.textLabel.frame.size];
            self.textLabel.frame = CGRectMake(0, 0, size.width, size.height);
        }
    }
}

- (void)compositeElements {
    if (self.textLabel) {
        CGFloat width = CGRectGetWidth(self.textLabel.frame) > 50 ? CGRectGetWidth(self.textLabel.frame) + 35 : 85;
        CGFloat height = CGRectGetHeight(self.textLabel.frame) + 80;
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        
        self.indicatorView.center = CGPointMake(CGRectGetMidX(self.backView.bounds), CGRectGetMinY(self.backView.frame) + 35);
        self.textLabel.center = CGPointMake(CGRectGetMidX(self.backView.bounds), (CGRectGetMaxY(self.backView.bounds) + CGRectGetMaxY(self.indicatorView.bounds)) / 2 + 6);
        
        [self.backView addSubview:self.textLabel];
    }
    else {
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, 85)];
        
        self.indicatorView.center = CGPointMake(CGRectGetMidX(self.backView.bounds), CGRectGetMidY(self.backView.bounds));
    }
    self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.backView.layer.cornerRadius = 10;
    self.backView.center = CGPointMake(CGRectGetMidX(self.selfView.frame), CGRectGetMidY(self.selfView.frame));
    [self.backView addSubview:self.indicatorView];
}

@end// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com