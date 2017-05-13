//
//  ComposeNewPostViewController.h
//  Is it too soon
//
//  Created by Michael Macari on 6/8/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemeViewController.h"



@interface ComposeNewPostViewController : UIViewController <UITextViewDelegate, MyDataDelegate>



@property (strong, nonatomic) UIImagePickerController *imagePicker;

-(void)textChanged:(NSNotification*)notification;


@end
