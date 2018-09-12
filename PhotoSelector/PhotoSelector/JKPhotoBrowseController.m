//
//  JKPhotoBrowseController.m
//  New_Patient
//
//  Created by Jn_Kindle on 2018/8/30.
//  Copyright © 2018年 新开元 iOS. All rights reserved.
//

#import "JKPhotoBrowseController.h"


@interface JKPhotoBroweCell : UICollectionViewCell
@property (nonatomic, strong) NSString *imageContent; //url 或者 图片数据
@property (nonatomic, assign) BOOL isNetWorkImage; //是否是网络图片
@end

@interface JKPhotoBroweCell ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *pictureImage;
@property (nonatomic, strong) UIScrollView *scrollerView;
@end

@implementation JKPhotoBroweCell

#pragma mark - init方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        [self setUpScorllerView];
    }
    return self;
}

- (void)setUpScorllerView{
    self.scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, JN_SCREEN_WIDTH, JN_SCREEN_HEIGHT)];
    self.scrollerView.maximumZoomScale = 3.0;
    self.scrollerView.minimumZoomScale = 1.0;
    self.scrollerView.showsVerticalScrollIndicator = NO;
    self.scrollerView.showsHorizontalScrollIndicator = NO;
    self.scrollerView.delegate = self;
    [self.contentView addSubview:self.scrollerView];
    
    
}

#pragma mark - delegate
//选择缩放View
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.pictureImage;
}

//控制缩放是在中心
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.pictureImage.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - set方法
-(void)setImageContent:(NSString *)imageContent
{
    UIImageView *tempImageView = [[UIImageView alloc]init];
    if (self.isNetWorkImage) {
        JnWeakSelf;
        [tempImageView sd_setImageWithURL:[NSURL URLWithString:imageContent] placeholderImage:[UIImage imageNamed:@"icon_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //移除上一个pictureImageView
            [weakSelf.pictureImage removeFromSuperview];
            
            weakSelf.pictureImage = [[UIImageView alloc] init];
            weakSelf.pictureImage.backgroundColor = [UIColor redColor];
            weakSelf.pictureImage.contentMode = UIViewContentModeScaleAspectFit;
            weakSelf.pictureImage.frame = [self setImageView:tempImageView];
            weakSelf.pictureImage.image = image;
            [weakSelf.scrollerView addSubview:self.pictureImage];
            
            weakSelf.scrollerView.contentSize = self.pictureImage.frame.size;
        }];
    }else {
        tempImageView.image = (UIImage *)imageContent;
        //移除上一个pictureImageView
        [self.pictureImage removeFromSuperview];
        
        self.pictureImage = [[UIImageView alloc] init];
        self.pictureImage.backgroundColor = [UIColor redColor];
        self.pictureImage.contentMode = UIViewContentModeScaleAspectFit;
        self.pictureImage.frame = [self setImageView:tempImageView];
        self.pictureImage.image = (UIImage *)imageContent;
        
        [self.scrollerView addSubview:self.pictureImage];
    }
}

//根据不同的比例设置尺寸
-(CGRect) setImageView:(UIImageView *)imageView
{
    CGFloat imageX = imageView.image.size.width;
    CGFloat imageY = imageView.image.size.height;
    CGRect imgfram;
    CGFloat CGscale;
    BOOL flx =  (JN_SCREEN_WIDTH / JN_SCREEN_HEIGHT) > (imageX / imageY);
    if(flx){
        CGscale = JN_SCREEN_HEIGHT / imageY;
        imageX = imageX * CGscale;
        imgfram = CGRectMake((JN_SCREEN_WIDTH - imageX) / 2, 0, imageX, JN_SCREEN_HEIGHT);
        return imgfram;
    }else{
        CGscale = JN_SCREEN_WIDTH / imageX;
        imageY = imageY * CGscale;
        imgfram = CGRectMake(0, (JN_SCREEN_HEIGHT - imageY) / 2, JN_SCREEN_WIDTH, imageY);
        return imgfram;
    }
}
@end



@interface JKPhotoBrowseController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *picturesCollectionView;

@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, assign) NSInteger tagIndex;
@property (nonatomic, strong) UIView *navBarView;


