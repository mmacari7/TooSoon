//
//  IsItTooSoon.h
//  Is it too soon
//
//  Created by Michael Macari on 6/8/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "TooSoonItem.h"
#import "AFNetworking.h"



@interface IsItTooSoon : UITableViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic,strong) TooSoonItem *tooSoonItem;


//Segment Controller Stuff
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

-(IBAction)segmentButton:(id)sender;

//Declares unwind action
- (IBAction)unwindToTable:(UIStoryboardSegue*)seague;



@end