//
//  AssetRetrievalViewController.m
//  JMPhotoAlbum
//
//  Created by tigerfly on 2020/6/10.
//  Copyright © 2020 tiger fly. All rights reserved.
//

#import "AssetRetrievalViewController.h"
#import <Photos/Photos.h>

@interface AssetRetrievalViewController ()

@end

@implementation AssetRetrievalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusNotDetermined: {
                    //User has not yet made a choice with regards to this application
                }
                    break;
                case PHAuthorizationStatusDenied: {
                    // User has explicitly denied this application access to photos data.
                }
                    break;
                case PHAuthorizationStatusRestricted: {
                    //This application is not authorized to access photo data.
                }
                    break;
                case PHAuthorizationStatusAuthorized: {
                    //User has authorized this application to access photos data.
                    [self fetchAssetList];
                }
                    break;
            }
        }];
    }else {
        [self fetchAssetList];
    }
    
    
    
    // Do any additional setup after loading the view.
}

- (void)fetchAssetList {
    
#pragma mark -- PHAsset (A representation of an image, video, or Live Photo in the Photos library.)
    //You fetch assets to begin working with them.
    //Assets contain only metadata.
    //Asset objects are immutable.
    
    //fetching Assets
//    PHAsset fetchAssetsInAssetCollection:<#(nonnull PHAssetCollection *)#> options:<#(nullable PHFetchOptions *)#>
//    PHAsset fetchAssetsWithLocalIdentifiers:<#(nonnull NSArray<NSString *> *)#> options:<#(nullable PHFetchOptions *)#>
//    PHAsset fetchKeyAssetsInAssetCollection:<#(nonnull PHAssetCollection *)#> options:<#(nullable PHFetchOptions *)#>
//    PHAsset fetchAssetsWithOptions:<#(nullable PHFetchOptions *)#>
//    PHAsset fetchAssetsWithBurstIdentifier:<#(nonnull NSString *)#> options:<#(nullable PHFetchOptions *)#>
    
    
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    //    fetchOptions.predicate
    //    fetchOptions.sortDescriptors
    fetchOptions.wantsIncrementalChangeDetails = YES;
    fetchOptions.fetchLimit = 100;
    fetchOptions.includeHiddenAssets = NO;
    fetchOptions.includeAllBurstAssets = NO;
    fetchOptions.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    }];
    
    //Reading Asset Metadata
    PHAsset *asset = fetchResult.firstObject;
    NSLog(@"mediaType %ld",(long)asset.mediaType);
    NSLog(@"mediaSubtypes %ld",(long)asset.mediaSubtypes);
    NSLog(@"sourceType %ld",(long)asset.sourceType);
    NSLog(@"pixelWidth %ld",(long)asset.pixelWidth);
    NSLog(@"pixelHeight %ld",(long)asset.pixelHeight);
    NSLog(@"creationDate %@",asset.creationDate);
    NSLog(@"modificationDate %@",asset.modificationDate);
    NSLog(@"location %@",asset.location);
    NSLog(@"duration %f",asset.duration);
    NSLog(@"favorite %d",asset.favorite);
    NSLog(@"hidden %d",asset.hidden);
    
    //Displaying an Asset
    NSLog(@"playbackStyle %ld",(long)asset.playbackStyle);
    
    //Editing an Asset
    if ([asset canPerformEditOperation:PHAssetEditOperationDelete]) {
        PHContentEditingInputRequestOptions *editingInputRequestOptions = [PHContentEditingInputRequestOptions new];
        [asset requestContentEditingInputWithOptions:editingInputRequestOptions completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
            
            NSLog(@"mediaType %ld",(long)contentEditingInput.mediaType);
            NSLog(@"mediaSubtypes %lu",(unsigned long)contentEditingInput.mediaSubtypes);
            NSLog(@"creationDate %@",contentEditingInput.creationDate);
            NSLog(@"location %@",contentEditingInput.location);
            NSLog(@"uniformTypeIdentifier %@",contentEditingInput.uniformTypeIdentifier);
            
            NSLog(@"adjustmentData %@",contentEditingInput.adjustmentData);
            
            NSLog(@"displaySizeImage %@",contentEditingInput.displaySizeImage);
            NSLog(@"fullSizeImageOrientation %d",contentEditingInput.fullSizeImageOrientation);
            NSLog(@"fullSizeImageURL %@",contentEditingInput.fullSizeImageURL);

            NSLog(@"audiovisualAsset %@",contentEditingInput.audiovisualAsset);
            NSLog(@"avAsset %@",contentEditingInput.avAsset);

            NSLog(@"livePhoto %@",contentEditingInput.livePhoto);
            NSLog(@"playbackStyle %d",contentEditingInput.playbackStyle);
            
            PHContentEditingOutput *editingOutput = [[PHContentEditingOutput alloc] initWithContentEditingInput:contentEditingInput];
        }];
    }
    
    //Working with Burst Photo Assets
    NSLog(@"burstIdentifier %@",asset.burstIdentifier);
    NSLog(@"burstIdentifier %lu",(unsigned long)asset.burstSelectionTypes);
    NSLog(@"burstIdentifier %d",asset.representsBurst);