@end

static NSString *const pictureCellID = @"JKPhotoBroweCell";

@implementation JKPhotoBrowseController


#pragma mark - picturesCollectionView
- (UICollectionView *)picturesCollectionView{
    if (!_picturesCollectionView) {
        //初始化流布局
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
        layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layOut.itemSize = CGSizeMake(JN_SCREEN_WIDTH, JN_SCREEN_HEIGHT);
        layOut.minimumLineSpacing = CGFLOAT_MIN;
        layOut.minimumInteritemSpacing = CGFLOAT_MIN;
        
        
        _picturesCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layOut];
        _picturesCollectionView.delegate = self;
        _picturesCollectionView.dataSource = self;
        _picturesCollectionView.showsHorizontalScrollIndicator = NO;
        _picturesCollectionView.showsVerticalScrollIndicator = NO;
        _picturesCollectionView.bounces = NO; //关闭弹性
        _picturesCollectionView.scrollEnabled = NO;//关闭自身滚动
        _picturesCollectionView.backgroundColor = [GlobalFunction colorWithHexString:@"0xF3F3F3"];
        
        //注册cell
        [_picturesCollectionView registerClass:[JKPhotoBroweCell class] forCellWithReuseIdentifier:pictureCellID];
        
        //添加手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideNavBarView)];
        
        UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goNextPage)];
        [leftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
        
        UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goBeforePage)];
        [rightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
        
        [_picturesCollectionView addGestureRecognizer:tapGesture];
        [_picturesCollectionView addGestureRecognizer:leftGesture];
        [_picturesCollectionView addGestureRecognizer:rightGesture];
        
        [self.view addSubview:_picturesCollectionView];
    }
    return _picturesCollectionView;
}

- (UILabel *)indexLabel{
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
        _indexLabel.center  = CGPointMake(self.view.center.x,  JN_StatusBarH + 20);
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.font = [UIFont systemFontOfSize:16*JN_SCREEN_FIT];
        _indexLabel.textColor = [UIColor whiteColor];
        
        [self.navBarView addSubview:_indexLabel];
    }
    return _indexLabel;
}


- (UIView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JN_SCREEN_WIDTH, JN_StatusBarH + 40)];
        _navBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(12, 6+JN_StatusBarH, 32, 32);
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popCurrentVC) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:backButton];
        
        [self.view addSubview:_navBarView];
    }
    return _navBarView;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark -ViewLifeCycle

- (void)loadView
{
    [super loadView];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [GlobalFunction colorWithHexString:@"0xF3F3F3"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置初始偏移量
    self.picturesCollectionView.contentOffset = CGPointMake(JN_SCREEN_WIDTH * self.currentPosition, 0);
    self.tagIndex = self.currentPosition;
    [self navBarView];
    
    //添加计数label
    self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.tagIndex + 1,self.imagesArry.count];
    
    
}


#pragma mark - collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesArry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    JKPhotoBroweCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pictureCellID forIndexPath:indexPath];
    switch (self.imageType) {
        case 0:
            cell.isNetWorkImage = YES;
            break;
        case 1:
            cell.isNetWorkImage = NO;
            break;
        default:
            cell.isNetWorkImage = YES;
            break;
    }
    cell.imageContent = self.imagesArry[indexPath.item];
    
    
    return cell;
}



#pragma mark - Action
- (void)hideNavBarView{
    if (self.navBarView.alpha > 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.navBarView.alpha = 0;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.navBarView.alpha = 1;
        }];
    }
}

- (void)popCurrentVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goNextPage{
    if (self.tagIndex < self.imagesArry.count - 1) {
        self.tagIndex ++;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tagIndex inSection:0];
        [self.picturesCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.tagIndex + 1,self.imagesArry.count];
        
    }else{
        //[ProgressHUD showNoImage:@"已经是最后一页了"];
    }
}

- (void)goBeforePage{
    if (self.tagIndex > 0) {
        self.tagIndex --;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tagIndex inSection:0];
        [self.picturesCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.tagIndex + 1,self.imagesArry.count];
        
        
    }else{
        //[ProgressHUD showNoImage:@"已经是最后一页了"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

