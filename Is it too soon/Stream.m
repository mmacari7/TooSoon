//
//  Stream.m
//  Is it too soon
//
//  Created by Michael Macari on 6/9/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import "Stream.h"

@implementation Stream



-(id)initFromDictionary:(NSDictionary*)dict{
    self = [super init];
    
    if ([dict objectForKey:@"username"]) {
        self.username = [dict objectForKey:@"username"];
    }
    
    return self;
}


+(NSMutableArray*)populateStreamArrayFromJSON:(id)json{
    NSMutableArray *streamArray = [[NSMutableArray alloc] init];
    NSMutableArray *jsonArray = json;
    
    for (NSDictionary *jsonStream in jsonArray) {
        Stream *stream = [[Stream alloc] initFromDictionary:jsonStream];
        [streamArray addObject:stream];
    }
    
    return streamArray;
}

@end
