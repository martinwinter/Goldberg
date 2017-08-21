//
//  GoldbergTests.m
//  GoldbergTests
//
//  Created by Martin Winter on 13.07.17.
//  Copyright © 2017 Martin Winter Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreText/CoreText.h>


@interface GoldbergTests : XCTestCase

@end


@implementation GoldbergTests


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testExample
{
    //NSString *fontName = @"Skia";
    NSString *fontName = @"Hoefler Text";
    NSFont *font = [NSFont fontWithName:fontName size:120];
    NSLog(@"font: %@", font);
    NSArray *variationAxes = CFBridgingRelease(CTFontCopyVariationAxes((CTFontRef)font));
    NSLog(@"variationAxes: %@", variationAxes);
}


@end
