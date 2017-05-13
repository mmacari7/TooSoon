//
//  Stream.h
//  Is it too soon
//
//  Created by Michael Macari on 6/9/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stream : NSObject

@property(nonatomic,strong) NSString *username;
+(NSMutableArray*)populateStreamArrayFromJSON:(id)json;

@end
