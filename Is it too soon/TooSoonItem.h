//
//  TooSoonItem.h
//  Is it too soon
//
//  Created by Michael Macari on 6/9/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TooSoonItem : NSObject

-(id)initFromDictionary:(NSDictionary*)dict;

@property(nonatomic,strong) NSString *itemId;

@property(nonatomic,strong) NSString *message;
+(NSMutableArray*)populateTooSoonArrayFromJSON:(id)json;

@property (nonatomic) NSInteger tooSoonVoteCount;

@property (nonatomic) NSInteger notTooSoonVoteCount;

@property (nonatomic) NSInteger commentCount;

@property (nonatomic, strong) NSArray* comments;

@end
