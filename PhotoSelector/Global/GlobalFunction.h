//
//  GlobalFunction.h
//  InfoPicker
//
//  Created by Jn_Kindle on 2018/8/10.
//  Copyright © 2018年 JnKindle. All rights reserved.
//

//当前系统显示页面
#define JNKEYWINDOW ((UIWindow*)[[UIApplication sharedApplication].windows objectAtIndex:0]) //当前窗口
#define JNAPPCurrentController [GlobalFunction currentController] //当前显示的控制器

//循环引用
#define JnWeakSelf __weak typeof(self) weakSelf = self;

//颜色
#define RGB_COLOR(R, G, B)       [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]
#define RGBA_COLOR(R, G, B, A)   [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

//布局配置
#define JN_SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define JN_SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define JN_SCREEN_FIT     JN_SCREEN_WIDTH / 375 //尺寸比例（以iphone6 750 X 1334 为基础）
#define JN_TabBarH        49.0f
#define JN_StatusBarH     [UIApplication sharedApplication].statusBarFrame.size.height

//打印相关
#ifdef DEBUG
#define JNLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define JNLog(...)
#endif

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>




@interface GlobalFunction : NSObject



#pragma mark - UIColor
+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIViewController*)currentController;

@end
