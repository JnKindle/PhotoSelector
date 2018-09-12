//
//  GlobalFunction.m
//  InfoPicker
//
//  Created by Jn_Kindle on 2018/8/10.
//  Copyright © 2018年 JnKindle. All rights reserved.
//

#import "GlobalFunction.h"

@implementation GlobalFunction


#pragma mark - UIColor
+ (UIColor *)colorWithHexString:(NSString *)color
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //适配新方法
    return [self colorwithR:r G:g B:b alpha:1.0];
}

+ (UIColor *)colorwithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b alpha:(CGFloat)alpha{
    if (@available(iOS 10.0, *)) {
        return [UIColor colorWithDisplayP3Red:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
    } else {
        // Fallback on earlier versions
        return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
    }
}


+ (UIViewController*)currentController
{
    UIViewController *vc = nil;
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    if ([window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        vc = [(UINavigationController *)window.rootViewController visibleViewController];
    }
    else if ([window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabVC = (UITabBarController*)window.rootViewController;
        vc = [(UINavigationController *)[tabVC selectedViewController] visibleViewController];
    }
    else
    {
        vc = window.rootViewController;
    }
    
    return vc;
}


@end
