//
//  ComposeNewPostViewController.m
//  Is it too soon
//
//  Created by Michael Macari on 6/8/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import "ComposeNewPostViewController.h"
#import "TooSoonAPIClien.h"
#import "TooSoonItem.h"


@interface ComposeNewPostViewController ()
@property (strong, nonatomic) NSMutableArray *tooSoonItemMessage;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;


@property (weak, nonatomic) IBOutlet UITextView *userPost;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;

@end

@implementation ComposeNewPostViewController


- (IBAction)cancelRewind:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}



- (void)recieveData:(UIImage *)theData {
    
    self.imagePreview.image = theData;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Get a handle on the view controller about be presented
    MemeViewController *memeViewController = segue.destinationViewController;
    
    if ([memeViewController isKindOfClass:[memeViewController class]]) {
        memeViewController.delegate = self;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _textView.delegate = self;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Enter vulgar joke here..."]) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Enter vulgar joke here...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = (textView.text.length - range.length) + text.length;
    if(newLength <= 180)
    {
        return YES;
    } else {
        NSUInteger emptySpace = 180 - (textView.text.length - range.length);
        textView.text = [[[textView.text substringToIndex:range.location]
                          stringByAppendingString:[text substringToIndex:emptySpace]]
                         stringByAppendingString:[textView.text substringFromIndex:(range.location + range.length)]];
        return NO;
    }
}




//Image Import From Gallery


- (IBAction)getImage:(UIButton*)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    }

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    self.imagePreview.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}




- (IBAction)doPost:(id)sender {
    NSMutableDictionary *myDict = [[NSMutableDictionary alloc]init];
    [myDict setObject:self.userPost.text forKey:@"message"];
    [TooSoonAPIClien post:@"http://arcane-bastion-8326.herokuapp.com/postItem" withData:myDict success:^(AFHTTPRequestOperation *operation, id json) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
    }];
    [self dismissViewControllerAnimated:TRUE completion:nil];

}


-(void)imagePost{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"REST URL PATH"]];
    
    NSData *imageData = UIImageJPEGRepresentation(self.imagePreview.image, 1.0);
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"unique-consistent-string";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"imageFormKey"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(data.length > 0)
        {
            //success
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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