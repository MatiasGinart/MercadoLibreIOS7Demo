//
//  ImageScrollerView.m
//  NSURLSessionTest
//
//  Created by Matías Ginart on 03/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import "ImageScrollerView.h"

@interface ImageScrollerView()
@property (nonatomic, strong) NSMutableArray* allImages;
@end

@implementation ImageScrollerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Creacion del array de imageViews y prendemos el paging de nuestra scrollView
        self.pagingEnabled = YES;
        self.allImages = [NSMutableArray array];

        // Seba programo, y creo un boton
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(10, 30, 80, 40);
        [button addTarget:self action:@selector(hagoBugs) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Seba" forState:UIControlStateNormal];
        [self addSubview:button];
    }
    return self;
}

- (void)addImage:(UIImage*)image {
    // Creamos una nueva UIImageView
    UIImageView* newImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    newImageView.contentMode = UIViewContentModeScaleAspectFit;
    newImageView.image = image;
    // La posicionamos acorde a la derecha de la ultima image view insertada
    newImageView.center = CGPointMake(self.allImages.count * self.frame.size.width + newImageView.frame.size.width/2, newImageView.center.y);

    // La añadimos a nuestro array y la agregamos a nuestra scrollView
    [self.allImages addObject:newImageView];
    [self addSubview:newImageView];
    // Seteamos el nuevo contentSize acorde a la ultima imageView insertada
    self.contentSize = CGSizeMake(newImageView.frame.origin.x + newImageView.frame.size.width, self.frame.size.height);
}

// No Seba, NO!!
- (void)hagoBugs {
    exit(0);
}

@end
