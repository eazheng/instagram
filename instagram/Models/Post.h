//
//  Post.h
//  instagram
//
//  Created by eazheng on 7/9/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <Parse/Parse.h>
#import "PFObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;

@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;

// TODO: add a timestamp property?

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;

//+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption
//        withCompletion: (void (^)(Post *, NSError *))completion;

// (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion;


@end

NS_ASSUME_NONNULL_END
