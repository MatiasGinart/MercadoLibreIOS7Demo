//
//  AmazingPoint.h
//  JSTest
//
//  Created by Matías Ginart on 03/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSPointProtocol.h"

@interface AmazingPoint : NSObject <JSPointProtocol>

- (CGPoint)point;

@end
