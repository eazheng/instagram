//
//  ImagePickerViewController.h
//  instagram
//
//  Created by eazheng on 7/9/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ImagePickerViewControllerDelegate

- (void)didPost:(Post *) post;

@end



@interface ImagePickerViewController : UIViewController

//@property (strong, nonatomic) UITableView*timelineTableView;

@property (nonatomic, weak) id<ImagePickerViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
