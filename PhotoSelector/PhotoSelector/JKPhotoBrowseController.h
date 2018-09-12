//
//  JKPhotoBrowseController.h
//  New_Patient
//
//  Created by Jn_Kindle on 2018/8/30.
//  Copyright © 2018年 新开元 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ImageType){
    NetWorkImage  = 0,     //网络图片 默认
    LocateImage   = 1,     //本地托片
};

@interface JKPhotoBrowseController : UIViewController

/**
 传入图片数组
 */
@property (nonatomic, strong) NSArray *imagesArry;

/**
 当前需要显示的位置
 */
@property (nonatomic, assign) NSInteger currentPosition;

@property (nonatomic, assign) ImageType imageType;

@end
