//
//  JKPhotoTypeView.m
//  New_Patient
//
//  Created by Jn_Kindle on 2018/8/30.
//  Copyright © 2018年 新开元 iOS. All rights reserved.
//

#import "JKPhotoTypeView.h"

@interface JKPhotoTypeTVCell : JKBaseTabelViewCell

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *bottomLine;

@end
@implementation JKPhotoTypeTVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:14.0*JK_FIT_WIDTH];
        titleLabel.textColor = RGB_COLOR(51, 51, 51);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}
- (UILabel *)bottomLine
{
    if (!_bottomLine) {
        UILabel *bottomLine = [[UILabel alloc] init];
        bottomLine.backgroundColor = JK_DefaultLineColor;
        [self addSubview:bottomLine];
        _bottomLine = bottomLine;
    }
    return _bottomLine;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.bottomLine.mas_top);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

@end

@interface JKPhotoTypeView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIView *listView;

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) JKBaseTableView *tableView;
@property (nonatomic, weak) UIButton *cancelButton;


@end

@implementation JKPhotoTypeView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //设置背景色
        self.backgroundColor = RGBA_COLOR(255, 255, 255, 0.0);
        
        [self listView];
        
        [self titleLabel];
        [self tableView];
        [self cancelButton];
        
        //添加移除手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissPhotoTypeView)];
        //[self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

-(void)setTypes:(NSArray *)types
{
    _types = types;
    [self.tableView reloadData];
}

- (UIView *)listView
{
    if (!_listView) {
        UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, JK_SCREEN_HEIGHT, JK_SCREEN_WIDTH, 250*JK_FIT_WIDTH)];
        listView.backgroundColor = [UIColor whiteColor];
        [self addSubview:listView];
        _listView = listView;
    }
    return _listView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, JK_SCREEN_WIDTH, 48*JK_FIT_WIDTH)];
        titleLabel.text = @"请选择图片类型";
        titleLabel.font = [UIFont systemFontOfSize:14.0*JK_FIT_WIDTH];
        titleLabel.textColor = RGB_COLOR(153, 153, 153);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.listView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

-(JKBaseTableView *)tableView
{
    if (!_tableView) {
        JKBaseTableView *tableView = [JKBaseTableView groupTableView];
        tableView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), JK_SCREEN_WIDTH, self.listView.jk_height-self.titleLabel.jk_height-self.cancelButton.jk_height);
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.listView addSubview:tableView];
        //header
        [tableView registerClass:[JKBaseTVHeaderFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([JKBaseTVHeaderFooterView class])];
        _tableView = tableView;
    }
    return _tableView;
}


- (UIButton *)cancelButton{
    if (!_cancelButton) {
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, self.listView.jk_height-48*JK_FIT_WIDTH, JK_SCREEN_WIDTH, 48*JK_FIT_WIDTH);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0*JK_FIT_WIDTH];
        cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.listView addSubview:cancelButton];
        _cancelButton = cancelButton;
    }
    return _cancelButton;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48*JK_FIT_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JKBaseTVHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([JKBaseTVHeaderFooterView class])];
    view.contentView.backgroundColor = JK_ViewBackgroundColor;
    
    
    return view;
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.types.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JKPhotoTypeTVCell *cell = [JKPhotoTypeTVCell cellWithTableView:tableView Identifier:NSStringFromClass([JKPhotoTypeTVCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.types.count>0) {
        cell.titleLabel.text = self.types[indexPath.row];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.types.count>0) {
        [self dismissPhotoTypeView];
        if (_didSelectType) {
            _didSelectType(self.types[indexPath.row]);
        }
    }
    
}



- (void)cancelButtonClick
{
    [self dismissPhotoTypeView];
}

/**
 显示typeView
 */
- (void)showPhotoTypeView
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    CGRect tempRect = self.listView.frame;
    tempRect.origin.y = JK_SCREEN_HEIGHT-250*JK_FIT_WIDTH;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBA_COLOR(0, 0, 0, 0.5);
        self.listView.frame = tempRect;
    }];
}

/**
 隐藏typeView
 */
- (void)dismissPhotoTypeView
{
    CGRect tempRect = self.listView.frame;
    tempRect.origin.y = JK_SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBA_COLOR(255, 255, 255, 0.0);
        self.listView.frame = tempRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
}


@end
