
//
//  CommonUtil.m
//  xiaotu
//
//  Created by relech on 15/6/17.
//  Copyright (c) 2015年 relech. All rights reserved.
//

#import "CommonUtil.h"
#import <netdb.h>
#import <CommonCrypto/CommonCrypto.h>

@implementation CommonUtil
+(NSString*) GetProjDir
{
    NSString *pstrProjDir = [NSString stringWithFormat:@"%@%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject], @"/Wechat/"];
    return pstrProjDir;
}
+(BOOL) FileExist:(NSString*)pFile
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return[fileManager fileExistsAtPath:pFile isDirectory:&isDir];
}

+(BOOL) CreatePath:(NSString*)pFold
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:pFold isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        return [fileManager createDirectoryAtPath:pFold withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

+(BOOL) DeletePath:(NSString*)pFold
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:pFold error:nil];
}



+(NSString*) GetFileName:(NSString*)pFile
{
    NSRange range = [pFile rangeOfString:@"/"options:NSBackwardsSearch];
    return [pFile substringFromIndex:range.location + 1];
}

+(NSString*) GetFilePath:(NSString*)pFile
{
    NSRange range = [pFile rangeOfString:@"/"options:NSBackwardsSearch];
    range.length = range.location;
    range.location = 0;
    return [pFile substringWithRange:range];
}



+(BOOL) IsExistFile:(NSString*)pFile
{
    NSFileManager *pFileManager = [NSFileManager defaultManager];
    if(![pFileManager fileExistsAtPath:pFile]) //如果不存在
    {
        return FALSE;
    }
    return TRUE;
}

+(BOOL) RemoveFile:(NSString*)pFile
{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSError *pError;
    return [filemanager removeItemAtPath:pFile error:&pError];
}

+(NSString *)base64EncodeWithString:(NSString *)pstrString
{
    NSData *pInfoData = [pstrString dataUsingEncoding:NSUTF8StringEncoding];
    NSString* pstrBase64String = [pInfoData base64EncodedStringWithOptions:0];
    return pstrBase64String;
}

+(NSString *)base64DecodeWithString:(NSString *)pstrBase64String
{
    NSData *pBase64Data = [[NSData alloc]initWithBase64EncodedString:pstrBase64String options:0];
    NSString *pstrString = [[NSString alloc]initWithData:pBase64Data encoding:NSUTF8StringEncoding];
    return pstrString;
}

/**
 *  手机model转手机型号
 *
 */
+ (NSString *)GetIphoneTypeFromModel:(NSString *)iPhoneModel
{
    
    //需要导入头文件：#import <sys/utsname.h>
    NSString *platform = iPhoneModel;
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";

    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";

    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";

    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])  return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    return platform;
}

+ (void) MastViewByImage:(UIView *)pMaskedView withMaskImage:(UIView *)pMaskImageView{
    UIImage* pImg = [self screenImage:pMaskImageView];
    CALayer *pMask = [CALayer layer];
    pMask.contents = (id)[pImg CGImage];
    pMask.frame = CGRectMake(0, 0, pImg.size.width , pImg.size.height );
    pMaskedView.layer.mask = pMask;
    pMaskedView.layer.masksToBounds = YES;
    pMaskedView.tag = 10;
}

+ (UIImage *) screenImage:(UIView *)pView {
    UIImage *pScreenImage;
    UIGraphicsBeginImageContext(pView.frame.size);
    [pView.layer renderInContext:UIGraphicsGetCurrentContext()];
    pScreenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pScreenImage;
}
@end
