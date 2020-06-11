//
//  PHAsset+Extension.h
//  JMPhotoAlbum
//
//  Created by tigerfly on 2020/6/10.
//  Copyright © 2020 tiger fly. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (Extension)

/*
 category:  property属性 但不会生成成员变量
            运行时处理
 extension: 编译时处理
            property属性
 */

@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
