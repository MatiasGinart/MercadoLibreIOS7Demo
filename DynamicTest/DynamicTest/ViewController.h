//
//  ViewController.h
//  DynamicTest
//
//  Created by Matías Ginart on 04/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiagonalLineView.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton* pickerButton;
@property (nonatomic, strong) IBOutlet UILabel* workingLabel;
// View where i will be doing the animations
@property (nonatomic, strong) IBOutlet UIView* referenceView;
// View that draw a diagonal line
@property (nonatomic, strong) IBOutlet DiagonalLineView* diagonalLineView;

- (IBAction)showPicker;

@end
