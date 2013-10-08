//
//  ViewController.m
//  CoreImageTest
//
//  Created by Matías Ginart on 03/10/13.
//  Copyright (c) 2013 Matías Ginart. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>

@interface ViewController ()
@property (nonatomic, strong) NSArray* allFilters;
@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Create array of the name of the new filters in iOS 7
        self.allFilters = @[@"Original", @"CIQRCodeGenerator", @"CILinearToSRGBToneCurve", @"CIPhotoEffectChrome", @"CIPhotoEffectFade", @"CIPhotoEffectInstant", @"CIPhotoEffectMono", @"CIPhotoEffectNoir", @"CIPhotoEffectProcess", @"CIPhotoEffectTonal", @"CIPhotoEffectTransfer", @"CISRGBToneCurveToLinear", @"CIVignetteEffect"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Change background of picker
    self.pickerView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
}

- (IBAction)showPicker {
    // Change button properties
    [self.pickerButton setTitle:@"Dismiss picker" forState:UIControlStateNormal];
    [self.pickerButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.pickerButton addTarget:self action:@selector(dismissPicker) forControlEvents:UIControlEventTouchUpInside];

    // Show picker
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerView.center = CGPointMake(self.pickerView.center.x, self.view.frame.size.height - self.pickerView.frame.size.height/2);
    }];
}

- (IBAction)dismissPicker {
    // Change button properties
    [self.pickerButton setTitle:@"Show picker" forState:UIControlStateNormal];
    [self.pickerButton removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.pickerButton addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];

    // Dismiss picker
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerView.center = CGPointMake(self.pickerView.center.x, self.view.frame.size.height + self.pickerView.frame.size.height/2);
    }];
}




- (void)applyFilter:(NSString*)filterName {
    // Get the clear image and create a CIImage from it
    UIImage* image = [UIImage imageNamed:@"backgroundImage.jpg"];
    CIImage* ciImage = [[CIImage alloc] initWithImage:image];

    // Create a CIFilter from that image
    CIFilter* filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];

    // Create a context so that we can display the output image
    CIContext* context = [CIContext contextWithOptions:nil];
    CIImage* outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];

    // Show the image in the imageView
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
}

- (void)applyQr:(NSString*)qrString {
    // Transform the string into data and create a filter with it
    NSData* qrData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter* filter = [CIFilter filterWithName:@"CIQRCodeGenerator" keysAndValues:@"inputMessage", qrData, nil];
    [filter setDefaults];

    // Create a context so that we can display the output image
    CIContext* context = [CIContext contextWithOptions:nil];
    CIImage* outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];

    // Show the image in the imageView
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
}

#pragma mark - Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.allFilters.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.allFilters[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        self.imageView.image = [UIImage imageNamed:@"backgroundImage.jpg"];
    } else if (row == 1){
        [self applyQr:@"Alf"];
    } else {
        [self applyFilter:self.allFilters[row]];
    }
}

@end
