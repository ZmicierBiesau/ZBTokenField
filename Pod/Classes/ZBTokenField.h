//
//  ZBTokenField.h
//  ZBTokenField
//
//  Created by Źmicier Biesau, based on Amornchai Kanokpullwad project
//  Copyright (c) 2016
//

#import <UIKit/UIKit.h>

@class ZBTokenField;

@protocol ZBTokenFieldDataSource <NSObject>
@required
- (CGFloat)heightForTokenInField:(ZBTokenField *)tokenField;
- (CGFloat)lineHeightForTokenInField:(ZBTokenField *)tokenField;
- (NSUInteger)numberOfTokenInField:(ZBTokenField *)tokenField;
- (NSString *)tokenField:(ZBTokenField *)tokenField titleTokenAtIndex:(NSUInteger)index;
- (UIFont *)tokenField:(ZBTokenField *)tokenField labelFontTokenAtIndex:(NSUInteger)index;
- (UIColor *)tokenField:(ZBTokenField *)tokenField labelColorTokenAtIndex:(NSUInteger)index;
- (UIColor *)tokenField:(ZBTokenField *)tokenField backgroundColorTokenAtIndex:(NSUInteger)index;
@end

@protocol ZBTokenFieldDelegate <NSObject>
@optional
- (CGFloat)tokenMarginInTokenInField:(ZBTokenField *)tokenField;
- (void)tokenField:(ZBTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index;
@end

@interface ZBTokenField : UIControl

@property (nonatomic, weak) IBOutlet id<ZBTokenFieldDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<ZBTokenFieldDelegate> delegate;

- (void)reloadData;
- (NSUInteger)numberOfToken;
- (NSUInteger)indexOfTokenView:(UIView *)view;

@end