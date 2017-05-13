//
//  TooSoonItem.m
//  Is it too soon
//
//  Created by Michael Macari on 6/9/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import "TooSoonItem.h"

@implementation TooSoonItem

-(id)initFromDictionary:(NSDictionary*)dict{
    self = [super init];
    
    if ([dict objectForKey:@"id"]) {
        self.itemId = [dict objectForKey:@"id"];
    }
    
    if ([dict objectForKey:@"message"]) {
        self.message = [dict objectForKey:@"message"];
    }
    
    if ([dict objectForKey:@"tooSoonVoteCount"]) {
        self.tooSoonVoteCount = [[dict objectForKey:@"tooSoonVoteCount"]intValue];
    }
    
    if ([dict objectForKey:@"notTooSoonVoteCount"]){
        self.notTooSoonVoteCount = [[dict objectForKey:@"notTooSoonVoteCount"]intValue];
    }
    
    if ([dict objectForKey:@"comments"]) {
        self.comments = [[NSArray alloc] initWithArray:[dict objectForKey:@"comments"]];
        self.commentCount = self.comments.count;
        
    }
    
    
    
    else {
        self.commentCount = 0;
    }
    
    return self;
    
}


+(NSMutableArray*)populateTooSoonArrayFromJSON:(id)json{
    NSMutableArray *tooSoonArray = [[NSMutableArray alloc] init];
    NSMutableArray *jsonArray = json;
    
    for (NSDictionary *jsonTooSoon in jsonArray) {
        TooSoonItem *item = [[TooSoonItem alloc] initFromDictionary:jsonTooSoon];
        [tooSoonArray addObject: item];
    }
    
    return tooSoonArray;
}


@end