#pragma mark -- PHAssetCollection (A representation of a Photos asset grouping, such as a moment, user-created album, or smart album.)
    
    //Fetching Asset Collections
//    PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:<#(nonnull NSArray<NSString *> *)#> options:<#(nullable PHFetchOptions *)#>
//    PHAssetCollection fetchAssetCollectionsContainingAsset:<#(nonnull PHAsset *)#> withType:<#(PHAssetCollectionType)#> options:<#(nullable PHFetchOptions *)#>
//    PHAssetCollection fetchAssetCollectionsWithALAssetGroupURLs:<#(nonnull NSArray<NSURL *> *)#> options:<#(nullable PHFetchOptions *)#>
    PHFetchResult *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchOptions];
    PHAssetCollection *assetCollection = assetCollections.firstObject;
    
    //Reading Asset Collection Metadata
    NSLog(@"assetCollectionType %d",assetCollection.assetCollectionType);
    NSLog(@"assetCollectionSubtype %d",assetCollection.assetCollectionSubtype);
    NSLog(@"assetCollectionSubtype %d",assetCollection.estimatedAssetCount);
    NSLog(@"assetCollectionSubtype %@",assetCollection.startDate);
    NSLog(@"assetCollectionSubtype %@",assetCollection.endDate);
    NSLog(@"assetCollectionSubtype %@",assetCollection.approximateLocation);
    NSLog(@"assetCollectionSubtype %@",assetCollection.localizedLocationNames);

    //Creating Temporary Asset Collections
//    PHAssetCollection transientAssetCollectionWithAssets:<#(nonnull NSArray<PHAsset *> *)#> title:<#(nullable NSString *)#>
//    PHAssetCollection transientAssetCollectionWithAssetFetchResult:<#(nonnull PHFetchResult<PHAsset *> *)#> title:<#(nullable NSString *)#>
    
     
#pragma mark -- PHCollectionList (A group containing Photos asset collections, such as Moments, Years, or folders of user-created albums.)
    
    //Fetching Collection Lists
//    PHCollectionList fetchCollectionListsContainingCollection:<#(nonnull PHCollection *)#> options:<#(nullable PHFetchOptions *)#>
//    PHCollectionList fetchCollectionListsWithLocalIdentifiers:<#(nonnull NSArray<NSString *> *)#> options:<#(nullable PHFetchOptions *)#>
    PHFetchResult *collectionLists = [PHCollectionList fetchCollectionListsWithType:PHCollectionListTypeFolder subtype:PHCollectionListSubtypeRegularFolder options:fetchOptions];
    PHCollectionList *collectionList = collectionLists.firstObject;
    
    //Reading Collection List Metadata
    NSLog(@"collectionListType %d",collectionList.collectionListType);
    NSLog(@"collectionListSubtype %d",collectionList.collectionListSubtype);
    NSLog(@"startDate %@",collectionList.startDate);
    NSLog(@"endDate %@",collectionList.endDate);
    NSLog(@"localizedLocationNames %@",collectionList.localizedLocationNames);

    //Creating Temporary Collection Lists
//    PHCollectionList transientCollectionListWithCollections:<#(nonnull NSArray<PHCollection *> *)#> title:<#(nullable NSString *)#>
//    PHCollectionList transientCollectionListWithCollectionsFetchResult:<#(nonnull PHFetchResult<PHCollection *> *)#> title:<#(nullable NSString *)#>
    
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
