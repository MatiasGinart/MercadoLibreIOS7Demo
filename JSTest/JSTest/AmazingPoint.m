//
//  AmazingPoint.m
//  JSTest
//
//  Created by Matías Ginart on 03/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import "AmazingPoint.h"

@implementation AmazingPoint

@synthesize x = _x, y = _y;

+ (instancetype)pointWithX:(CGFloat)x andY:(CGFloat)y {
    AmazingPoint* amazingPoint = [[AmazingPoint alloc] init];
    amazingPoint.x = x;
    amazingPoint.y = y;
    return amazingPoint;
}

- (CGPoint)point {
    return CGPointMake(self.x, self.y);
}

@end
