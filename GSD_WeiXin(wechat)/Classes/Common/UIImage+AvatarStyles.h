//
//  UIImage+AvatarStyles.h
//  LanLvMood
//
//  Created by 郑凯 on 15/9/19.
//  Copyright © 2015年 郑凯. All rights reserved.
//

// 头像专用分类

#import <UIKit/UIKit.h>

@interface UIImage (AvatarStyles)

#pragma mark - Avatar styles

#pragma mark - 将图片裁剪为圆形头像
/**
 *  将图片裁剪为圆形头像
 *
 *  @param size    圆形的直径
 *
 *  @return UIImage
 */
- (UIImage *)circleImageWithSize:(CGFloat)size;

#pragma mark - 将图片裁剪为方形头像
/**
 *  将图片裁剪为方形头像
 *
 *  @param size    方形头像的边长
 *
 *  @return UIImage
 */
- (UIImage *)squareImageWithSize:(CGFloat)size;

#pragma mark - 裁剪头像方法
/**
 *  裁剪头像方法
 *
 *  @param clipToCircle     是否裁剪为圆形 （YES 圆形，NO 方形）
 *  @param diameter         裁剪的边长或直径
 *  @param borderColor      边框的颜色
 *  @param borderWidth      边框的宽度
 *  @param shadowOffset     阴影的大小
 *
 *  @return UIImage
 */
- (UIImage *)imageAsCircle:(BOOL)clipToCircle
               withDiamter:(CGFloat)diameter
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
              shadowOffSet:(CGSize)shadowOffset;

//*************************************

+ (NSString *)createImageName:(NSString *)prefix;
- (UIImage *)fixOrientation:(UIImage *)aImage;

#pragma mark - 通过纯色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage *)createRoundedWithRadius:(CGFloat)radius;

@end


