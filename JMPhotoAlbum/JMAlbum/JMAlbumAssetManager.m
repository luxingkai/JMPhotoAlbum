//
//  JMAlbumAssetManager.m
//  JMPhotoAlbum
//
//  Created by tiger fly on 2020/3/19.
//  Copyright © 2020 tiger fly. All rights reserved.
//

#import "JMAlbumAssetManager.h"
#import "JMAlbumAssetChange.h"
#import "PHAsset+Extension.h"

@interface JMAlbumAssetManager ()

@end

@implementation JMAlbumAssetManager {
    
    PHPhotoLibrary *_photoLibrary;
    JMAlbumAssetChange *_albumChange;
    
    PHFetchOptions *_fetchOptions;
    PHImageRequestOptions *_requestOptions;
    
    //用户图库存在的全部图片数量
    NSUInteger _photoCount;
}

- (void)dealloc {
    
    [_photoLibrary unregisterChangeObserver:_albumChange];
}

+ (instancetype)assetManager {
    
    static JMAlbumAssetManager *assetManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assetManager = [[JMAlbumAssetManager alloc] init];
    });
    return assetManager;
}

- (instancetype)init {
    if (self = [super init]) {
        
        _albumChange = [[JMAlbumAssetChange alloc] init];
        _photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
        
        //注册相册相关修改的观察者
        [_photoLibrary registerChangeObserver:_albumChange];
    }
    return self;
}

#pragma mark -- 通过回调方法根据用户是否有权限访问相册来获取资源

- (void)completionHandler:(void (^)(BOOL grant))completion {
    
    __block BOOL grant = NO;
    //请求授权
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusNotDetermined: {
                    //User has not yet made a choice with regards to this application
                    NSLog(@"User has not yet made a choice with regards to this application");
                    grant = NO;
                }
                    break;
                case PHAuthorizationStatusRestricted: {
                    //This application is not authorized to access photo data
                    //The user cannot change this application’s status, possibly due to active restrictions
                    NSLog(@"This application is not authorized to access photo data");
                    grant = NO;
                }
                    break;
                case PHAuthorizationStatusDenied: {
                    //User has explicitly denied this application access to photos data
                    NSLog(@"User has explicitly denied this application access to photos data");
                    grant = NO;
                }
                    break;
                case PHAuthorizationStatusAuthorized: {
                    //User has authorized this application to access photos data.
                    NSLog(@"User has authorized this application to access photos data.");
                    grant = YES;
                }
                    break;
            }
            
            //主线程处理数据
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(grant);
            });
        }];
    }else {
        grant = YES;
        completion(grant);
    }
}

#pragma mark -- Collection

- (void)fetchAssetCollection:(void(^)(NSArray<PHAssetCollection*>*))completion {
    
    NSMutableArray *assetCollections = [NSMutableArray array];
    
    PHFetchOptions *assetCollectionFetchOptions = [[PHFetchOptions alloc] init];
    assetCollectionFetchOptions.fetchLimit = 0;
    assetCollectionFetchOptions.includeAllBurstAssets = NO;
    assetCollectionFetchOptions.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    assetCollectionFetchOptions.wantsIncrementalChangeDetails = YES;
    
    PHFetchResult *assetCollectionFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:assetCollectionFetchOptions];
    //图片相册
    [assetCollectionFetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)obj;
        [assetCollections addObject:assetCollection];
    }];
    if (completion) {
        completion(assetCollections);
    }
}

- (void)fetchCollection:(void(^)(NSArray<PHCollection*>*))completion {
    
    //相册集
    NSMutableArray *collectionLists = [NSMutableArray array];
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.fetchLimit = 0;
    
    PHFetchResult *fetchResult = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHCollection *collection = (PHCollection *)obj;
        [collectionLists addObject:collection];
    }];
    if (completion) {
        completion(collectionLists);
    }
}

- (void)fetchCollectionListByCollectionType:(void(^)(NSArray<PHCollectionList *>*list))completion {
    
    NSMutableArray *collectionLists = [NSMutableArray array];
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.fetchLimit = 0;
    fetchOptions.includeAllBurstAssets = NO;
    fetchOptions.includeHiddenAssets = NO;
    fetchOptions.wantsIncrementalChangeDetails = YES;
    
    PHFetchResult *fetchResult = [PHCollectionList fetchCollectionListsWithType:PHCollectionListTypeFolder subtype:PHCollectionListSubtypeAny options:fetchOptions];
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHCollectionList *collectionList = (PHCollectionList *)obj;
        [collectionLists addObject:collectionList];
    }];
    if (completion) {
        completion(collectionLists);
    }
}

#pragma mark -- Assets

+ (void)fetchAsset:(void (^)(NSArray<PHAsset *> * _Nonnull))completion {
    
    NSMutableArray *assets = [NSMutableArray array];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    fetchOptions.fetchLimit = 0;
    fetchOptions.includeHiddenAssets = NO;
    fetchOptions.includeAllBurstAssets = NO;
    fetchOptions.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        asset.selected = false;
        [assets addObject:asset];
    }];
    if (completion) {
        completion(assets);
    }
}

- (void)fetchAssetWithTitle:(NSString *)title completion:(void(^)(NSArray<PHAsset*>*))completion {
    NSMutableArray *assets = [NSMutableArray array];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.fetchLimit = 0;
    fetchOptions.wantsIncrementalChangeDetails = YES;
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        [assets addObject:asset];
    }];
    if (completion) {
        completion(assets);
    }
}

#pragma mark -- Photos

- (void)requestThumbnailPhotoWith:(PHAsset *)asset completion:(void(^)(UIImage *image))completion {
    
    if (!asset) { return;}
    
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.normalizedCropRect = CGRectZero;
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset targetSize:CGSizeMake(160, 160) contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        if (completion) {
            completion(result);
        }
    }];
}

- (void)requestPhotoWithPHAsset:(PHAsset *)asset completion:(void(^)(UIImage *))completion {
    
    if (!asset) { return;}
    
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        if (completion) {
            completion(result);
        }
    }];
}

- (PHImageRequestID)requestPhotoPHAsset:(PHAsset *)asset completion:(void(^)(UIImage *image))completion {
    
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = NO;
    requestOptions.progressHandler = ^(double progress, NSError *__nullable error, BOOL *stop, NSDictionary *__nullable info) {
        NSLog(@"%f",progress);
    };
    PHImageManager *imageManager = [PHImageManager defaultManager];
    PHImageRequestID requestID = [imageManager requestImageDataAndOrientationForAsset:asset options:requestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
        if (completion) {
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            completion(image);
        }
    }];
    return requestID;
}



@end
