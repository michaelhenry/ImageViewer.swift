//
// MHFacebookImageViewer.m
// Version 2.0
//
// Copyright (c) 2013 Michael Henry Pantaleon (http://www.iamkel.net). All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "MHFacebookImageViewer.h"
#import "UIImageView+AFNetworking.h"
#import <objc/runtime.h>
static const CGFloat kMinBlackMaskAlpha = 0.3f;
static const CGFloat kMaxImageScale = 2.5f;
static const CGFloat kMinImageScale = 1.0f;

@interface MHFacebookImageViewerCell : UICollectionViewCell<UIGestureRecognizerDelegate,UIScrollViewDelegate>{
    UIImageView * __imageView;
    UIScrollView * __scrollView;
    NSMutableArray *_gestures;
    CGPoint _panOrigin;
    BOOL _isAnimating;
    BOOL _isDoneAnimating;
    BOOL _isLoaded;
}

@property(nonatomic,assign) CGRect originalFrameRelativeToScreen;
@property(nonatomic,weak) UIViewController * rootViewController;
@property(nonatomic,weak) UIViewController * viewController;
@property(nonatomic,weak) UIView * blackMask;
@property(nonatomic,weak) UIButton * doneButton;
@property(nonatomic,weak) UIImageView * senderView;
@property(nonatomic,assign) NSInteger imageIndex;
@property(nonatomic,weak) UIImage * defaultImage;
@property(nonatomic,assign) NSInteger initialIndex;
@property(nonatomic,strong) UIPanGestureRecognizer* panGesture;

@property (nonatomic,weak) MHFacebookImageViewerOpeningBlock openingBlock;
@property (nonatomic,weak) MHFacebookImageViewerClosingBlock closingBlock;

@property(nonatomic,weak) UIView * superView;

@property(nonatomic) UIStatusBarStyle statusBarStyle;

- (void) loadAllRequiredViews;
- (void) setImageURL:(NSURL *)imageURL defaultImage:(UIImage*)defaultImage imageIndex:(NSInteger)imageIndex;

@end

@implementation MHFacebookImageViewerCell

@synthesize originalFrameRelativeToScreen = _originalFrameRelativeToScreen;
@synthesize rootViewController = _rootViewController;
@synthesize viewController = _viewController;
@synthesize blackMask = _blackMask;
@synthesize closingBlock = _closingBlock;
@synthesize openingBlock = _openingBlock;
@synthesize doneButton = _doneButton;
@synthesize senderView = _senderView;
@synthesize imageIndex = _imageIndex;
@synthesize superView = _superView;
@synthesize defaultImage = _defaultImage;
@synthesize initialIndex = _initialIndex;
@synthesize panGesture = _panGesture;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadAllRequiredViews];
    }
    return self;
}

- (void) loadAllRequiredViews{
    __scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    __scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    __scrollView.delegate = self;
    __scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:__scrollView];
    [_doneButton addTarget:self
                    action:@selector(close:)
          forControlEvents:UIControlEventTouchUpInside];
}

