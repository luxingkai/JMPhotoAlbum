//
//  JMPhotoViewCell.h
//  JMPhotoAlbum
//
//  Created by tiger fly on 2020/3/19.
//  Copyright © 2020 tiger fly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Add.h"
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMPhotoViewCell : UICollectionViewCell

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, readonly) UIImage *contentImage;

@end

NS_ASSUME_NONNULL_END
