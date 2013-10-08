//
//  DiagonalLineView.m
//  DynamicTest
//
//  Created by Matías Ginart on 05/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import "DiagonalLineView.h"

@implementation DiagonalLineView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    // Dibuja una linea diagonal comenzando arriba a la derecha
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextRef, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(contextRef, 1);
    CGContextMoveToPoint(contextRef, 0, 0);
    CGContextAddLineToPoint(contextRef, self.frame.size.width, self.frame.size.height);
    CGContextStrokePath(contextRef);
}

@end
