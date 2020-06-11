//
//  JMPhotoDetailViewController.m
//  JMPhotoAlbum
//
//  Created by tiger fly on 2020/3/21.
//  Copyright © 2020 tiger fly. All rights reserved.
//

#import "JMPhotoDetailViewController.h"
#import "JMAlbumAssetManager.h"

@interface JMDisplayCollectionCell ()

@end

@implementation JMDisplayCollectionCell {
 
    UIImageView *_contentView;
}
 
- (instancetype)initWithFrame:(CGRect)frame {
 
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
 
    _contentView = [UIImageView new];
    _contentView.contentMode = UIViewContentModeScaleAspectFit;
    _contentView.layer.masksToBounds = YES;
    [self addSubview:_contentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark --

- (void)setAsset:(PHAsset *)asset {
    
    JMAlbumAssetManager *manager = [JMAlbumAssetManager assetManager];
    [manager requestPhotoWithPHAsset:asset completion:^(UIImage * _Nonnull image) {
        _contentView.image = image;
    }];
}

@end


@interface JMPhotoDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation JMPhotoDetailViewController {
 
    UICollectionView *_collectionView;
    UIImageView *_displayView;
    
    BOOL _scroll;
}

static NSString *const reuseIdentifier = @"reuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _scroll = NO;
    [self setupSubViews];
    
    
    // Do any additional setup after loading the view.
}


- (void)setupSubViews {
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(screenWidth, screenHeight);
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[JMDisplayCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];

    //滚动到指定位置
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:true];
}


#pragma mark --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
 
    JMDisplayCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.asset = self.assets[indexPath.row];
    
    return cell;
}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
