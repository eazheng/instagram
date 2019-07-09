//
//  ImagePickerViewController.m
//  instagram
//
//  Created by eazheng on 7/9/19.
//  Copyright © 2019 eazheng. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "Post.h"

@interface ImagePickerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextField *captionField;

@end

@implementation ImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

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

// the delegate method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    self.postImage.image = editedImage;
    
    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissKeyboardAction:(id)sender {
    NSLog(@"I want to dismiss keyboard");
    //[self dismissKeyboardAction:];
    [self.view endEditing:YES];
    NSLog(@"Current captions: %@", self.captionField.text);
}

- (IBAction)tapImageAction:(id)sender {
    
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

- (IBAction)cancelPostingAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createPostAction:(id)sender {
    NSLog(@"Want to post");
    //resize image before posting
    CGSize size = CGSizeMake(400, 400);
    //UIImage *resizedImage = [self resizeImage:self.postImage.image withSize:([CGSizeMake(400, 400)])];
    UIImage *resizedImage = [self resizeImage:self.postImage.image withSize:size];
    
    [Post postUserImage:resizedImage withCaption:self.captionField.text withCompletion:nil];
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
