//
//  JMPhotoViewCell.m
//  JMPhotoAlbum
//
//  Created by tiger fly on 2020/3/19.
//  Copyright © 2020 tiger fly. All rights reserved.
//


#import "JMPhotoViewCell.h"
#import "JMAlbumAssetManager.h"
#import "PHAsset+Extension.h"

@implementation JMPhotoViewCell {
    
    UIImageView *_imageView;
    UIButton *_selectBtn;
}

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    _imageView.backgroundColor = [UIColor colorWithRGB:0x999999];
    [self addSubview:_imageView];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _selectBtn.frame = CGRectMake(self.frame.size.width - 28, 3, 25, 25);
}

#pragma mark -- setter

- (void)setAsset:(PHAsset *)asset {
    if (!asset) {return;}
    _asset = asset;
    
    UIImage *currentImage = !_asset.selected ? [UIImage imageNamed:@"selected"] : [UIImage imageNamed:@"unselect"];
    [_selectBtn setImage:currentImage forState:UIControlStateNormal];
    
    JMAlbumAssetManager *manager = [JMAlbumAssetManager assetManager];
    [manager requestThumbnailPhotoWith:asset completion:^(UIImage * _Nonnull image) {
        _imageView.image = image;
    }];
    
}

#pragma mark -- getter

- (UIImage *)contentImage {
    return _imageView.image;
}

#pragma mark -- selector

- (void)select:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    _asset.selected = !_asset.selected;
    UIImage *currentImage = self.asset.selected ? [UIImage imageNamed:@"selected"] : [UIImage imageNamed:@"unselect"];
    [button setImage:currentImage forState:UIControlStateNormal];
}




@end
