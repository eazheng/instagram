//
//  timelineViewController.m
//  instagram
//
//  Created by eazheng on 7/8/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "timelineViewController.h"
#import "Parse/Parse.h"
@interface timelineViewController ()

@end

@implementation timelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)logoutAction:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
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
