//
//  MemeViewController.m
//  Is it too soon
//
//  Created by Michael Macari on 6/8/15.
//  Copyright (c) 2015 Michael Macari. All rights reserved.
//

#import "MemeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MemeViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *memeImage;

@property (weak, nonatomic) IBOutlet UIView *viewBounds;

@property (weak, nonatomic) IBOutlet UITextField *textLabel1;


@property (weak, nonatomic) IBOutlet UITextField *textLabel2;



@end

@implementation MemeViewController








-(void)viewWillAppear:(BOOL)animated{
    self.textLabel1.font = [UIFont fontWithName:@"Impact" size:35];
    self.textLabel2.font = [UIFont fontWithName:@"Impact" size:35];
    [self.textLabel1 setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textLabel2 setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.placeholder = @"Your Placeholdertext";
}



            //Adds image in order to tweak out as a meme


- (IBAction)addImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    self.memeImage.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}





- (IBAction)saveMeme:(id)sender {
    
    [[self textLabel1] setTintColor:[UIColor clearColor]];
    [[self textLabel2] setTintColor:[UIColor clearColor]];

    UIView *subView = self.viewBounds;
    UIGraphicsBeginImageContextWithOptions(subView.bounds.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [subView.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *snapshotImageView = [[UIImageView alloc] initWithImage:snapshotImage];
    
    
    UIImageWriteToSavedPhotosAlbum(snapshotImageView.image, nil, nil, nil);
    
    
    UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Meme Saved"
                                                message:@"Your Meme was succesfully saved to your gallery" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    
    [mes show];
    
}


- (IBAction)useMeme:(id)sender {
    
    [[self textLabel1] setTintColor:[UIColor clearColor]];
    [[self textLabel2] setTintColor:[UIColor clearColor]];

    UIView *subView = self.viewBounds;
    UIGraphicsBeginImageContextWithOptions(subView.bounds.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [subView.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *snapshotImageView = [[UIImageView alloc] initWithImage:snapshotImage];
    
    
    [self.delegate recieveData: snapshotImageView.image];
    [self.navigationController popViewControllerAnimated:YES];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
