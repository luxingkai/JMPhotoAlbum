//
//  AppDelegate.m
//  JMPhotoAlbum
//
//  Created by tiger fly on 2020/3/19.
//  Copyright © 2020 tiger fly. All rights reserved.
//

#import "AppDelegate.h"
#import "JMAlbumViewController.h"
#import "SharePhotoLibraryController.h"
#import "AssetRetrievalViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
//    JMAlbumViewController *vc = [JMAlbumViewController new];
    AssetRetrievalViewController *vc = [AssetRetrievalViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}




@end
