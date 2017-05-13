//
//  TooSoonAPIClien.m
//  Is it too soon
//
//  Created by Michael Macari on 6/9/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import "TooSoonAPIClien.h"


@implementation TooSoonAPIClien

        //Method processes information from the server when called
+ (AFHTTPRequestOperationManager *) configureRequestManagerWithHeaders:(NSMutableDictionary*)headers {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    for (NSString* header in headers) {
        NSString *value = [headers objectForKey:header];
        [manager.requestSerializer setValue:value forHTTPHeaderField:header];
    }
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return manager;
}


+ (void)get:(NSString*)endpoint
           withData: (NSDictionary*)data
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure

{
    AFHTTPRequestOperationManager *manager = [self configureRequestManagerWithHeaders:nil];
    
    AFHTTPRequestOperation *operation = [manager GET:endpoint parameters:data success:success failure:failure];
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{}];
    [operation start];
    
    
}

+ (void)post:(NSString*)endpoint
           withData: (NSDictionary*)data
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure

{
    AFHTTPRequestOperationManager *manager = [self configureRequestManagerWithHeaders:nil];
    
    AFHTTPRequestOperation *operation = [manager POST:endpoint parameters:data success:success failure:failure];
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{}];
    [operation start];
    
    
}


+ (void)put:(NSString*)endpoint
   withData: (NSDictionary*)data
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    AFHTTPRequestOperationManager *manager = [self configureRequestManagerWithHeaders:nil];
    
    AFHTTPRequestOperation *operation = [manager PUT:endpoint parameters:data success:success failure:failure];
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{}];
    [operation start];

}


@end
