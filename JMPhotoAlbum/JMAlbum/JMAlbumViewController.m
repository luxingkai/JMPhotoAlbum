//
//  JMAlbumViewController.m
//  JMPhotoAlbum
//
//  Created by tiger fly on 2020/3/19.
//  Copyright © 2020 tiger fly. All rights reserved.
//

#import "JMAlbumViewController.h"
#import "JMPhotoViewCell.h"
#import "JMAlbumAssetManager.h"
#import "JMPhotoDetailViewController.h"

@interface JMAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation JMAlbumViewController{
    
    NSArray *_datasource;
    UICollectionView *_collectionView;
    
    NSUInteger _currentSelectCount;//当前选中数
}

static NSString *const cellIdentifier = @"cellIdentifier";

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat itemSize = ([UIScreen mainScreen].bounds.size.width - 28.0) / 4.0;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(itemSize, itemSize);
    flowLayout.minimumLineSpacing = 4;
    flowLayout.minimumInteritemSpacing = 4;
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[JMPhotoViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    //本地资源获取
    [[JMAlbumAssetManager assetManager] completionHandler:^(BOOL grant) {
        if (grant) {
            [JMAlbumAssetManager fetchAsset:^(NSArray<PHAsset *> * _Nonnull assets) {
                _datasource = assets;
                [_collectionView reloadData];
            }];
        }
    }];
  
    
    // Do any additional setup after loading the view.
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JMPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.asset = _datasource[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        
    JMPhotoDetailViewController *vc = [JMPhotoDetailViewController new];
    vc.assets = _datasource;
    vc.currentIndex = indexPath.row;
    [self.navigationController pushViewController:vc animated:true];
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
