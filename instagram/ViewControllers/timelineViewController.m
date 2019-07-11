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
#import "DetailsViewController.h"
#import "DateTools.h"

@interface timelineViewController () <ImagePickerViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

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
    postQuery.limit = 30;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = (NSMutableArray *) posts;
            //reload the table view
            [self.timelineTableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            // handle error
            NSLog(@"Error fetching posts");
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
    if ([segue.identifier isEqualToString:@"ShowComposer"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ImagePickerViewController *imagePickerController = (ImagePickerViewController*)navigationController.topViewController;
        imagePickerController.delegate = self;
    }
    
    //for details view controller
    else if ([segue.identifier isEqualToString:@"ShowDetails"]) {
        PostCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.timelineTableView indexPathForCell:tappedCell];
        
        DetailsViewController *detailViewController = [segue destinationViewController];
        detailViewController.post = self.posts[indexPath.row];
    }
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.item];
    //cell.authorImage.image =
    
    cell.authorLabel.text = post.author.username;
    
    //set profile images on timeline posts
    [post.author[@"profilePicture"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            cell.authorImage.image = [UIImage imageWithData:data];
        }
    }];
    cell.authorImage.layer.cornerRadius = cell.authorImage.frame.size.width / 2;
    cell.authorImage.clipsToBounds = YES;
    
    
    //run in background to prevent blocking main thread
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            cell.postedImage.image = [UIImage imageWithData:data];
        }
    }];
    
    cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", post.likeCount];
    cell.captionLabel.text = post.caption;
    //cell.timestampLabel.text =
    
    NSString *postTimestamp = [NSString stringWithFormat:@"%@", post.createdAt];
    cell.timestampLabel.text = postTimestamp;
    //NSLog(@"Timestamp: %@", postTimestamp);
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss z";
    // Convert String to Date
    NSDate *date = [formatter dateFromString:postTimestamp];
    NSDate *now = [[NSDate date] dateByAddingDays:-1];
    BOOL postWasRecentBool = [date isLaterThan:now];
    
    //if post was less than 1 day ago
    if (postWasRecentBool) {
        cell.timestampLabel.text = [NSString stringWithFormat:@"%@%@", date.shortTimeAgoSinceNow, @" ago"];
    }
    else {
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        // Convert Date to String
        cell.timestampLabel.text = [formatter stringFromDate:date];
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


- (void)didPost {
    [self fetchTimeline];
    [self.timelineTableView reloadData];
}

/*
- (void) fetchMoreData {
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    postQuery.skip = 20;

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = (NSMutableArray *) posts;
            //            //[self.posts addObjectsFromArray:(NSMutableArray *)posts];
            //            // do something with the data fetched
            //            if (self.posts == nil || posts == nil) {
            //                self.posts = (NSMutableArray *) posts;
            //            }
            //            else {
            //                [self.posts addObjectsFromArray:(NSMutableArray *)posts];//(NSMutableArray *) posts;
            //            }
            //[allMyObjects addObjectsFromArray: array2];
            //reload the table view
            [self.timelineTableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            // handle error
        }
    }];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.timelineTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.timelineTableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.timelineTableView.isDragging) {
            self.isMoreDataLoading = true;
            //[self loadMoreData];
            [self fetchMoreData];
        }
    }
}
 */
@end
