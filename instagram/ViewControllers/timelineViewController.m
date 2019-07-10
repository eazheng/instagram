//
//  timelineViewController.m
//  instagram
//
//  Created by eazheng on 7/8/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "timelineViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Post.h"
#import "PostCell.h"
#import "ImagePickerViewController.h"

@interface timelineViewController () <ImagePickerViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation timelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.timelineTableView reloadData];
    
    [self fetchTimeline];
    
    //initialize refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    //Bind the action to the refresh control
    [self.refreshControl addTarget:self action:@selector(fetchTimeline) forControlEvents:UIControlEventValueChanged];
    //Insert the refresh control into the list
    [self.timelineTableView insertSubview:self.refreshControl atIndex:0];
    
    //view controller becomes dataSource and deleagate of tableview
    self.timelineTableView.dataSource = self;
    self.timelineTableView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchTimeline];
}

- (void) fetchTimeline {
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            self.posts = (NSMutableArray *) posts;
            //reload the table view
            [self.timelineTableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            // handle error
        }
    }];
}

- (IBAction)logoutAction:(id)sender {
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
    NSLog(@"LOGGING OUT");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navigationController = [segue destinationViewController];
    ImagePickerViewController *imagePickerController = (ImagePickerViewController*)navigationController.topViewController;
    imagePickerController.delegate = self;
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.item];
    //cell.authorImage.image =
    
    cell.authorLabel.text = post.author.username;
    NSData *imageData = [post.image getData];
    cell.postedImage.image = [UIImage imageWithData:imageData];
    cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", post.likeCount];
    cell.captionLabel.text = post.caption;
    //cell.timestampLabel.text =
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


- (void)didPost {
    [self fetchTimeline];
    [self.timelineTableView reloadData];
}


@end
