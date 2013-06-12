//
// MHFacebookImageViewer.m
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
static const CGFloat kMinBlackMaskAlpha = 0.3f;
static const CGFloat kMaxImageScale = 2.5f;
static const CGFloat kMinImageScale = 1.0f;


@interface MHFacebookImageViewer()<UIGestureRecognizerDelegate,UIScrollViewDelegate>{
    NSMutableArray *_gestures;
    
    UIView *_blackMask;
    UIImageView * _imageView;
    UIScrollView * _scrollView;
    UIButton * _doneButton;
    UIView * _superView;
    
    CGPoint _panOrigin;
    CGRect _originalFrameRelativeToScreen;
    
    BOOL _isAnimating;
    BOOL _isDoneAnimating;
}

- (void) addPanGestureToView:(UIView*)view;
@end

@implementation MHFacebookImageViewer
@synthesize rootViewController = _rootViewController;
@synthesize imageURL = _imageURL;
@synthesize openingBlock = _openingBlock;
@synthesize closingBlock = _closingBlock;
@synthesize senderView = _senderView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [UIApplication sharedApplication].statusBarHidden = YES;
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    CGRect windowBounds = rootViewController.view.bounds;
    
    self.view = [[UIView alloc] initWithFrame:windowBounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _blackMask = [[UIView alloc] initWithFrame:windowBounds];
    _blackMask.backgroundColor = [UIColor blackColor];
    _blackMask.alpha = 0.0f;
    _blackMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:_blackMask atIndex:0];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:windowBounds];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneButton addTarget:self
                    action:@selector(close:)
          forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setImage:[UIImage imageNamed:@"Done"] forState:UIControlStateNormal];
    _doneButton.frame = CGRectMake(windowBounds.size.width - (51.0f + 9.0f),15.0f, 51.0f, 26.0f);
    
    _superView = _senderView.superview;
    // Compute Original Frame Relative To Screen
    CGRect newFrame = [_senderView convertRect:[[UIScreen mainScreen] applicationFrame] toView:nil];
    newFrame.origin = CGPointMake(newFrame.origin.x, newFrame.origin.y);
    newFrame.size = _senderView.frame.size;
    _originalFrameRelativeToScreen = newFrame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isAnimating = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_senderView removeFromSuperview];
        _imageView = [[UIImageView alloc]initWithFrame:_originalFrameRelativeToScreen];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_imageView];
        
        if(_imageURL) {
            __block UIImageView * _imageViewInTheBlock = _imageView;
            __block MHFacebookImageViewer * _justMeInsideTheBlock = self;
            __block UIScrollView * _scrollViewInsideBlock = _scrollView;
            [_imageView setImageWithURLRequest:[NSURLRequest requestWithURL:_imageURL] placeholderImage:_senderView.image success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                [_scrollViewInsideBlock setZoomScale:1.0f animated:YES];
                [_imageViewInTheBlock setImage:image];
                _imageViewInTheBlock.frame = [_justMeInsideTheBlock centerFrameFromImage:_imageViewInTheBlock.image];
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                NSLog(@"Image From URL Not loaded");
            }];
        }else{
            [_imageView setImage:_senderView.image];
        }
        
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        // Start animation on view did load
        [UIView animateWithDuration:0.4f delay:0.0f options:0 animations:^{
            _imageView.frame = [self centerFrameFromImage:_imageView.image];
            CGAffineTransform transf = CGAffineTransformIdentity;
            // Root View Controller - move backward
            rootViewController.view.transform = CGAffineTransformScale(transf, 0.95f, 0.95f);
            // Root View Controller - move forward
            self.view.transform = CGAffineTransformScale(transf, 1.05f, 1.05f);
            _blackMask.alpha = 1;
        }   completion:^(BOOL finished) {
            if (finished) {
                _imageView.userInteractionEnabled = YES;
                [self addPanGestureToView:_imageView];
                [self addMultipleGesture];
                _isAnimating = NO;
                if(_openingBlock)
                    _openingBlock();
            }
        }];
    });
}

#pragma mark - Compute the new size of image relative to width(window)
- (CGRect) centerFrameFromImage:(UIImage*) image {
    if(!image) return CGRectZero;
    
    CGRect windowBounds = self.view.bounds;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Add Pan Gesture
- (void) addPanGestureToView:(UIView*)view
{
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(gestureRecognizerDidPan:)];
    panGesture.cancelsTouchesInView = YES;
    panGesture.delegate = self;
    [view addGestureRecognizer:panGesture];
    [_gestures addObject:panGesture];
    panGesture = nil;
}

