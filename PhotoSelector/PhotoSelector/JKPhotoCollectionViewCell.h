//
//  JKPhotoCollectionViewCell.h
//  New_Patient
//
//  Created by Jn_Kindle on 2018/6/1.
//  Copyright © 2018年 新开元 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JKPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *showImageView;

@property (nonatomic, strong) UILabel *indexLabel;

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, copy) void(^deleteItem)(void);

@property (nonatomic, strong) UILabel *markInfoLabel;

@end
