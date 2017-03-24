//  CommonUtil.h
//  xiaotu
//
//  Created by relech on 15/6/17.
//  Copyright (c) 2015年 relech. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/utsname.h>

@interface CommonUtil : NSObject

/**
 *  获取项目沙盒目录
 *
 *  @return 沙盒目录+zuozuo
 */
+(NSString*) GetProjDir;
/**
 *  创建目录
 *
 *  @param pFold 需要创建的目录
 *
 *  @return 创建返回的结果
 */
+(BOOL) CreatePath:(NSString*)pFold;
/**
 *  删除目录
 *
 *  @param pFold 需要删除的目录
 *
 *  @return 结果
 */
+(BOOL) DeletePath:(NSString*)pFold;
/**
 *  查看文件是否存在
 *
 *  @param pFile 文件路径
 *
 *  @return 结果
 */
+(BOOL) FileExist:(NSString*)pFile;
/**
 *  从路径中获取文件名
 *
 *  @param pFile 包含文件名的路径
 *
 *  @return 文件名
 */
+(NSString*) GetFileName:(NSString*)pFile;
/**
 *  获取文件路径
 *
 *  @param pFile 包含路径的字符串
 *
 *  @return 文件路径
 */

+(NSString*) GetFilePath:(NSString*)pFile;

+(BOOL) IsExistFile:(NSString*)pFile;
/**
 *  删除文件
 *
 *  @param pFile 文件路径
 *
 *  @return 结果
 */
+(BOOL) RemoveFile:(NSString*)pFile;

/**
 *  Base64加密
 *
 */
+(NSString *)base64EncodeWithString:(NSString *)pstrString;
/**
 *  Base64解密
 *
 */
+(NSString *)base64DecodeWithString:(NSString *)pstrBase64String;
+(CGSize) GetTextSize:(NSString*) pText fontname:(NSString*) pFont fontsize:(NSInteger)iFontSize width:(CGFloat)dWidth height:(CGFloat)dHeight;
/**
 *  手机model转手机型号
 *
 */
+ (NSString *)GetIphoneTypeFromModel:(NSString *)iPhoneModel;
/*
 *气泡融合
 */
+ (void) MastViewByImage:(UIView *)pMaskedView withMaskImage:(UIView *)pMaskImageView;
@end
