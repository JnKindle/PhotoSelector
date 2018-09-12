//
//  ViewController.m
//  PhotoSelector
//
//  Created by Jn_Kindle on 2018/9/11.
//  Copyright © 2018年 JnKindle. All rights reserved.
//

#import "ViewController.h"

#import "JKPhotoSelectorView.h"

@interface ViewController ()

@property (nonatomic, weak) JKPhotoSelectorView *photoSelectorView;

@end

@implementation ViewController


-(JKPhotoSelectorView *)photoSelectorView
{
    if (!_photoSelectorView) {
        JKPhotoSelectorView *photoSelectorView = [[JKPhotoSelectorView alloc] init];
        photoSelectorView.maxImageCount = 5; //图片选择的最大个数
        photoSelectorView.scrollDirection = PSScrollVertical;
        photoSelectorView.imageWidth = 80*JN_SCREEN_FIT;
        [self.view addSubview:photoSelectorView];
        [photoSelectorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(100);
            make.right.left.mas_equalTo(self.view);
            make.height.mas_equalTo((80+10)*JN_SCREEN_FIT);
        }];
        _photoSelectorView = photoSelectorView;
    }
    return _photoSelectorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self photoSelectorView];
    self.photoSelectorView.didSelectImages = ^(NSArray *imageArray, CGFloat photoSelectorViewHeight) {
        [self.photoSelectorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(100);
            make.right.left.mas_equalTo(self.view);
            make.height.mas_equalTo(photoSelectorViewHeight+10*JN_SCREEN_FIT);
        }];
        
        
        
    };
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
