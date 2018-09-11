//
//  JKPhotoTypeView.h
//  New_Patient
//
//  Created by Jn_Kindle on 2018/8/30.
//  Copyright © 2018年 新开元 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectType)(NSString *type);

@interface JKPhotoTypeView : UIView

@property (nonatomic, copy) DidSelectType didSelectType;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *types;

/**
 显示typeView
 */
- (void)showPhotoTypeView;

/**
 隐藏typeView
 */
- (void)dismissPhotoTypeView;

@end
