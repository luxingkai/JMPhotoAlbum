//
//  JMAssetCollection.h
//  JMPhotoAlbum
//
//  Created by tiger fly on 2020/3/20.
//  Copyright © 2020 tiger fly. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 相册
@interface JMAssetCollection : NSObject
//相册名称
@property (nonatomic, strong) NSString *title;
//相册内的图片数量
@property (nonatomic, assign) NSUInteger imageCount;


@end

NS_ASSUME_NONNULL_END
