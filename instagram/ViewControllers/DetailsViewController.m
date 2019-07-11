//
//  DetailsViewController.m
//  instagram
//
//  Created by eazheng on 7/10/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "DetailsViewController.h"
#import "DateTools.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postedImage;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.authorLabel.text = self.post.author.username;
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.postedImage.image = [UIImage imageWithData:data];
        }
    }];
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    self.captionLabel.text = self.post.caption;
    
    NSString *postTimestamp = [NSString stringWithFormat:@"%@", self.post.createdAt];
    self.timestampLabel.text = postTimestamp;
    NSLog(@"Timestamp: %@", postTimestamp);
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss z";
    // Convert String to Date
    NSDate *date = [formatter dateFromString:postTimestamp];
    NSDate *now = [[NSDate date] dateByAddingDays:-1];
    BOOL postWasRecentBool = [date isLaterThan:now];
    
    //if post was less than 1 day ago
    if (postWasRecentBool) {
        self.timestampLabel.text = [NSString stringWithFormat:@"%@%@", date.shortTimeAgoSinceNow, @" ago"];
    }
    else {
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        // Convert Date to String
        self.timestampLabel.text = [formatter stringFromDate:date];
    }
    
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
