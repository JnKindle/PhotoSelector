//
//  JKPhotoSelectorView.m
//  New_Patient
//
//  Created by Jn_Kindle on 2018/6/1.
//  Copyright © 2018年 新开元 iOS. All rights reserved.
//

#define JKMaxImageCount 3
#define JKImageWidth 90*JK_FIT_WIDTH
#define JKFitFrame(x) self.jk_height * (x/100)  //原始比例是100

#import "JKPhotoSelectorView.h"

#import "JKPhotoBrowseController.h"

//相机
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
//相册
#import <AssetsLibrary/AssetsLibrary.h>

//view
#import "JKPhotoCollectionViewCell.h"
#import "JKPhotoTypeView.h"

@interface JKPhotoSelectorView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) JKBaseCollectView *collectionView;

/**存放选择图片
 @[
 @{@"mark":@"",@"image":@""}
 ]
 */
@property (nonatomic, strong) NSMutableArray *imageArray;
//记录当前点击的添加图片位置
@property (nonatomic, assign) NSInteger currentClickPosition;

@property (nonatomic, strong) JKPhotoTypeView *typeView;
@property (nonatomic, copy) NSString *currentType;

@end

@implementation JKPhotoSelectorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.maxImageCount = self.maxImageCount == 0 ? JKMaxImageCount : self.maxImageCount;
        self.imageWidth = self.imageWidth == 0.0 ? JKImageWidth : self.imageWidth;
    }
    return self;
}

-(void)setHasImages:(NSArray *)hasImages
{
    _hasImages = hasImages;
    [self.imageArray removeAllObjects];
    if (hasImages.count != 0) {
        for (int i=0; i<hasImages.count; i++) {
            [self.imageArray addObject:hasImages[i]];
        }
    }
    [self.collectionView reloadData];
}

- (JKPhotoTypeView *)typeView
{
    if (!_typeView) {
        _typeView = [[JKPhotoTypeView alloc] initWithFrame:CGRectMake(0, 0, JK_SCREEN_WIDTH, JK_SCREEN_HEIGHT)];
        _typeView.title = @"请选择图片类型";
        _typeView.types = self.marksTypes;
    }
    return _typeView;
}




-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = [self caculateCollectionHeight];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(height);
    }];
    
}

- (CGFloat)caculateCollectionHeight
{
    int row = 1;
    int tag = 0;
    NSInteger imageCount = self.imageArray.count<5?self.imageArray.count+1:self.imageArray.count;
    CGFloat rowWidth = 24*JK_FIT_WIDTH;
    for (int i=0; i<imageCount; i++) {
        CGFloat width = self.imageWidth;
        rowWidth = rowWidth + width;
        if ((rowWidth + (i-tag)*5*JK_FIT_WIDTH)  >= self.jk_width) {
            rowWidth = 40.0*JK_FIT_WIDTH + width;
            row++;
            tag = i+1;
        }
    }
    CGFloat itemHeight = self.imageWidth;
    CGFloat height = (row-1)*5*JK_FIT_WIDTH + row*itemHeight;
    return height;
}

-(void)setMaxImageCount:(NSInteger)maxImageCount
{
    _maxImageCount = maxImageCount;
    [self.collectionView reloadData];
}


#pragma mark - init
-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        
    }
    return _imageArray;
}

