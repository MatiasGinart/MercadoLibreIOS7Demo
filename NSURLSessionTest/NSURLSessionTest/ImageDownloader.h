//
//  ImageDownloader.h
//  NSURLSessionTest
//
//  Created by Matías Ginart on 03/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDownloader : NSObject

@property (nonatomic, strong) NSURLSession* session;

+ (instancetype)sharedImageDownloader;

- (NSURLSessionDownloadTask*)getBackgroundSessionWithURLString:(NSString*)urlString delegate:(id<NSURLSessionDownloadDelegate>)delegate;

@end
