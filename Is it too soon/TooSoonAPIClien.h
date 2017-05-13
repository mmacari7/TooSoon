//
//  TooSoonAPIClien.h
//  Is it too soon
//
//  Created by Michael Macari on 6/9/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"


@interface TooSoonAPIClien : NSObject


//Declaration of requestPost
+ (void)get:(NSString*)endpoint
           withData: (NSDictionary*)data
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)post:(NSString*)endpoint
   withData: (NSDictionary*)data
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)put:(NSString*)endpoint
    withData: (NSDictionary*)data
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



@end