-(JKBaseCollectView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        //距离边缘的空隙
        layout.sectionInset = UIEdgeInsetsMake(0, 12.0*JK_FIT_WIDTH, 0, 12.0*JK_FIT_WIDTH);
        //两个item水平的最小空隙(默认10)
        layout.minimumInteritemSpacing = 5.0*JK_FIT_WIDTH;
        //两个item垂直方向的最小空隙(默认10)
        layout.minimumLineSpacing = 5.0*JK_FIT_WIDTH;
        //滚动方向
        switch (self.scrollDirection) {
            case PSScrollHorizontal:
                layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                break;
            case PSScrollVertical:
                layout.scrollDirection = UICollectionViewScrollDirectionVertical;
                break;
            default:
                layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                break;
        }
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        JKBaseCollectView *collectionView = [[JKBaseCollectView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        //_collectionView.bounces = NO;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.pagingEnabled = NO;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        
        [collectionView registerClass:[JKPhotoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JKPhotoCollectionViewCell class])];
        //注册段头视图
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
        //注册段尾视图
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
        
        [self addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}



#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageArray.count < self.maxImageCount){
        return self.imageArray.count + 1; //显示添加cell
    }else{
        return self.imageArray.count;//imageArray允许存储最大图片数量为 JKMaxImageCount
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size={self.imageWidth, self.imageWidth};
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JKPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JKPhotoCollectionViewCell class]) forIndexPath:indexPath];
    
    if (self.imageArray.count == self.maxImageCount) { //最大图片数量
        cell.showImageView.image = [self.imageArray[indexPath.item] objectForKey:@"image"];
        cell.markInfoLabel.text = [self.imageArray[indexPath.item] objectForKey:@"mark"];
        cell.deleteButton.hidden = NO;
        cell.indexLabel.hidden = YES;
        cell.markInfoLabel.hidden = NO;
    }else{
        if (indexPath.item == self.imageArray.count) {
            //最后一个cell为添加cell
            cell.showImageView.image = [UIImage imageNamed:@"icon_ps_bg"];
            cell.markInfoLabel.text = @"";
            cell.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.item,(long)self.maxImageCount];
            if (self.imageArray.count == 0) {
                cell.indexLabel.text = @"添加图片";
            }
            cell.indexLabel.hidden = NO;
            cell.deleteButton.hidden = YES;
            cell.markInfoLabel.hidden = YES;
        }else{
            cell.showImageView.image = [self.imageArray[indexPath.item] objectForKey:@"image"];
            cell.markInfoLabel.text = [self.imageArray[indexPath.item] objectForKey:@"mark"];
            cell.deleteButton.hidden = NO;
            cell.indexLabel.hidden = YES;
            cell.markInfoLabel.hidden = NO;
        }
    }
    
    if (!self.isShowMarkInfo) {
        cell.markInfoLabel.hidden = NO;
    }
    
    //删除回调方法
    
    JKWeakSelf;
    cell.deleteItem = ^{
        [weakSelf.imageArray removeObjectAtIndex:indexPath.item];
        [weakSelf.collectionView reloadData];
        [weakSelf layoutSubviews];
        if (self.didSelectImages) {
            self.didSelectImages([self.imageArray copy],[self caculateCollectionHeight]);
        }
    };
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imageArray.count != self.maxImageCount && indexPath.item == self.imageArray.count) {
        //点击的视图为上传图片的视图
        if (self.isShowMarkInfo) {
            //如果要显示标记，则先选择类型
            [self.typeView showPhotoTypeView];
            JKWeakSelf;
            self.typeView.didSelectType = ^(NSString *type) {
                weakSelf.currentType = type;
                [weakSelf showAlertActionControllerWithClickPositon:indexPath.row];
            };
            return;
        }
        [self showAlertActionControllerWithClickPositon:indexPath.row];
        
        
    }else {
        //点击的视图为图片
        
        ImageType imageType = NetWorkImage;
        Class myclass = [[self.imageArray[0] objectForKey:@"image"] class];
        if ([myclass class] == NSClassFromString(@"UIImage")) {
            imageType = LocateImage;
        }
        
        JKPhotoBrowseController *browseController = [[JKPhotoBrowseController alloc]init];
        browseController.imageType = imageType;
        browseController.imagesArry = [self.imageArray copy];
        browseController.currentPosition = indexPath.row;
        [JKAPPCurrentController.navigationController pushViewController:browseController animated:YES];
    }
    
}


#pragma mark - Action
- (void)showAlertActionControllerWithClickPositon:(NSInteger)position
{
    self.currentClickPosition = position;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takeFormCamera = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self askIfUserHasImpowerUseCamera];
    }];
    
    UIAlertAction *takeFromAlbum = [UIAlertAction actionWithTitle:@"从手机相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self askIfUserHasImpowerUseAlbum];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:takeFormCamera];
    [alert addAction:takeFromAlbum];
    [alert addAction:cancel];
    
    [JKAPPCurrentController presentViewController:alert animated:YES completion:nil];
}



#pragma mark -判断用户是否授权使用相册／相机并获取图片数据
- (void)askIfUserHasImpowerUseCamera
{
    //相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。
        
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        // 无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            NSUInteger sourcetype = UIImagePickerControllerSourceTypeCamera;
            [self gotoPresentImageControllerWithSourceType:sourcetype];//前往相机选择页
        }
        else
        {
            NSLog(@"手机不支持相机");
        }
    }
}

- (void)askIfUserHasImpowerUseAlbum{
    //相册权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author ==ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        //无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self gotoPresentImageControllerWithSourceType:sourceType];//前往相册选择页
            
        }
        else
        {
            NSLog(@"手机不支持相册");
        }
    }
    
}

- (void)gotoPresentImageControllerWithSourceType:(NSUInteger)sourceType{
    
    UIImagePickerController *imageController = [[UIImagePickerController alloc]init];
    imageController.delegate = self;
    imageController.allowsEditing = YES;
    imageController.sourceType = sourceType;
    [JKAPPCurrentController presentViewController:imageController animated:YES completion:nil];
}

//相册选择完成回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    JKLog(@"===>>%@",image);
    //根据获取的图片，填充数据模型，并刷新界面
    if (_currentClickPosition == self.imageArray.count && self.imageArray.count<self.maxImageCount) {
        //当前点击的为最后一个item
        [self.imageArray addObject:@{@"mark":self.currentType,@"image":image}];
    }else{
        [self.imageArray replaceObjectAtIndex:_currentClickPosition withObject:@{@"mark":self.currentType,@"image":image}];
    }
    [self.collectionView reloadData];
    
    
    //更新UI
    [self layoutSubviews];
    //将图片数组进行回调
    if (self.didSelectImages) {
        self.didSelectImages([self.imageArray copy],[self caculateCollectionHeight] );
    }
    
}

@end
