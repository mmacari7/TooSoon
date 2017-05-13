//
//  CommentViewController.m
//  Is it too soon
//
//  Created by Michael Macari on 6/12/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import "CommentViewController.h"
#import "IsItTooSoonViewController.h"
#import "TooSoonAPIClien.h"
#import "CommentTableViewCell.h"
#import "TooSoonItem.h"



@interface CommentViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputComment;

@property (weak, nonatomic) IBOutlet UITextView *userJoke;

@property (weak, nonatomic) IBOutlet UIImageView *imageDisplay;

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (strong, nonatomic) NSArray *tooSoonItemBody;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@property (strong, nonatomic) NSTimer *myTimer;

@property (strong, nonatomic) UIRefreshControl *refreshControl;



@end

@implementation CommentViewController


- (IBAction)rewindTable:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}


//Called when return key is pressed

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self sendComment];
    _inputComment.text = @"";
    
    return YES;
}


- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 140 || returnKey;
}





-(void)sendComment
{
    NSMutableDictionary *myDict = [[NSMutableDictionary alloc]init];
    
    [myDict setObject:self.inputComment.text forKey:@"comment"];
    
    NSString *endpoint = [NSString stringWithFormat:@"http://arcane-bastion-8326.herokuapp.com/postItem/%@/comment", self.tooSoonItem.itemId];
    
    
    [TooSoonAPIClien put:endpoint withData:myDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success NIGGA");
        
        [self populateCommentTable];
        
}
     
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"Error");
                 }];
}


-(void)populateCommentTable {
    
    
    NSString *endpint = [NSString stringWithFormat:@"http://arcane-bastion-8326.herokuapp.com/postItem?id=%@", self.tooSoonItem.itemId];
    
    [TooSoonAPIClien get:endpint withData:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Nigga we made it");
        
        TooSoonItem* tooSoonItem = [[TooSoonItem alloc] initFromDictionary:responseObject];
        
        self.tooSoonItemBody = tooSoonItem.comments;
        
        [self.commentTableView reloadData];
        
        [self.refreshControl endRefreshing];
        
        
        if (_tooSoonItemBody.count != 0){
            [_commentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_tooSoonItemBody.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        else
        {
            
        }

        
    }
    
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
        
        
        [self.refreshControl endRefreshing];
    }];

    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(populateCommentTable) forControlEvents:UIControlEventValueChanged];
    
    [self setRefreshControl:self.refreshControl];
    
    
    
    [_inputComment setReturnKeyType:UIReturnKeySend];
    
    [_inputComment setDelegate:self];
    
    [self populateCommentTable];
    [self loadInformation];
    [self loadCommentsTimer];
    
}


- (void) viewDidDisappear:(BOOL)animated
{
    [_myTimer invalidate];
    _myTimer = nil;
}



//Method to reload comments every 10 seconds




-(void)loadCommentsTimer{
    
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(populateCommentTable) userInfo:nil repeats:YES];
    
    NSLog(@"GAINZ");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(void)loadComments{
//    self.tooSoonItemBody = self.tooSoonItem.comments;
//    
//}


-(void)loadInformation{
    self.userJoke.text = self.tooSoonItem.message;
    
    [_userJoke setFont:[UIFont systemFontOfSize:17]];
    
    self.userJoke.textColor = [UIColor whiteColor];
    
    [self.userJoke setUserInteractionEnabled:NO];
    //self.imageDisplay =
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *CellIdentifier = @"commentTableViewCell";
    CommentTableViewCell *cell = (CommentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        NSString *comment = [self.tooSoonItemBody objectAtIndex:[indexPath row]];
        cell.commentText.text = comment;
    
        //cell.commentText.textColor = [UIColor redColor];
    
        return cell;
    }


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
            return [self.tooSoonItemBody count];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