- (void) setImageURL:(NSURL *)imageURL defaultImage:(UIImage*)defaultImage imageIndex:(NSInteger)imageIndex {
    _imageIndex = imageIndex;
    _defaultImage = defaultImage;
    
    
    _senderView.alpha = 0.0f;
    if(!__imageView){
        __imageView = [[UIImageView alloc] initWithFrame:__scrollView.bounds];
        __imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [__scrollView addSubview:__imageView];
        __imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    __block UIImageView * _imageViewInTheBlock = __imageView;
    __block MHFacebookImageViewerCell * _justMeInsideTheBlock = self;
    __block UIScrollView * _scrollViewInsideBlock = __scrollView;
    
    [__imageView setImageWithURLRequest:[NSURLRequest requestWithURL:imageURL] placeholderImage:defaultImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [_scrollViewInsideBlock setZoomScale:1.0f animated:YES];
        [_imageViewInTheBlock setImage:image];
        _imageViewInTheBlock.frame = [_justMeInsideTheBlock centerFrameFromImage:_imageViewInTheBlock.image];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Image From URL Not loaded");
    }];
    
    if(_imageIndex==_initialIndex && !_isLoaded){
        __imageView.frame = _originalFrameRelativeToScreen;
        [UIView animateWithDuration:0.4f delay:0.0f options:0 animations:^{
            __imageView.frame = [self centerFrameFromImage:__imageView.image];
            //                CGAffineTransform transf = CGAffineTransformIdentity;
            // Root View Controller - move backward
            //                _rootViewController.view.transform = CGAffineTransformScale(transf, 0.95f, 0.95f);//横屏时，frame被修改，无法reset，干脆先不缩放
            // Root View Controller - move forward
            //                _viewController.view.transform = CGAffineTransformScale(transf, 1.05f, 1.05f);
            _blackMask.alpha = 1;
        }   completion:^(BOOL finished) {
            if (finished) {
                _isAnimating = NO;
                _isLoaded = YES;
                if(_openingBlock)
                    _openingBlock();
            }
        }];
        
    }
    __imageView.userInteractionEnabled = YES;
    [self addPanGestureToView:__imageView];
    [self addMultipleGesture];
    
}

#pragma mark - Add Pan Gesture
#pragma mark - Add Pan Gesture
- (void) addPanGestureToView:(UIView*)view
{
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerDidPan:)];
    _panGesture.cancelsTouchesInView = NO;
    _panGesture.delegate = self;
    
    __weak UIView *weakSuperView = view.superview;
    while (![weakSuperView isKindOfClass:[UITableView class]]) {
        weakSuperView = weakSuperView.superview;
        if (weakSuperView == Nil) {
            break;
        }
    }
    
    if ([weakSuperView isKindOfClass:[UITableView class]]) {
        [((UITableView*)weakSuperView).panGestureRecognizer requireGestureRecognizerToFail:_panGesture];
    }
    
    
    [view addGestureRecognizer:_panGesture];
    [_gestures addObject:_panGesture];
    
}

# pragma mark - Avoid Unwanted Horizontal Gesture
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:__scrollView];
    return fabs(translation.y) > fabs(translation.x) ;
}

#pragma mark - Gesture recognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    _panOrigin = __imageView.frame.origin;
    gestureRecognizer.enabled = YES;
    return !_isAnimating;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer == _panGesture) {
        return YES;
    }
    return NO;
}

#pragma mark - Handle Panning Activity
- (void) gestureRecognizerDidPan:(UIPanGestureRecognizer*)panGesture {
    if(__scrollView.zoomScale != 1.0f || _isAnimating)return;
    if(_imageIndex==_initialIndex){
        if(_senderView.alpha!=0.0f)
            _senderView.alpha = 0.0f;
    }else {
        if(_senderView.alpha!=1.0f)
            _senderView.alpha = 1.0f;
    }
    // Hide the Done Button
    [self hideDoneButton];
    __scrollView.bounces = NO;
    CGSize windowSize = _blackMask.bounds.size;
    CGPoint currentPoint = [panGesture translationInView:__scrollView];
    CGFloat y = currentPoint.y + _panOrigin.y;
    CGRect frame = __imageView.frame;
    frame.origin.y = y;
    
    __imageView.frame = frame;
    
    CGFloat yDiff = abs((y + __imageView.frame.size.height/2) - windowSize.height/2);
    _blackMask.alpha = MAX(1 - yDiff/(windowSize.height/0.5),kMinBlackMaskAlpha);
    
    if ((panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) && __scrollView.zoomScale == 1.0f) {
        
        if(_blackMask.alpha < 0.85f) {
            [self dismissViewController];
        }else {
            [self rollbackViewController];
        }
    }
}

