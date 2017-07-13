//
//  ViewController.m
//  MWFontVariationsDemo
//
//  Created by Martin Winter on 13.07.17.
//  Copyright © 2017 Martin Winter Ltd. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>


@interface ViewController ()

@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSSlider *weightSlider;
@property (weak) IBOutlet NSSlider *widthSlider;

@property (nonatomic) CGFloat weight;
@property (nonatomic) CGFloat width;

@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSFont *font = [NSFont fontWithName:@"Skia" size:200];
    NSArray *variationAxes = CFBridgingRelease(CTFontCopyVariationAxes((CTFontRef)font));
    for (NSDictionary *variationAxis in variationAxes) {
        if ([variationAxis[NSFontVariationAxisNameKey] isEqualToString:@"Weight"]) {
            self.weightSlider.minValue   = ((NSNumber *)variationAxis[NSFontVariationAxisMinimumValueKey]).floatValue;
            self.weightSlider.maxValue   = ((NSNumber *)variationAxis[NSFontVariationAxisMaximumValueKey]).floatValue;
            self.weightSlider.floatValue = ((NSNumber *)variationAxis[NSFontVariationAxisDefaultValueKey]).floatValue;
        }

        if ([variationAxis[NSFontVariationAxisNameKey] isEqualToString:@"Width"]) {
            self.widthSlider.minValue   = ((NSNumber *)variationAxis[NSFontVariationAxisMinimumValueKey]).floatValue;
            self.widthSlider.maxValue   = ((NSNumber *)variationAxis[NSFontVariationAxisMaximumValueKey]).floatValue;
            self.widthSlider.floatValue = ((NSNumber *)variationAxis[NSFontVariationAxisDefaultValueKey]).floatValue;
        }
    }

    self.textView.string = @"Hello";
    [self updateView];
}


- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


#pragma mark -


- (IBAction)handleSliderMoved:(id)sender
{
    [self updateView];
}


- (void)updateView
{
    NSFontDescriptor *descriptor = [NSFontDescriptor fontDescriptorWithFontAttributes:@{NSFontNameAttribute: @"Skia",
                                                                                        NSFontVariationAttribute: @{@"Weight": @(self.weight),
                                                                                                                    @"Width":  @(self.width)}}];
    NSFont *font = [NSFont fontWithDescriptor:descriptor size:120.0];
    self.textView.font = font;
}


@end
