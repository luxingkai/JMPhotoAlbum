//
//  JMAlbumAssetManager.h
//  JMPhotoAlbum
//
//  Created by tiger fly on 2020/3/19.
//  Copyright © 2020 tiger fly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "JMAssetCollection.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,JMAlbumAssetType) {
    JMAlbumTypeAsset = 0,
    JMAlbumTypeAssetCollection,
    JMAlnumTypeCollectionList
};
typedef JMAlbumAssetType JMAlbumAssetType;

typedef NS_ENUM(NSInteger,JMMediaType) {
    JMMediaTypeUnknown = 0,
    JMMediaTypeImage,
    JMMediaTypeAudio,
    JMMediaTypeVideo,
};

typedef void(^AssetGain)(NSArray<UIImage*>*assets);
typedef void(^AssetCollection)(NSArray<PHAssetCollection*>*collections);
//typedef void (^ProgressHandler)(double progress, BOOL *stop);
typedef void(^Granted)(BOOL granted);
@interface JMAlbumAssetManager : NSObject

@property (nonatomic, copy) Granted granted;

+ (instancetype)assetManager;
- (void)completionHandler:(void(^)(BOOL grant))completion;

// Fetch AssetCollection
- (void)fetchAssetCollection:(void(^)(NSArray<PHAssetCollection*>*assetCollection))completion;
- (void)fetchCollection:(void(^)(NSArray<PHCollection*>*))completion;
- (void)fetchCollectionListByCollectionType:(void(^)(NSArray<PHCollectionList *>*list))completion;

// Fetch Asset
+ (void)fetchAsset:(void(^)(NSArray<PHAsset*>*))completion;
- (void)fetchAssetWithTitle:(NSString *)title completion:(void(^)(NSArray<PHAsset*>*))completion;

// Request Photo
- (void)requestThumbnailPhotoWith:(PHAsset *)asset completion:(void(^)(UIImage *image))completion;
- (void)requestPhotoWithPHAsset:(PHAsset *)asset completion:(void(^)(UIImage *))completion;
- (PHImageRequestID)requestPhotoPHAsset:(PHAsset *)asset completion:(void(^)(UIImage *image))completion;



@end

NS_ASSUME_NONNULL_END