#pragma mark - Just Rollback
- (void)rollbackViewController
{
    _isAnimating = YES;
    [UIView animateWithDuration:0.4f delay:0.0f options:0 animations:^{
        __imageView.frame = [self centerFrameFromImage:__imageView.image];
        _blackMask.alpha = 1;
    }   completion:^(BOOL finished) {
        if (finished) {
            _isAnimating = NO;
        }
    }];
}


#pragma mark - Dismiss
- (void)dismissViewController
{
    _isAnimating = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideDoneButton];
        __imageView.clipsToBounds = YES;
        CGFloat screenHeight =  [[[[UIApplication sharedApplication] delegate] window] bounds].size.height;
        CGFloat imageYCenterPosition = __imageView.frame.origin.y + __imageView.frame.size.height/2 ;
        BOOL isGoingUp =  imageYCenterPosition < screenHeight/2;
        [UIView animateWithDuration:0.4f delay:0.0f options:0 animations:^{
            if(_imageIndex==_initialIndex){
                __imageView.frame = _originalFrameRelativeToScreen;
            }else {
                __imageView.frame = CGRectMake(__imageView.frame.origin.x, isGoingUp?-screenHeight:screenHeight, __imageView.frame.size.width, __imageView.frame.size.height);
            }
            CGAffineTransform transf = CGAffineTransformIdentity;
            _rootViewController.view.transform = CGAffineTransformScale(transf, 1.0f, 1.0f);
            _blackMask.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (finished) {
                [_viewController.view removeFromSuperview];
                [_viewController removeFromParentViewController];
                _senderView.alpha = 1.0f;
                [UIApplication sharedApplication].statusBarHidden = NO;
                [UIApplication sharedApplication].statusBarStyle = _statusBarStyle;
                _isAnimating = NO;
                if(_closingBlock)
                    _closingBlock();
            }
        }];
    });
}

#pragma mark - Compute the new size of image relative to width(window)
- (CGRect) centerFrameFromImage:(UIImage*) image {
    if(!image) return CGRectZero;
    
    CGRect windowBounds = _rootViewController.view.bounds;
    CGSize newImageSize = [self imageResizeBaseOnWidth:windowBounds
                           .size.width oldWidth:image
                           .size.width oldHeight:image.size.height];
    // Just fit it on the size of the screen
    newImageSize.height = MIN(windowBounds.size.height,newImageSize.height);
    return CGRectMake(0.0f, windowBounds.size.height/2 - newImageSize.height/2, newImageSize.width, newImageSize.height);
}

- (CGSize)imageResizeBaseOnWidth:(CGFloat) newWidth oldWidth:(CGFloat) oldWidth oldHeight:(CGFloat)oldHeight {
    CGFloat scaleFactor = newWidth / oldWidth;
    CGFloat newHeight = oldHeight * scaleFactor;
    return CGSizeMake(newWidth, newHeight);
    
}

# pragma mark - UIScrollView Delegate
- (void)centerScrollViewContents {
    CGSize boundsSize = _rootViewController.view.bounds.size;
    CGRect contentsFrame = __imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    __imageView.frame = contentsFrame;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return __imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    _isAnimating = YES;
    [self hideDoneButton];
    [self centerScrollViewContents];
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    _isAnimating = NO;
}

- (void)addMultipleGesture {
    UITapGestureRecognizer *twoFingerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTwoFingerTap:)];
    twoFingerTapGesture.numberOfTapsRequired = 1;
    twoFingerTapGesture.numberOfTouchesRequired = 2;
    [__scrollView addGestureRecognizer:twoFingerTapGesture];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    [__scrollView addGestureRecognizer:singleTapRecognizer];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDobleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [__scrollView addGestureRecognizer:doubleTapRecognizer];
    
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    
    __scrollView.minimumZoomScale = kMinImageScale;
    __scrollView.maximumZoomScale = kMaxImageScale;
    __scrollView.zoomScale = 1;
    [self centerScrollViewContents];
}

