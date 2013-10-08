//
//  JSPointProtocol.h
//  JSTest
//
//  Created by Matías Ginart on 03/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSPointProtocol <NSObject, JSExport>

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

+ (id<JSPointProtocol>)pointWithX:(CGFloat)x andY:(CGFloat)y;

@end
