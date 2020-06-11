//
//  JMPhotoDetailViewController.h
//  JMPhotoAlbum
//
//  Created by tiger fly on 2020/3/21.
//  Copyright © 2020 tiger fly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMDisplayCollectionCell : UICollectionViewCell

@property (nonatomic, strong) PHAsset *asset;

@end

/// 展示图片详情
@interface JMPhotoDetailViewController : UIViewController

/// 资源集
@property (nonatomic, strong) NSArray<PHAsset *>*assets;

@property (nonatomic, assign) NSUInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
