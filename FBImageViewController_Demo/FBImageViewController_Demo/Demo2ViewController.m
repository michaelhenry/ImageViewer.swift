//
//  Demo2ViewController.m
//  FBImageViewController_Demo
//
//  Created by Michael henry Pantaleon on 6/1/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "Demo2ViewController.h"
#import "MHFacebookImageViewer.h"

@interface Demo2ViewController ()
- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image;
@end

@implementation Demo2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayImage:self.imageView1 withImage:[UIImage imageNamed:@"1_iphone"]];
    [self displayImage:self.imageView2 withImage:[UIImage imageNamed:@"2_iphone"]];
    [self displayImage:self.imageView3 withImage:[UIImage imageNamed:@"3_iphone"]];
    [self displayImage:self.imageView4 withImage:[UIImage imageNamed:@"4_iphone"]];
    [self displayImage:self.imageView5 withImage:[UIImage imageNamed:@"5_iphone"]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView1:nil];
    [self setImageView2:nil];
    [self setImageView3:nil];
    [self setImageView3:nil];
    [self setImageView4:nil];
    [self setImageView5:nil];
    [super viewDidUnload];
}

- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image  {
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setupImageViewer];
    imageView.clipsToBounds = YES;
}
@end
