//
//  ImageDownloader.m
//  NSURLSessionTest
//
//  Created by Matías Ginart on 03/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import "ImageDownloader.h"

@interface ImageDownloader()
@property (nonatomic, strong) NSURLSession* backgroundSession;
@end

@implementation ImageDownloader

ImageDownloader* ImageDownloaderSharedObject;

+ (instancetype)sharedImageDownloader {
    // Creo la instancia del singleton
    @synchronized(self) {
        if (!ImageDownloaderSharedObject) {
            ImageDownloaderSharedObject = [[[self class] alloc] init];
        }
        return ImageDownloaderSharedObject;
    }
}

- (id)init {
    if (self = [super init]) {
        // Al crearse, creo la sesion. No la volvere a crear nunca mas
        [self createNormalSession];
    }
    return self;
}

- (void)createNormalSession {
    // Creo una configuracion para la sesion
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    configuration.timeoutIntervalForRequest = 30;
    configuration.timeoutIntervalForResource = 3000;
    // Creo la sesion para esa configuracion
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
}

- (void)createBackgroundSessionWithDelegate:(id<NSURLSessionDownloadDelegate>)delegate {
    if (!self.backgroundSession) {
        // Creo una configuracion del tipo background que tiene asociada un id
        NSURLSessionConfiguration* backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"identificador"];
        // Creo una sesion
        self.backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfiguration delegate:delegate delegateQueue:nil];
    }
}

- (NSURLSessionDownloadTask*)getBackgroundSessionWithURLString:(NSString*)urlString delegate:(id<NSURLSessionDownloadDelegate>)delegate {
    [self createBackgroundSessionWithDelegate:delegate];
    // Creo un NSURLRequest
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    // Creo un downloadTask y lo devuelvo
    return [self.backgroundSession downloadTaskWithRequest:request];
}

@end
