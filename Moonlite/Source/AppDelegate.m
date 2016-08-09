//
//  AppDelegate.m
//  Moonlite
//
//  Created by Admin on 8/5/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "AppDelegate.h"
#import <MagicalRecord/MagicalRecord.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    [MagicalRecord setupCoreDataStack];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url isFileURL])
    {
        NSString *theDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        NSURL *theDestinationURL = [[NSURL fileURLWithPath:theDocumentsPath] URLByAppendingPathComponent:[url lastPathComponent]];
        
        NSError *theError = NULL;
        BOOL theResult = [[NSFileManager defaultManager] moveItemAtURL:url toURL:theDestinationURL error:&theError];
        if (theResult == YES)
        {
            NSMutableDictionary *theUserInfo = [NSMutableDictionary dictionary];
            if (theDestinationURL != NULL)
            {
                theUserInfo[@"URL"] = theDestinationURL;
            }
            if (sourceApplication != NULL)
            {
                theUserInfo[@"sourceApplication"] = sourceApplication;
            }
            if (annotation != NULL)
            {
                theUserInfo[@"annotation"] = annotation;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidOpenURL" object:application userInfo:theUserInfo];
        }
        
        return(theResult);
    }
    return(NO);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
