//
//  CommentViewController.h
//  Is it too soon
//
//  Created by Michael Macari on 6/12/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TooSoonItem.h"

@interface CommentViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,strong) TooSoonItem *tooSoonItem;


@end
