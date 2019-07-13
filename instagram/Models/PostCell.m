//
//  PostCell.m
//  instagram
//
//  Created by eazheng on 7/9/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "PostCell.h"
#import "Post.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)didTapFavorite:(id)sender {
    // to favorite
    //PFUser *curUser = [PFUser currentUser];

    if (![self.post.likedUsers containsObject:self.authorLabel.text]) {
    //if (self.post.liked == NO) {
        if (self.post.likedUsers.count == 0) {
            self.post.likedUsers = [NSMutableArray arrayWithObjects:self.authorLabel.text, nil];
        }
        else {
        
            [self.post.likedUsers addObject:self.authorLabel.text];
        }
        NSLog(@"%@", self.post.likedUsers);
        self.post.liked = YES;
        NSLog(@"LIKE: %d", [self.post.likeCount intValue]);
        
        int value = [self.post.likeCount intValue];
        
        self.post.likeCount = [NSNumber numberWithInt:value + 1];
        
        NSLog(@"LIKE AFTER: %d", [self.post.likeCount intValue]);
        
        // TODO: Update cell UI
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        //self.favorited = YES;
        
        //refresh like data
        self.likeCountLabel.text = [NSString stringWithFormat:@"%d", [self.post.likeCount intValue]];
        
        //send to Parse
        [self.post setValue:self.post.likeCount forKey:@"likeCount"];
        [self.post saveInBackground];
        
        /*
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
         */
    }
    // to unfavorite (was alrady favorited before)
    else {
        //remove this user from array
        NSUInteger i = [self.post.likedUsers indexOfObject:self.authorLabel.text];
        [self.post.likedUsers removeObjectAtIndex:i];
    //indexOfObject:aString
        
        self.post.liked = NO;
        NSLog(@"LIKE: %@", self.post.likeCount);
        
        //todo: remove object from array
        int value = [self.post.likeCount intValue];
        self.post.likeCount = [NSNumber numberWithInt:value - 1];
        
        NSLog(@"LIKE AFTER: %@", self.post.likeCount);
        
        // TODO: Update cell UI
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        //self.favorited = YES;
        
        //refresh like data
        self.likeCountLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
        
        /*
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
         */
    }
}

@end
