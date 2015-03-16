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
- (void)removeImageViewer;
@property (retain, nonatomic) MHFacebookImageViewer *imageBrowser;
@end