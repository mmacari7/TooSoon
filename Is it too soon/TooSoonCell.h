//
//  TooSoonCell.h
//  Is it too soon
//
//  Created by Michael Macari on 6/9/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TooSoonCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UITextView *userText;



@property (weak, nonatomic) IBOutlet UILabel *userComments;

@property (weak, nonatomic) IBOutlet UILabel *tooSoonVoteCount;

@property (weak, nonatomic) IBOutlet UILabel *notTooSoonVoteCount;

@property (weak, nonatomic) IBOutlet UIButton *tooSoonButton;

@property (weak, nonatomic) IBOutlet UIButton *notTooSoonButton;

@property (weak, nonatomic) IBOutlet UILabel *commentCount;


//Sets up the object that the cell will be recieving


@end
