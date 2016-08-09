//
//  MGNetworkManager.m
//  Blinkr
//
//  Created by Admin on 7/25/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGNetworkManager.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Book.h"

static NSString *mainURL = @"http://159.203.25.173";

@implementation MGNetworkManager
#pragma mark - Manager methods

+ (AFHTTPSessionManager *)manager {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:mainURL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    return manager;
}

#pragma mark - Books

+ (void) getAllBooksWithCompletion:(ArrayCompletionBlock)completionBlock {
    
    [[MGNetworkManager manager] GET:@"books" parameters:nil progress:nil
     
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completionBlock) {
            
            NSMutableArray *responseArray = [NSMutableArray array];
            
            for (NSDictionary *lBookDict in responseObject) {
                
                [responseArray addObject:[Book initWithDict:lBookDict]];
            }
            
            completionBlock(responseArray, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completionBlock(nil, error);
        
    }];
    
}





@end
