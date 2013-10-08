//
//  ViewController.h
//  CoreImageTest
//
//  Created by Matías Ginart on 03/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) IBOutlet UIButton* pickerButton;
@property (nonatomic, strong) IBOutlet UIPickerView* pickerView;

- (IBAction)showPicker;

@end
