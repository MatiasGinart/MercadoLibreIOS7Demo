//
//  ViewController.m
//  NSURLSessionTest
//
//  Created by Matías Ginart on 03/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import "ViewController.h"
#import "ImageScrollerView.h"
#import "ImageDownloader.h"
#import "AppDelegate.h"

@interface ViewController () <NSURLSessionDownloadDelegate>
@property (nonatomic, strong) ImageScrollerView* imageScrollerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createView];
    //[self callNonBackgroundImageDownloader];
    [self callBackgroundImageDownloader];
}

- (void)createView {
    // Creamos nuestro scrollView de imagenes paginado y lo insertamos en la vista
    self.imageScrollerView = [[ImageScrollerView alloc] initWithFrame:self.view.bounds];
    self.imageScrollerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.imageScrollerView];
}

- (void)didReceiveImageAtPath:(NSURL*)location auxiliarIndex:(NSInteger)index {
    // El NSURLSessionDownloadTask nos devuelve una URL temporaria donde esta la imagen. Si la queremos utilizar, debemos copiarla a otro lado
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docPath = paths[0];
    NSString* filePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.png", index]];
    [[NSFileManager defaultManager] copyItemAtPath:[location path] toPath:filePath error:nil];
    
    // Recordar que no estamos en el main thread, pedimos rescate a GDC para modificar la UI
    dispatch_async(dispatch_get_main_queue(), ^{
        // Creamos una imagen y la mandamos al scroller
        UIImage* image = [UIImage imageWithContentsOfFile:filePath];
        [self.imageScrollerView addImage:image];
    });
}

- (BOOL)shouldAutorotate {
    return NO;
}
















- (void)callNonBackgroundImageDownloader {
    // Del singleton creado, utilizare la NSURLSession
    NSURLSession* aSession = [ImageDownloader sharedImageDownloader].session;

    NSArray* imageUrls = @[@"http://i.qkme.me/3pbzg3.jpg", @"http://img1.mlstatic.com/repuestos-de-toshiba-satellite-a80-mother-con-problemas_MLA-O-131248917_1710.jpg", @"http://t2.gstatic.com/images?q=tbn:ANd9GcT-wQk0CTwl93EmiaUaoIjpMVmwHDNBz_7hN0UNpAz5DCWq66Sp-w", @"http://www.fotos-top.com/items/ferraris-para-fondo-de-pantalla-13626.jpg"];

    // Creare 3 conexiones en paralelo con la misma sesion
    for (NSUInteger index = 0; index < imageUrls.count; index++) {
        // Creo un NSURLSessionDownloadTask a partir de una session
        // Utiliza bloques!
        NSURLSessionDownloadTask* downloadTask = [aSession downloadTaskWithURL:[NSURL URLWithString:imageUrls[index]] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if (!error) {
                [self didReceiveImageAtPath:location auxiliarIndex:index];
            } else {
                // Esteee.... Hubo un error
                NSLog(@"Hubo un error");
            }
        }];
        [downloadTask resume];
    }
}














- (void)callBackgroundImageDownloader {
    NSArray* imageUrls = @[@"http://www.psdgraphics.com/file/red-grunge-background.jpg"];

    // Creare conexiones en paralelo, pero con el mismo session
    for (NSUInteger index = 0; index < imageUrls.count; index++) {
        NSURLSessionDownloadTask* downloadTask = [[ImageDownloader sharedImageDownloader] getBackgroundSessionWithURLString:imageUrls[index] delegate:self];
        [downloadTask resume];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    [self didReceiveImageAtPath:location auxiliarIndex:0];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {

}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat percentage = (CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite;
    NSLog(@"Percentage %.0f%%", percentage * 100);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"Hubo un error");
    } else {
        [self checkCompletionHandlerForSession:session];
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
}

- (void)checkCompletionHandlerForSession:(NSURLSession*)session {
    [session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        NSUInteger totalTasksUnfinished = dataTasks.count + uploadTasks.count + downloadTasks.count;
        if (totalTasksUnfinished == 0) {
            AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
            if (appDelegate.backgroundSessionHandler) {
                void (^completionHandler)() = appDelegate.backgroundSessionHandler;
                appDelegate.backgroundSessionHandler = nil;
                completionHandler();
            }
        }
    }];
}

@end
