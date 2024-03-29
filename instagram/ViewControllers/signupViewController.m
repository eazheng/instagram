//
//  signupViewController.m
//  instagram
//
//  Created by eazheng on 7/8/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "signupViewController.h"
#import "Parse/Parse.h"
#import "timelineViewController.h"
#import "AppDelegate.h"

@interface signupViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
- (IBAction)registerUserAction:(id)sender;


@end

@implementation signupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registerUserAction:(id)sender {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
            //[self performSegueWithIdentifier:@"registered" sender:nil];
            
            //change root view controller to tab bar once logged in - timeline
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            signupViewController *timelineViewController = [storyboard instantiateViewControllerWithIdentifier:@"AuthenticatedViewController"];
            appDelegate.window.rootViewController = timelineViewController;
            
        }
    }];
}

- (IBAction)dismissKeyboardAction:(id)sender {
    NSLog(@"I want to dismiss keyboard");
    //[self dismissKeyboardAction:];
    [self.view endEditing:YES];
}


@end
