//
//  MWFontVariationAxisItem.h
//  Goldberg
//
//  Created by Martin Winter on 13.07.17.
//  Copyright © 2017 Martin Winter Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class MWFontVariationAxisItem;

@protocol MWFontVariationAxisItemDelegate <NSObject>

- (void)controlDidUpdate:(MWFontVariationAxisItem *)sender;

@end


@interface MWFontVariationAxisItem : NSCollectionViewItem

@property (nonatomic) NSString *axisName;
@property (nonatomic) NSNumber *currentValue;
@property (nonatomic) NSNumber *minValue;
@property (nonatomic) NSNumber *maxValue;
@property (nonatomic) NSNumber *defaultValue;

@property (nonatomic, weak) id<MWFontVariationAxisItemDelegate> delegate;

@end