# pragma mark - Avoid Unwanted Horizontal Gesture
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    return fabs(translation.y) > fabs(translation.x) ;
}

#pragma mark - Gesture recognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    _panOrigin = _imageView.frame.origin;
    gestureRecognizer.enabled = YES;
    return !_isAnimating;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Handle Panning Activity
- (void) gestureRecognizerDidPan:(UIPanGestureRecognizer*)panGesture {
    if(_scrollView.zoomScale != 1.0f || _isAnimating)return;
    // Hide the Done Button
    [self hideDoneButton];
    _scrollView.bounces = NO;
    CGSize windowSize = _blackMask.bounds.size;
    CGPoint currentPoint = [panGesture translationInView:self.view];
    CGFloat y = currentPoint.y + _panOrigin.y;
    CGRect frame = _imageView.frame;
    frame.origin = CGPointMake(0, y);
    _imageView.frame = frame;
    
    CGFloat yDiff = abs((y + _imageView.frame.size.height/2) - windowSize.height/2);
    _blackMask.alpha = MAX(1 - yDiff/(windowSize.height/2),kMinBlackMaskAlpha);
    
    if ((panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) && _scrollView.zoomScale == 1.0f) {
        
        if(_blackMask.alpha < 0.7) {
            [self dismissViewController];
        }else {
            [self rollbackViewController];
        }
    }
}

#pragma mark - Show
- (void)presentFromRootViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self presentFromViewController:rootViewController];
}

- (void)presentFromViewController:(UIViewController *)controller
{
    _rootViewController = controller;
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    [self didMoveToParentViewController:controller];
}

#pragma mark - Just Rollback
- (void)rollbackViewController
{
    _isAnimating = YES;
    [UIView animateWithDuration:0.2f delay:0.0f options:0 animations:^{
        _imageView.frame = [self centerFrameFromImage:_imageView.image];
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
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        _imageView.clipsToBounds = YES;
        [UIView animateWithDuration:0.2f delay:0.0f options:0 animations:^{
            _imageView.frame = _originalFrameRelativeToScreen;
            CGAffineTransform transf = CGAffineTransformIdentity;
            rootViewController.view.transform = CGAffineTransformScale(transf, 1.0f, 1.0f);
            self.view.transform = CGAffineTransformScale(transf, 1.0f, 1.0f);
            _blackMask.alpha = 0.0f;
        }   completion:^(BOOL finished) {
            if (finished) {
                
                [self.view removeFromSuperview];
                [self removeFromParentViewController];
                [_superView addSubview:_senderView ];
                [UIApplication sharedApplication].statusBarHidden = NO;
                _isAnimating =NO;
                if(_closingBlock)
                    _closingBlock();
                
            }
        }];
    });
}

- (void)close:(UIButton *)sender {
    [sender removeFromSuperview];
    [self dismissViewController];
}


# pragma mark - UIScrollView Delegate
- (void)centerScrollViewContents {
    CGSize boundsSize = self.view.bounds.size;
    CGRect contentsFrame = _imageView.frame;
    
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
    
    _imageView.frame = contentsFrame;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    _isAnimating = YES;
    [self hideDoneButton];
    [self centerScrollViewContents];
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    _isAnimating = NO;
}

- (void)addMultipleGesture {
    UITapGestureRecognizer *twoFingerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTwoFingerTap:)];
    twoFingerTapGesture.numberOfTapsRequired = 1;
    twoFingerTapGesture.numberOfTouchesRequired = 2;
    [_scrollView addGestureRecognizer:twoFingerTapGesture];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:singleTapRecognizer];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDobleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:doubleTapRecognizer];
    
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    
    _scrollView.minimumZoomScale = kMinImageScale;
    _scrollView.maximumZoomScale = kMaxImageScale;
    _scrollView.zoomScale = 1;
    [self centerScrollViewContents];
}

#pragma mark - For Zooming
- (void)didTwoFingerTap:(UITapGestureRecognizer*)recognizer {
    
    CGFloat newZoomScale = _scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, _scrollView.minimumZoomScale);
    [_scrollView setZoomScale:newZoomScale animated:YES];
}

