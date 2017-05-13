//
//  IsItTooSoonViewController.m
//  Is it too soon
//
//  Created by Michael Macari on 6/8/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import "IsItTooSoonViewController.h"
#import "TooSoonCell.h"
#import "TooSoonAPIClien.h"
#import "Stream.h"
#import "TooSoonItem.h"
#import <objc/runtime.h>
#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "UIScrollView+InfiniteScroll.h"


@interface IsItTooSoon ()



@property (strong, nonatomic) IBOutlet UITableView *tooSoonTableView;



@property (strong, nonatomic) NSMutableArray *streamUsernames;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSMutableArray *tooSoonItems;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) int page1;
@property (nonatomic) int page2;
@property (nonatomic) int page3;
@property (strong, nonatomic) NSMutableArray *postIds;


@end

@implementation IsItTooSoon


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNew];
    _page1 = 2;
    _page2 = 2;
    _page3 = 2;
    
    [self scrollForever];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [self.refreshControl addTarget:self action:@selector(populateTable) forControlEvents:UIControlEventValueChanged];
    
    // Configure View Controller
    [self setRefreshControl:self.refreshControl];
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"lel.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"IMPACT" size:24.0], NSFontAttributeName,nil]];
    
    
    //[[UINavigationBar appearance] setBarTintColor:[UIColor purpleColor]];
 
    
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}



-(void)viewWillAppear:(BOOL)animated{
    //[self loadNew];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)segmentButton:(id)sender{
    [self populateTable];
}


        //Populates the table 

-(void)populateTable{
    
    
    if (self.segmentControl.selectedSegmentIndex == 0)
    {
        [self loadNew];
        _page1 = 2;
    }
    
    if (self.segmentControl.selectedSegmentIndex == 1)
    {
        [self loadTooSoon];
        _page2 = 2;
    }
    
    if (self.segmentControl.selectedSegmentIndex == 2)
    {
        [self loadNotTooSoon];
        _page3 = 2;
    }
}


-(void)loadNew{
    [TooSoonAPIClien get:@"http://arcane-bastion-8326.herokuapp.com/postItem?skip=0&limit=10" withData:nil success:^(AFHTTPRequestOperation *operation, id json) {
        self.tooSoonItems = [TooSoonItem populateTooSoonArrayFromJSON:json];
        [self.tooSoonTableView reloadData];
        
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
        
        
        [self.refreshControl endRefreshing];
    }];
}