#pragma mark - For Zooming
- (void)didTwoFingerTap:(UITapGestureRecognizer*)recognizer {
    CGFloat newZoomScale = __scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, __scrollView.minimumZoomScale);
    [__scrollView setZoomScale:newZoomScale animated:YES];
}

#pragma mark - Showing of Done Button if ever Zoom Scale is equal to 1
- (void)didSingleTap:(UITapGestureRecognizer*)recognizer {
    if(_doneButton.superview){
        [self hideDoneButton];
    }else {
        if(__scrollView.zoomScale == __scrollView.minimumZoomScale){
            //单击退出
            [self close:nil];
            //            if(!_isDoneAnimating){
            //                _isDoneAnimating = YES;
            //                [self.viewController.view addSubview:_doneButton];
            //                _doneButton.alpha = 0.0f;
            //                [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            //                    _doneButton.alpha = 1.0f;
            //                } completion:^(BOOL finished) {
            //                    [self.viewController.view bringSubviewToFront:_doneButton];
            //                    _isDoneAnimating = NO;
            //                }];
            //            }
        }else if(__scrollView.zoomScale == __scrollView.maximumZoomScale) {
            CGPoint pointInView = [recognizer locationInView:__imageView];
            [self zoomInZoomOut:pointInView];
        }
    }
}

#pragma mark - Zoom in or Zoom out
- (void)didDobleTap:(UITapGestureRecognizer*)recognizer {
    CGPoint pointInView = [recognizer locationInView:__imageView];
    [self zoomInZoomOut:pointInView];
}

- (void) zoomInZoomOut:(CGPoint)point {
    // Check if current Zoom Scale is greater than half of max scale then reduce zoom and vice versa
    CGFloat newZoomScale = __scrollView.zoomScale > (__scrollView.maximumZoomScale/2)?__scrollView.minimumZoomScale:__scrollView.maximumZoomScale;
    
    CGSize scrollViewSize = __scrollView.bounds.size;
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = point.x - (w / 2.0f);
    CGFloat y = point.y - (h / 2.0f);
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    [__scrollView zoomToRect:rectToZoomTo animated:YES];
}

#pragma mark - Hide the Done Button
- (void) hideDoneButton {
    if(!_isDoneAnimating){
        if(_doneButton.superview) {
            _isDoneAnimating = YES;
            _doneButton.alpha = 1.0f;
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
                _doneButton.alpha = 0.0f;
            } completion:^(BOOL finished) {
                _isDoneAnimating = NO;
                [_doneButton removeFromSuperview];
            }];
        }
    }
}

- (void)close:(UIButton *)sender {
    self.userInteractionEnabled = NO;
    [sender removeFromSuperview];
    [self dismissViewController];
}

- (void) dealloc {
    
}

@end

@interface MHFacebookImageViewer()<UIGestureRecognizerDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *_gestures;
    UICollectionView *_collectionView;
    UIView *_blackMask;
    UIImageView * _imageView;
    UIButton * _doneButton;
    UIView * _superView;
    
    CGPoint _panOrigin;
    CGRect _originalFrameRelativeToScreen;
    
    BOOL _isAnimating;
    BOOL _isDoneAnimating;
    
    UIStatusBarStyle _statusBarStyle;
}

@end

@implementation MHFacebookImageViewer
@synthesize rootViewController = _rootViewController;
@synthesize imageURL = _imageURL;
@synthesize openingBlock = _openingBlock;
@synthesize closingBlock = _closingBlock;
@synthesize senderView = _senderView;
@synthesize initialIndex = _initialIndex;