#pragma mark - Showing of Done Button if ever Zoom Scale is equal to 1
- (void)didSingleTap:(UITapGestureRecognizer*)recognizer {
    if(_doneButton.superview){
        [self hideDoneButton];
    }else {
        if(_scrollView.zoomScale == _scrollView.minimumZoomScale){
            if(!_isDoneAnimating){
                _isDoneAnimating = YES;
                [self.view addSubview:_doneButton];
                _doneButton.alpha = 0.0f;
                [UIView animateWithDuration:0.2f animations:^{
                    _doneButton.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    [self.view bringSubviewToFront:_doneButton];
                    _isDoneAnimating = NO;
                }];
            }
        }else if(_scrollView.zoomScale == _scrollView.maximumZoomScale) {
            CGPoint pointInView = [recognizer locationInView:_imageView];
            [self zoomInZoomOut:pointInView];
        }
    }
}

#pragma mark - Zoom in or Zoom out
- (void)didDobleTap:(UITapGestureRecognizer*)recognizer {
    CGPoint pointInView = [recognizer locationInView:_imageView];
    [self zoomInZoomOut:pointInView];
}

- (void) zoomInZoomOut:(CGPoint)point {
    // Check if current Zoom Scale is greater than half of max scale then reduce zoom and vice versa
    CGFloat newZoomScale = _scrollView.zoomScale > (_scrollView.maximumZoomScale/2)?_scrollView.minimumZoomScale:_scrollView.maximumZoomScale;
    
    CGSize scrollViewSize = _scrollView.bounds.size;
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = point.x - (w / 2.0f);
    CGFloat y = point.y - (h / 2.0f);
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    [_scrollView zoomToRect:rectToZoomTo animated:YES];
}

#pragma mark - Hide the Done Button
- (void) hideDoneButton {
    if(!_isDoneAnimating){
        if(_doneButton.superview) {
            _isDoneAnimating = YES;
            _doneButton.alpha = 1.0f;
            [UIView animateWithDuration:0.2f animations:^{
                _doneButton.alpha = 0.0f;
            } completion:^(BOOL finished) {
                _isDoneAnimating = NO;
                [_doneButton removeFromSuperview];
            }];
        }
    }
}


- (void) dealloc {
    _gestures  = nil;
    _blackMask = nil;
    _imageView = nil;
    _scrollView = nil;
    _doneButton = nil;
    _superView = nil;
    _imageURL = nil;
    _senderView = nil;
    _rootViewController = nil;
}

@end


#pragma mark - Custom Gesture Recognizer that will Handle imageURL
@interface MHFacebookImageViewerTapGestureRecognizer : UITapGestureRecognizer
@property(nonatomic,strong) NSURL * imageURL;
@property(nonatomic,weak) MHFacebookImageViewerOpeningBlock openingBlock;
@property(nonatomic,weak) MHFacebookImageViewerClosingBlock closingBlock;

@end

@implementation MHFacebookImageViewerTapGestureRecognizer
@synthesize imageURL;
@synthesize openingBlock;
@synthesize closingBlock;
@end

@interface UIImageView()<UITabBarControllerDelegate>

@end
#pragma mark - UIImageView Category
@implementation UIImageView (MHFacebookImageViewer)

#pragma mark - Initializer for UIImageView
- (void) setupImageViewer {
    [self setupImageViewerWithCompletionOnOpen:nil onClose:nil];
}

- (void) setupImageViewerWithCompletionOnOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close {
    [self setupImageViewerWithImageURL:nil onOpen:open onClose:close];
}

- (void) setupImageViewerWithImageURL:(NSURL*)url {
    [self setupImageViewerWithImageURL:url onOpen:nil onClose:nil];
}

- (void) setupImageViewerWithImageURL:(NSURL *)url onOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close{
    self.userInteractionEnabled = YES;
    MHFacebookImageViewerTapGestureRecognizer *  tapGesture = [[MHFacebookImageViewerTapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tapGesture.imageURL = url;
    tapGesture.openingBlock = open;
    tapGesture.closingBlock = close;
    [self addGestureRecognizer:tapGesture];
    tapGesture = nil;
}

#pragma mark - Handle Tap
- (void) didTap:(MHFacebookImageViewerTapGestureRecognizer*)gestureRecognizer {
    
    MHFacebookImageViewer * imageBrowser = [[MHFacebookImageViewer alloc]init];
    imageBrowser.senderView = self;
    imageBrowser.imageURL = gestureRecognizer.imageURL;
    imageBrowser.openingBlock = gestureRecognizer.openingBlock;
    imageBrowser.closingBlock = gestureRecognizer.closingBlock;
    if(self.image)
        [imageBrowser presentFromRootViewController];
}
@end
