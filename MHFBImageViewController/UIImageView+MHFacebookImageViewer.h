//
//  UIImageView+MHFacebookImageViewer.h
//  FBImageViewController_Demo
//
//  Created by Jhonathan Wyterlin on 14/03/15.
//  Copyright (c) 2015 Michael Henry Pantaleon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHFacebookImageViewer.h"

@interface UIImageView (MHFacebookImageViewer)

- (void) setupImageViewer;
- (void) setupImageViewerWithCompletionOnOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close;
- (void) setupImageViewerWithImageURL:(NSURL*)url;
- (void) setupImageViewerWithImageURL:(NSURL *)url onOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close;
- (void) setupImageViewerWithDatasource:(id<MHFacebookImageViewerDatasource>)imageDatasource onOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close;
- (void) setupImageViewerWithDatasource:(id<MHFacebookImageViewerDatasource>)imageDatasource initialIndex:(NSInteger)initialIndex onOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close;

- (void) setupImageViewerWithTapToDismiss:(BOOL)tapToDismiss;
- (void) setupImageViewerWithCompletionOnOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close ifTapToDismiss:(BOOL)tapToDismiss;
- (void) setupImageViewerWithImageURL:(NSURL*)url ifTapToDismiss:(BOOL)tapToDismiss;
- (void) setupImageViewerWithImageURL:(NSURL *)url onOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close ifTapToDismiss:(BOOL)tapToDismiss;
- (void) setupImageViewerWithDatasource:(id<MHFacebookImageViewerDatasource>)imageDatasource onOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close ifTapToDismiss:(BOOL)tapToDismiss;
- (void) setupImageViewerWithDatasource:(id<MHFacebookImageViewerDatasource>)imageDatasource initialIndex:(NSInteger)initialIndex onOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close ifTapToDismiss:(BOOL)tapToDismiss;

- (void)removeImageViewer;
@property (retain, nonatomic) MHFacebookImageViewer *imageBrowser;
@end