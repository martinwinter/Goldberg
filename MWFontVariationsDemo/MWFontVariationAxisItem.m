//
//  MWFontVariationAxisItem.m
//  MWFontVariationsDemo
//
//  Created by Martin Winter on 13.07.17.
//  Copyright © 2017 Martin Winter Ltd. All rights reserved.
//

#import "MWFontVariationAxisItem.h"


@interface MWFontVariationAxisItem ()

@property (weak) IBOutlet NSTextField *axisNameLabel;
@property (weak) IBOutlet NSSlider *slider;
@property (weak) IBOutlet NSTextField *currentValueField;
@property (weak) IBOutlet NSTextField *minValueField;
@property (weak) IBOutlet NSTextField *maxValueField;
@property (weak) IBOutlet NSTextField *defaultValueField;

@end


@implementation MWFontVariationAxisItem


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
}


- (IBAction)handleControlUpdate:(id)sender
{
    if (self.delegate) {
        [self.delegate controlDidUpdate:self];
    }
}


@end
