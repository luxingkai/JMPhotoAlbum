//
//  SharePhotoLibraryController.m
//  JMPhotoAlbum
//
//  Created by tigerfly on 2020/6/10.
//  Copyright © 2020 tiger fly. All rights reserved.
//

#import "SharePhotoLibraryController.h"
#import <Photos/Photos.h>

@interface SharePhotoLibraryController ()<PHPhotoLibraryChangeObserver>

@end

@implementation SharePhotoLibraryController {
    
    PHPhotoLibrary *_photoLibrary;
}

- (void)dealloc {
    [_photoLibrary unregisterChangeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Update Your App's Info.plist File
    //NSPhotoLibraryUsageDescription
    //NSPhotoLibraryAddUsageDescription
    
    //Observe Changes Before Fetching
    // registerChangeObserver:
    
    
#pragma mark -- PHPhotoLibrary (manages access and changes to the user’s shared photo library.)
    
    //Vertifying Authorization
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status != PHAuthorizationStatusAuthorized) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusNotDetermined: {
                    NSLog(@"User has not yet made a choice with regards to this application");
                }
                    break;
                case PHAuthorizationStatusRestricted: {
                    NSLog(@"This application is not authorized to access photo data.");
                    
                }
                    break;
                case PHAuthorizationStatusDenied: {
                    NSLog(@" User has explicitly denied this application access to photos data");
                    
                }
                    break;
                case PHAuthorizationStatusAuthorized: {
                    NSLog(@"User has authorized this application to access photos data.");
                }
                    break;
            }
        }];
    }else {
        //授权访问
    }
    
    
#pragma mark -- Getting the Shared Photo Library Object
    _photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
    
    
#pragma mark -- Applying Changes to the Photo Library (Creating items、Deleting items、 Modifying items)
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
    }];
    
//    NSError *error = nil;
//    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
//        //此方法同步执行,需要在后台队列中执行
//    } error:&error];
    
    //A request to create, delete, change metadata for, or edit the content of a Photos asset, for use in a photo library change block.
//    PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:[UIImage imageNamed:@""]];
//    PHAssetChangeRequest deleteAssets:
//    PHAssetChangeRequest changeRequestForAsset:
    
    // A request to create, delete, or modify a Photos asset collection, for use in a photo library change block.
//    PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:<#(nonnull NSString *)#>
//    PHAssetCollectionChangeRequest deleteAssetCollections:<#(nonnull id<NSFastEnumeration>)#>
//    PHAssetCollectionChangeRequest changeRequestForAssetCollection:<#(nonnull PHAssetCollection *)#>
//    PHAssetCollectionChangeRequest changeRequestForAssetCollection:<#(nonnull PHAssetCollection *)#> assets:<#(nonnull PHFetchResult<PHAsset *> *)#>
        
    //A request to create, delete, or modify a Photos collection list, for use in a photo library change block.
//    PHCollectionListChangeRequest creationRequestForCollectionListWithTitle:<#(nonnull NSString *)#>
//    PHCollectionListChangeRequest deleteCollectionLists:<#(nonnull id<NSFastEnumeration>)#>
//    PHCollectionListChangeRequest changeRequestForCollectionList:<#(nonnull PHCollectionList *)#>
//    PHCollectionListChangeRequest changeRequestForCollectionList:<#(nonnull PHCollectionList *)#> childCollections:<#(nonnull PHFetchResult<__kindof PHCollection *> *)#>
    
    
#pragma mark -- Observing Changes to the Photo Library
    
    [_photoLibrary registerChangeObserver:self];
    
    //A description of a change that occurred in the photo library.
    //PHChange
    //PHObjectChangeDetails
    //PHFetchResultChangeDetails
    
    
    
    // Do any additional setup after loading the view.
}

- (void)addNewAssetWithImage:(UIImage *)image toAlbum:(PHAssetCollection *)album {
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //Request creating an asset from the image.
        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //Request editing the album.
        PHAssetCollectionChangeRequest* albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
        // Get a placeholder for the new asset and add it to the album editing request.
        PHObjectPlaceholder* assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];
        [albumChangeRequest addAssets:@[ assetPlaceholder ]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"Finished adding asset. %@", (success ? @"Success" : error));
    }];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
//    // Photos may call this method on a background queue;
//       // switch to the main queue to update the UI.
//       dispatch_async(dispatch_get_main_queue(), ^{
//           // Check for changes to the displayed album itself
//           // (its existence and metadata, not its member assets).
//           PHObjectChangeDetails *albumChanges = [changeInfo changeDetailsForObject:self.displayedAlbum];
//           if (albumChanges) {
//               // Fetch the new album and update the UI accordingly.
//               self.displayedAlbum = [albumChanges objectAfterChanges];
//               self.navigationController.navigationItem.title = self.displayedAlbum.localizedTitle;
//           }
//
//           // Check for changes to the list of assets (insertions, deletions, moves, or updates).
//           PHFetchResultChangeDetails *collectionChanges = [changeInfo changeDetailsForFetchResult:self.albumContents];
//           if (collectionChanges) {
//                // Get the new fetch result for future change tracking.
//               self.albumContents = collectionChanges.fetchResultAfterChanges;
//
//               if (collectionChanges.hasIncrementalChanges)  {
//                   // Tell the collection view to animate insertions/deletions/moves
//                   // and to refresh any cells that have changed content.
//                   [self.collectionView performBatchUpdates:^{
//                       NSIndexSet *removed = collectionChanges.removedIndexes;
//                       if (removed.count) {
//                           [self.collectionView deleteItemsAtIndexPaths:[self indexPathsFromIndexSet:removed]];
//                       }
//                       NSIndexSet *inserted = collectionChanges.insertedIndexes;
//                       if (inserted.count) {
//                           [self.collectionView insertItemsAtIndexPaths:[self indexPathsFromIndexSet:inserted]];
//                       }
//                       NSIndexSet *changed = collectionChanges.changedIndexes;
//                       if (changed.count) {
//                           [self.collectionView reloadItemsAtIndexPaths:[self indexPathsFromIndexSet:changed]];
//                       }
//                       if (collectionChanges.hasMoves) {
//                           [collectionChanges enumerateMovesWithBlock:^(NSUInteger fromIndex, NSUInteger toIndex) {
//                               NSIndexPath *fromIndexPath = [NSIndexPath indexPathForItem:fromIndex inSection:0];
//                               NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:toIndex inSection:0];
//                               [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
//                           }];
//                       }
//                   } completion:nil];
//               } else {
//                   // Detailed change information is not available;
//                   // repopulate the UI from the current fetch result.
//                   [self.collectionView reloadData];
//               }
//           }
//       });
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
