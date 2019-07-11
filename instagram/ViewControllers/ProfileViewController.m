//
//  ProfileViewController.m
//  instagram
//
//  Created by eazheng on 7/11/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "PostCollectionViewCell.h"


@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *posts;


@end

@implementation ProfileViewController

//@dynamic profileImage;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    //UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;

    [self fetchTimeline];
    PFUser *cur = [PFUser currentUser];
    self.authorLabel.text = cur.username;
    
    
    [cur[@"profilePicture"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
             self.profileImage.image = [UIImage imageWithData:data];
        }
    }];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
   


//    layout.minimumInteritemSpacing = 5;
//    layout.minimumLineSpacing = 5;
//
//    CGFloat postersPerRow = 2;
//    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerRow - 1)) / postersPerRow;
//    CGFloat itemHeight = itemWidth * 1.5;
//    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}


- (void) fetchTimeline {
    // construct PFQuery
//    [postQuery includeKey:@"author"];
//
    
    // Find all posts by the current user
    PFUser *cur = [PFUser currentUser];
    PFQuery *query = [Post query];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"author" equalTo:cur];
    NSArray *usersPosts = [query findObjects];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = (NSMutableArray *) usersPosts;

            //reload the table view
            [self.collectionView reloadData];
        }
        else {
            // handle error
            NSLog(@"Error fetching posts");
        }
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

//resize image to be within 10MB
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    CGSize size = CGSizeMake(400, 400);
    UIImage *resizedImage = [self resizeImage:editedImage withSize:size];
    
    PFFileObject *profilePic = [Post getPFFileFromImage:resizedImage];
    
    PFUser *curUser = [PFUser currentUser];

    curUser[@"profilePicture"] = profilePic;
    [curUser saveInBackground];
    
    self.profileImage.image = editedImage;
    
    
    //[self savePicture];
    
    //curUser[@"profileImage"] = self.profileImage;
    
//    [PFUser currentUser].profileImage = editedImage;
    // Adds object to friendList array
//    PFUser *currentUser = [PFUser currentUser];
//    [currentUser addObject:userNameToAdd forKey:@"profileImage"];
    
    // Saves the changes on the Parse server. This is necessary to update the actual Parse server. If you don't "save" then the changes will be lost
//    [[PFUser currentUser] saveInBackground];
    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) savePicture {
    PFUser *curUser = [PFUser currentUser];
    curUser[@"profileImage"] = self.profileImage;
}

- (IBAction)addProfileImageAction:(id)sender {
  
    NSLog(@"Tapped image");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    //check if the camera is supported on the device
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}



- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
    
    
    Post *post = self.posts[indexPath.item];
    
    //cell.authorImage.image =
    
    //run in background to prevent blocking main thread
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            cell.pictureView.image = [UIImage imageWithData:data];
        }
    }];

    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}


@end
