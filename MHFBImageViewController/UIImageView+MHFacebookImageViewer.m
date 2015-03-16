//
//  UIImageView+MHFacebookImageViewer.m
//  FBImageViewController_Demo
//
//  Created by Jhonathan Wyterlin on 14/03/15.
//  Copyright (c) 2015 Michael Henry Pantaleon. All rights reserved.
//

#import "UIImageView+MHFacebookImageViewer.h"
#import <objc/runtime.h>
@interface UIImageView()<UITabBarControllerDelegate>

@property (nonatomic, assign) MHFacebookImageViewer *imageBrowser;

@end

static char kImageBrowserKey;

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


- (void) setupImageViewerWithDatasource:(id<MHFacebookImageViewerDatasource>)imageDatasource onOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close {
    [self setupImageViewerWithDatasource:imageDatasource initialIndex:0 onOpen:open onClose:close];
}

- (void) setupImageViewerWithDatasource:(id<MHFacebookImageViewerDatasource>)imageDatasource initialIndex:(NSInteger)initialIndex onOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close{
    self.userInteractionEnabled = YES;
    MHFacebookImageViewerTapGestureRecognizer *  tapGesture = [[MHFacebookImageViewerTapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tapGesture.imageDatasource = imageDatasource;
    tapGesture.openingBlock = open;
    tapGesture.closingBlock = close;
    tapGesture.initialIndex = initialIndex;
    [self addGestureRecognizer:tapGesture];
    tapGesture = nil;
}


#pragma mark - Handle Tap
- (void) didTap:(MHFacebookImageViewerTapGestureRecognizer*)gestureRecognizer {
    
    [self setImageBrowser:[[MHFacebookImageViewer alloc]init]];
    [[self imageBrowser] setSenderView: self];
    [[self imageBrowser] setImageURL:gestureRecognizer.imageURL];
    [[self imageBrowser] setOpeningBlock:gestureRecognizer.openingBlock];
    [[self imageBrowser] setClosingBlock:gestureRecognizer.closingBlock];
    [[self imageBrowser] setImageDatasource:gestureRecognizer.imageDatasource];
    [[self imageBrowser] setInitialIndex:gestureRecognizer.initialIndex];
    
    if(self.image)
        [self.imageBrowser presentFromRootViewController];
}

- (void) dealloc {
    
}

#pragma mark Removal
-(void)removeImageViewer {
    
    [[[self imageBrowser] view] removeFromSuperview];
    [[self imageBrowser] removeFromParentViewController];
    
    for (UIGestureRecognizer * gesture in self.gestureRecognizers) {
        
        if ( [gesture isKindOfClass:[MHFacebookImageViewerTapGestureRecognizer class]] ) {
            
            [self removeGestureRecognizer:gesture];
            
            MHFacebookImageViewerTapGestureRecognizer *  tapGesture = (MHFacebookImageViewerTapGestureRecognizer *)gesture;
            tapGesture.imageURL = nil;
            tapGesture.openingBlock = nil;
            tapGesture.closingBlock = nil;
            
        }
        
    }
    
}

-(void)setImageBrowser:(MHFacebookImageViewer *)imageBrowser {
    objc_setAssociatedObject(self, &kImageBrowserKey, imageBrowser, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(MHFacebookImageViewer *)imageBrowser {
    return objc_getAssociatedObject(self, &kImageBrowserKey);
}

@end
