//
//  JKPhotoSelectorView.h
//  New_Patient
//
//  Created by Jn_Kindle on 2018/6/1.
//  Copyright © 2018年 新开元 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScrollDirection) {
    PSScrollVertical,  //垂直
    PSScrollHorizontal //水平
};
typedef void(^DidSelectImages)(NSArray *imageArray,CGFloat photoSelectorViewHeight);

@interface JKPhotoSelectorView : UIView

@property (nonatomic, copy) DidSelectImages didSelectImages;

//图片选择最大数量
@property (nonatomic, assign) NSInteger maxImageCount;

//图片大小 （等宽高）
@property (nonatomic, assign) CGFloat imageWidth;

//滚动方向
@property (nonatomic, assign) ScrollDirection scrollDirection;

//是否显示标记
@property (nonatomic, assign) BOOL isShowMarkInfo;
@property (nonatomic, strong) NSArray *marksTypes;

/**
 非必须
 @[
  @{@"mark":@"",@"image":@""}
  ]
 */
@property (nonatomic, strong) NSArray *hasImages;


@end

/*eg
-(JKPhotoSelectorView *)photoSelectorView
{
    if (!_photoSelectorView) {
        JKPhotoSelectorView *photoSelectorView = [[JKPhotoSelectorView alloc] init];
        photoSelectorView.maxImageCount = 3; //图片选择的最大个数
        [self.view addSubview:photoSelectorView];
        [photoSelectorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.mas_equalTo(self.view);
            make.height.mas_equalTo(100*JK_FIT_WIDTH); //
        }];
        _photoSelectorView = photoSelectorView;
    }
    return _photoSelectorView;
}

[self photoSelectorView];
self.photoSelectorView.didSelectImages = ^(NSArray *imageArray) {
    NSLog(@"%@",imageArray);
};
 */

