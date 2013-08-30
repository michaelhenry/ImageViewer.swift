//
//  Demo3ViewController.m
//  FBImageViewController_Demo
//
//  Created by Michael henry Pantaleon on 6/1/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "Demo3ViewController.h"
#import "MHFacebookImageViewer.h"
@interface Demo3ViewController ()

- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image;
@end

@implementation Demo3ViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"two_image_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImageView * imageViewLeft = (UIImageView*) [cell viewWithTag:1];
    UIImageView * imageViewRight = (UIImageView*) [cell viewWithTag:2];

    NSInteger imageIndex = indexPath.row + 1;
    [self displayImage:imageViewLeft withImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i_iphone",(imageIndex * 2)-1]]];
     [self displayImage:imageViewRight withImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i_iphone",(imageIndex * 2)-2]]];
    return cell;
}

- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image  {
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setupImageViewer];
    imageView.clipsToBounds = YES;
}

@end