#pragma mark - UICollectionView
static NSString * cellID = @"mhfacebookImageViewerCell";
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(!self.imageDatasource) return 1;
    return [self.imageDatasource numberImagesForImageViewer:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MHFacebookImageViewerCell *imageViewerCell = (MHFacebookImageViewerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    imageViewerCell.originalFrameRelativeToScreen = _originalFrameRelativeToScreen;
    imageViewerCell.viewController = self;
    imageViewerCell.blackMask = _blackMask;
    imageViewerCell.rootViewController = _rootViewController;
    imageViewerCell.closingBlock = _closingBlock;
    imageViewerCell.openingBlock = _openingBlock;
    imageViewerCell.superView = _senderView.superview;
    imageViewerCell.senderView = _senderView;
    imageViewerCell.doneButton = _doneButton;
    imageViewerCell.initialIndex = _initialIndex;
    imageViewerCell.statusBarStyle = _statusBarStyle;
    imageViewerCell.backgroundColor = [UIColor clearColor];
    imageViewerCell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    if(!self.imageDatasource) {
        // Just to retain the old version
        [imageViewerCell setImageURL:_imageURL defaultImage:_senderView.image imageIndex:0];
    } else {
        [imageViewerCell setImageURL:[self.imageDatasource imageURLAtIndex:indexPath.row imageViewer:self] defaultImage:[self.imageDatasource imageDefaultAtIndex:indexPath.row imageViewer:self]imageIndex:indexPath.row];
    }
    return imageViewerCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.frame), CGRectGetHeight(collectionView.frame));
}

#pragma mark -
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [_collectionView.collectionViewLayout invalidateLayout];
}


- (void)loadView
{
    _statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    [UIApplication sharedApplication].statusBarHidden = YES;
    CGRect windowBounds = [[[[UIApplication sharedApplication] delegate] window] bounds];
    self.view = [[UIView alloc] initWithFrame:windowBounds];
    [self caculateOriginalFrame];
    //    NSLog(@"WINDOW :%@",NSStringFromCGRect(windowBounds));
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:windowBounds collectionViewLayout:flow];
    [self.view addSubview:_collectionView];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delaysContentTouches = YES;
    _collectionView.pagingEnabled = YES;
    _collectionView.contentOffset = CGPointMake(_initialIndex * windowBounds.size.width, 0);
    [_collectionView registerClass:[MHFacebookImageViewerCell class] forCellWithReuseIdentifier:cellID];
    
    _blackMask = [[UIView alloc] initWithFrame:windowBounds];
    _blackMask.backgroundColor = [UIColor blackColor];
    _blackMask.alpha = 0.0f;
    _blackMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:_blackMask atIndex:0];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneButton setImageEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];  // make click area bigger
    [_doneButton setImage:[UIImage imageNamed:@"Done"] forState:UIControlStateNormal];
    _doneButton.frame = CGRectMake(windowBounds.size.width - (51.0f + 9.0f),15.0f, 51.0f, 26.0f);
}

#pragma mark - Show
- (void)caculateOriginalFrame
{
    CGRect windowBounds = [[[[UIApplication sharedApplication] delegate] window] bounds];
    CGRect newFrame = [_senderView convertRect:windowBounds toView:nil];
    newFrame.origin = CGPointMake(newFrame.origin.x, newFrame.origin.y);
    newFrame.size = _senderView.frame.size;
    _originalFrameRelativeToScreen = newFrame;
}

- (void)presentFromRootViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self presentFromViewController:rootViewController];
}

- (void)presentFromViewController:(UIViewController *)controller
{
    _rootViewController = controller;
    [[[[UIApplication sharedApplication]windows]objectAtIndex:0]addSubview:self.view];
    [controller addChildViewController:self];
    [self didMoveToParentViewController:controller];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self caculateOriginalFrame];
        [_collectionView.collectionViewLayout invalidateLayout];
        [_collectionView reloadData];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

- (void) dealloc {
    _rootViewController = nil;
    _imageURL = nil;
    _senderView = nil;
    _imageDatasource = nil;
}

@end

#pragma mark - Custom Gesture Recognizer that will Handle imageURL
@interface MHFacebookImageViewerTapGestureRecognizer()

@end

@implementation MHFacebookImageViewerTapGestureRecognizer
@synthesize imageURL;
@synthesize openingBlock;
@synthesize closingBlock;
@synthesize imageDatasource;
@end
