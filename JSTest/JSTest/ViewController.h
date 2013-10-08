//
//  ViewController.h
//  JSTest
//
//  Created by Matías Ginart on 03/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textfield1X;
@property (weak, nonatomic) IBOutlet UITextField *textfield1Y;
@property (weak, nonatomic) IBOutlet UITextField *textfield2X;
@property (weak, nonatomic) IBOutlet UITextField *textfield2Y;


- (IBAction)createPointWithExport;

- (IBAction)createPointWithBlock;

@end
