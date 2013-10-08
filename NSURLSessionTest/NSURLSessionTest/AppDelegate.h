//
//  AppDelegate.h
//  NSURLSessionTest
//
//  Created by Matías Ginart on 03/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, copy) void (^backgroundSessionHandler)();
@property (strong, nonatomic) UIWindow *window;

@end
