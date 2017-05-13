//
//  MemeViewController.h
//  Is it too soon
//
//  Created by Michael Macari on 6/8/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyDataDelegate

- (void)recieveData:(UIImage *)theData;

@end


@interface MemeViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<MyDataDelegate> delegate;


@end

