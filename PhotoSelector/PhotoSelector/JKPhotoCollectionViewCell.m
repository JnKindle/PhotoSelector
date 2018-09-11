//
//  JKPhotoCollectionViewCell.m
//  New_Patient
//
//  Created by Jn_Kindle on 2018/6/1.
//  Copyright © 2018年 新开元 iOS. All rights reserved.
//

#import "JKPhotoCollectionViewCell.h"

@interface JKPhotoCollectionViewCell ()

@end

@implementation JKPhotoCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc]init];
        //NeedFix UIViewContentModeScaleToFill
        _showImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:_showImageView];
    }
    return _showImageView;
}

- (UILabel *)indexLabel{
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc]init];
        _indexLabel.textColor = RGB_COLOR(153, 153, 153);
        _indexLabel.font = [UIFont systemFontOfSize:11.0 * (self.jk_height/100)];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.showImageView addSubview:_indexLabel];
    }
    return _indexLabel;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"icon_ps_delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteCurrentItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_deleteButton];
    }
    return _deleteButton;
}

- (UILabel *)markInfoLabel{
    if (!_markInfoLabel) {
        _markInfoLabel = [[UILabel alloc]init];
        _markInfoLabel.textColor = [UIColor whiteColor];
        _markInfoLabel.backgroundColor = RGBA_COLOR(2, 2, 2, 0.4);
        _markInfoLabel.font = [UIFont systemFontOfSize:11.0 * (self.jk_height/100)];
        _markInfoLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.showImageView addSubview:_markInfoLabel];
    }
    return _markInfoLabel;
}

#pragma mark - Action
- (void)deleteCurrentItem:(UIButton *)sender
{
    self.deleteItem();
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //原始比例是按照100来的
    
    //显示图片
    [self.showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).offset(self.jk_height * (10.0/100));
        make.height.width.mas_equalTo(self.jk_height * (80.0/100));
    }];
    
    //显示index
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.showImageView.mas_centerX);
        make.top.equalTo(self.showImageView.mas_top).offset(self.jk_height * (56.0/100)*JK_FIT_WIDTH);
        make.height.mas_equalTo(self.jk_height * (13.0/100));
    }];
    
    //删除按钮
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.width.height.mas_equalTo(self.jk_height * (20.0/100));
    }];
    
    [self.markInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.showImageView);
        make.height.mas_equalTo(self.jk_height * (15.0/100));
    }];
}

@end
