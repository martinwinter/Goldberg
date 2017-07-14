//
//  ViewController.m
//  Goldberg
//
//  Created by Martin Winter on 13.07.17.
//  Copyright © 2017 Martin Winter Ltd. All rights reserved.
//

#import "ViewController.h"
#import "MWFontVariationAxisItem.h"
#import <CoreText/CoreText.h>


static NSString * const MWFontVariationAxisItemIdentifier  = @"MWFontVariationAxisItemIdentifier";
static NSString * const MWFontVariationAxisCurrentValueKey = @"MWFontVariationAxisCurrentValueKey";


@interface ViewController () <NSCollectionViewDataSource, NSCollectionViewDelegate, MWFontVariationAxisItemDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSCollectionView *collectionView;

@property (nonatomic) NSArray *fontVariationAxes;

@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSFont *font = [NSFont fontWithName:@"Skia" size:200];
    NSArray *fontVariationAxes = CFBridgingRelease(CTFontCopyVariationAxes((CTFontRef)font));

    // Make variation axis dictionaries mutable and add initial current values.
    // TODO: Replace with dedicated model objects.
    NSMutableArray *mutableFontVariationAxes = [NSMutableArray new];
    for (NSDictionary *fontVariationAxis in fontVariationAxes) {
        NSMutableDictionary *mutableFontVariationAxis = [fontVariationAxis mutableCopy];
        mutableFontVariationAxis[MWFontVariationAxisCurrentValueKey] = fontVariationAxis[NSFontVariationAxisDefaultValueKey];
        [mutableFontVariationAxes addObject:mutableFontVariationAxis];
    }

    self.fontVariationAxes = [mutableFontVariationAxes copy];

    self.textView.string = @"Hello";
    [self updateView];
}


- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


#pragma mark -


- (void)updateView
{
    __block NSMutableDictionary *fontVariationAttributes = [NSMutableDictionary new];
    [self.fontVariationAxes enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull fontVariationAxis, NSUInteger idx, BOOL * _Nonnull stop) {
        // TODO: share same model objects between view controller and collection items
        MWFontVariationAxisItem *item = (MWFontVariationAxisItem *)[self.collectionView itemAtIndex:idx];
        if (item) {
            fontVariationAxis[MWFontVariationAxisCurrentValueKey] = item.currentValue;
        }

        fontVariationAttributes[fontVariationAxis[NSFontVariationAxisNameKey]] = fontVariationAxis[MWFontVariationAxisCurrentValueKey];
    }];

    NSFontDescriptor *descriptor = [NSFontDescriptor fontDescriptorWithFontAttributes:@{NSFontNameAttribute:      @"Skia",
                                                                                        NSFontVariationAttribute: fontVariationAttributes}];
    NSFont *font = [NSFont fontWithDescriptor:descriptor size:120.0];
    self.textView.font = font;
}


#pragma mark - NSCollectionViewDataSource


- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fontVariationAxes.count;
}


#pragma mark - NSCollectionViewDelegate


- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView
     itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        NSNib *nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([MWFontVariationAxisItem class]) bundle:nil];
        [collectionView registerNib:nib forItemWithIdentifier:MWFontVariationAxisItemIdentifier];
    });

    MWFontVariationAxisItem *item = [collectionView makeItemWithIdentifier:MWFontVariationAxisItemIdentifier
                                                              forIndexPath:indexPath];
    if (!item) {
        NSLog(@"%s  item == nil", __PRETTY_FUNCTION__);
        return nil;
    }

    NSDictionary *fontVariationAxis = self.fontVariationAxes[[indexPath indexAtPosition:1]];

    item.axisName     = fontVariationAxis[NSFontVariationAxisNameKey];
    item.defaultValue = fontVariationAxis[NSFontVariationAxisDefaultValueKey];
    item.minValue     = fontVariationAxis[NSFontVariationAxisMinimumValueKey];
    item.maxValue     = fontVariationAxis[NSFontVariationAxisMaximumValueKey];
    item.currentValue = fontVariationAxis[MWFontVariationAxisCurrentValueKey];

    item.delegate = self;

    return item;
}


#pragma mark - MWFontVariationAxisItemDelegate


- (void)controlDidUpdate:(MWFontVariationAxisItem *)sender
{
    [self updateView];
}


@end