-(void)loadTooSoon{
    [TooSoonAPIClien get:@"http://arcane-bastion-8326.herokuapp.com/postItem?sortField=tooSoonVoteCount&skip=0&limit=10" withData:nil success:^(AFHTTPRequestOperation *operation, id json) {
        self.tooSoonItems = [TooSoonItem populateTooSoonArrayFromJSON:json];
        
        [self.tooSoonTableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
        
        
        [self.refreshControl endRefreshing];
    }];
}



-(void)loadNotTooSoon{
    [TooSoonAPIClien get:@"http://arcane-bastion-8326.herokuapp.com/postItem?sortField=notTooSoonVoteCount&skip=0&limit=10" withData:nil success:^(AFHTTPRequestOperation *operation, id json) {
        self.tooSoonItems = [TooSoonItem populateTooSoonArrayFromJSON:json];
        
        [self.tooSoonTableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
        
        
        [self.refreshControl endRefreshing];
    }];
}






- (IBAction)tooSoonVote:(id)sender {
    
    [sender setUserInteractionEnabled:NO];
    
    TooSoonCell *cell = (TooSoonCell*)objc_getAssociatedObject(sender, @"tooSoon");
    int cellIndex = (int)[[self.tableView indexPathForCell:cell] row];
    TooSoonItem *item = [self.tooSoonItems objectAtIndex:cellIndex];
    
    NSString *endpoint = [NSString stringWithFormat:@"https://arcane-bastion-8326.herokuapp.com/postItem/%@/tooSoon",item.itemId];
    [TooSoonAPIClien put:endpoint withData:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        
        //Store the ID into NSDeafaultArray
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *tooSoonidsArray = [defaults objectForKey:@"tooSoonIds"];
        NSMutableArray *mutableVotedIds = [tooSoonidsArray mutableCopy];
        
        if (mutableVotedIds == nil){
            
            mutableVotedIds = [[NSMutableArray alloc] init];
            [mutableVotedIds addObject:item.itemId];
            [defaults setObject:mutableVotedIds forKey:@"tooSoonIds"];
            [defaults synchronize];
        }
        else
            
        {
            [mutableVotedIds addObject:item.itemId];
            [defaults setObject:mutableVotedIds forKey:@"tooSoonIds"];
            [defaults synchronize];
        }
        
        [self loadNew];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@", [error localizedDescription]);
        
    }];
}
- (IBAction)notTooSoonVote:(id)sender {
    
    [sender setUserInteractionEnabled:NO];

    TooSoonCell *cell = (TooSoonCell*)objc_getAssociatedObject(sender, @"notTooSoon");
    int cellIndex = (int)[[self.tableView indexPathForCell:cell] row];
    TooSoonItem *item = [self.tooSoonItems objectAtIndex:cellIndex];
    
    NSString *endpoint = [NSString stringWithFormat:@"https://arcane-bastion-8326.herokuapp.com/postItem/%@/notTooSoon",item.itemId];
    [TooSoonAPIClien put:endpoint withData:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success NIGGA");
        
       
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *notTooSoonidsArray = [defaults objectForKey:@"notTooSoonIds"];
        NSMutableArray *NTSvotedIds = [notTooSoonidsArray mutableCopy];
        
        if (NTSvotedIds == nil){
            
            NTSvotedIds = [[NSMutableArray alloc] init];
            [NTSvotedIds addObject:item.itemId];
            [defaults setObject:NTSvotedIds forKey:@"notTooSoonIds"];
            [defaults synchronize];
        }
        else
            
        {
            [NTSvotedIds addObject:item.itemId];
            [defaults setObject:NTSvotedIds forKey:@"notTooSoonIds"];
            [defaults synchronize];
        }


        [self loadNew];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FUCK %@", [error localizedDescription]);
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    
    if (self.segmentControl.selectedSegmentIndex == 0 || self.segmentControl.selectedSegmentIndex == 1 || self.segmentControl.selectedSegmentIndex){
            return [self.tooSoonItems count];
        //return 3;
        }
        else {
            return 0;
        }
    }


//Tells compiler to refresh tooSoonCell and input data
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.segmentControl.selectedSegmentIndex == 0 || self.segmentControl.selectedSegmentIndex == 1 || self.segmentControl.selectedSegmentIndex == 2)
    {
        static NSString *Cellidentifier = @"tooSoonCell";
        TooSoonCell *cell = (TooSoonCell*)[tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
        
        
        TooSoonItem *item = [self.tooSoonItems objectAtIndex:[indexPath row]];
        cell.userText.text = item.message;
        cell.tooSoonVoteCount.text = [NSString stringWithFormat:@"%i",(int)item.tooSoonVoteCount];
        cell.notTooSoonVoteCount.text = [NSString stringWithFormat:@"%i",(int) item.notTooSoonVoteCount];
        
        cell.commentCount.text = [NSString stringWithFormat:@"%i",(int) item.commentCount];
        
        objc_setAssociatedObject(cell.notTooSoonButton, @"notTooSoon", cell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(cell.tooSoonButton, @"tooSoon", cell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [cell.tooSoonButton setUserInteractionEnabled:YES];
        [cell.notTooSoonButton setUserInteractionEnabled:YES];
        [cell.tooSoonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.notTooSoonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.userText.textColor = [UIColor whiteColor];
        
        
        //check stored array of ids to see if user already voted
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *tooSoonVotedIds = [defaults objectForKey:@"tooSoonIds"];
        NSArray *notTooSoonVotedIds = [defaults objectForKey:@"notTooSoonIds"];
        
        if (tooSoonVotedIds) {
            for (NSString *itemId in tooSoonVotedIds) {
                if ([itemId isEqualToString:item.itemId]) {
                    
                    [cell.tooSoonButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [cell.tooSoonButton setUserInteractionEnabled:NO];
                    [cell.notTooSoonButton setUserInteractionEnabled:NO];
                    break;
                }
            }
        }
        if (notTooSoonVotedIds) {
            for (NSString *itemId in notTooSoonVotedIds) {
                    if ([itemId isEqualToString:item.itemId]){
                        [cell.notTooSoonButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                        [cell.tooSoonButton setUserInteractionEnabled:NO];
                        [cell.notTooSoonButton setUserInteractionEnabled:NO];
                        break;
                }
            }
        }
        [cell.userText setUserInteractionEnabled:NO];
        return cell;
    }
    else
    {
        return [[UITableViewCell alloc]init];
    }
}


-(void)scrollForever{
    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleWhite;
    
    
    
    [self.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
        
        if (self.segmentControl.selectedSegmentIndex == 0) {
            
        NSString *endpint = [NSString stringWithFormat:@"http://arcane-bastion-8326.herokuapp.com/postItem?skip=0&limit=%i", (int)  _page1 * 10];
        
        [TooSoonAPIClien get:endpint withData:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.tooSoonItems = [TooSoonItem populateTooSoonArrayFromJSON:responseObject];
            [self.tooSoonTableView reloadData];
            
            _page1++;
            
            NSLog(@"%i", (int) _page1);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error");
            
            
            [self.refreshControl endRefreshing];
        }];
        
    }
        
        if (self.segmentControl.selectedSegmentIndex == 1) {
            NSString *endpint = [NSString stringWithFormat:@"http://arcane-bastion-8326.herokuapp.com/postItem?sortField=tooSoonVoteCount&skip=0&limit=%i", (int)  _page2 * 10];
            
            [TooSoonAPIClien get:endpint withData:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                self.tooSoonItems = [TooSoonItem populateTooSoonArrayFromJSON:responseObject];
                [self.tooSoonTableView reloadData];
                
                _page2++;
                
                NSLog(@"%i", (int) _page2);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error");
                
                
                [self.refreshControl endRefreshing];
            }];

            
        }
        
        if (self.segmentControl.selectedSegmentIndex == 2){
            NSString *endpint = [NSString stringWithFormat:@"http://arcane-bastion-8326.herokuapp.com/postItem?sortField=notTooSoonVoteCount&skip=0&limit=%i", (int)  _page3 * 10];
            
            [TooSoonAPIClien get:endpint withData:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                self.tooSoonItems = [TooSoonItem populateTooSoonArrayFromJSON:responseObject];
                [self.tooSoonTableView reloadData];
                
                _page3++;
                
                NSLog(@"%i", (int) _page3);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error");
                
                
                [self.refreshControl endRefreshing];
            }];

        }
        
        [tableView finishInfiniteScroll];
    }];
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"commentSegue" sender: self];
    [self.tooSoonItems objectAtIndex:indexPath.row];
    
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"commentSegue"]){
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        CommentViewController* controller = (CommentViewController*)[[segue destinationViewController] topViewController];
        controller.tooSoonItem = [self.tooSoonItems objectAtIndex:path.row];
    }
    
}





//*/
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//*/


 //Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//         //Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//         //Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
