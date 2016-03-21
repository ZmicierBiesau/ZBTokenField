//
//  ZBTokenField.m
//  ZBTokenField
//
//  Created by Źmicier Biesau, based on Amornchai Kanokpullwad project
//  Copyright (c) 2016
//

#import "ZBTokenField.h"



@interface ZBTokenField ()
@property (nonatomic, strong) NSMutableArray *tokenViews;

@end

@implementation ZBTokenField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

#pragma mark -

- (void)setup
{
    self.clipsToBounds = YES;
    [self reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self invalidateIntrinsicContentSize];
    
    NSEnumerator *tokenEnumerator = [self.tokenViews objectEnumerator];
    [self enumerateItemRectsUsingBlock:^(CGRect itemRect) {
        UIView *token = [tokenEnumerator nextObject];
        [token setFrame:itemRect];
    }];
    
}

- (CGSize)intrinsicContentSize
{
    if (!self.tokenViews) {
        return CGSizeZero;
    }
    
    __block CGRect totalRect = CGRectNull;
    [self enumerateItemRectsUsingBlock:^(CGRect itemRect) {
        totalRect = CGRectUnion(itemRect, totalRect);
    }];
    return totalRect.size;
}

#pragma mark - Public

- (void)reloadData
{
    // clear
    for (UIView *view in self.tokenViews) {
        [view removeFromSuperview];
    }
    self.tokenViews = [NSMutableArray array];
    
    if (self.dataSource) {
        NSUInteger count = [self.dataSource numberOfTokenInField:self];
        for (int i = 0 ; i < count ; i++) {
            
            NSArray *nibContents = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"ZBTokenFieldView" owner:self options:nil];
            UIView *targetView = nibContents[0];
            targetView.backgroundColor = [self.dataSource tokenField:self backgroundColorTokenAtIndex:i];
            
            UILabel *label = (UILabel *)[targetView viewWithTag:2];
            UIButton *button = (UIButton *)[targetView viewWithTag:3];
            
            [button addTarget:self action:@selector(tokenDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            label.text = [self.dataSource tokenField:self titleTokenAtIndex:i];
            label.font = [self.dataSource tokenField:self labelFontTokenAtIndex:i];
            label.textColor = [self.dataSource tokenField:self labelColorTokenAtIndex:i];
            CGSize size = [label sizeThatFits:CGSizeMake(1000, 28)];
            targetView.frame = CGRectMake(0, 0, size.width + 40, 28);
            
            CAShapeLayer * maskLayer = [CAShapeLayer layer];
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: targetView.bounds byRoundingCorners:  UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii: (CGSize){targetView.bounds.size.height / 2, targetView.bounds.size.height / 2}].CGPath;
            
            targetView.layer.mask = maskLayer;
            
            targetView.autoresizingMask = UIViewAutoresizingNone;
            [self addSubview:targetView];
            [self.tokenViews addObject:targetView];
        }
    }
    
    [self invalidateIntrinsicContentSize];
}

- (NSUInteger)numberOfToken
{
    return self.tokenViews.count - 1;
}

- (NSUInteger)indexOfTokenView:(UIView *)view
{
    return [self.tokenViews indexOfObject:view];
}

- (void)tokenDeleteButtonPressed:(UIButton *)tokenButton
{
    NSUInteger index = [self indexOfTokenView:tokenButton.superview];
    if (index != NSNotFound) {
        [self.delegate tokenField:self didRemoveTokenAtIndex:index];
        [self reloadData];
    }
}

#pragma mark - Private

- (void)enumerateItemRectsUsingBlock:(void (^)(CGRect itemRect))block
{
    NSUInteger rowCount = 0;
    CGFloat x = 0, y = 0;
    CGFloat margin = 0;
    CGFloat lineHeight = [self.dataSource lineHeightForTokenInField:self];
    
    if ([self.delegate respondsToSelector:@selector(tokenMarginInTokenInField:)]) {
        margin = [self.delegate tokenMarginInTokenInField:self];
    }
    
    for (UIView *token in self.tokenViews) {
        CGFloat width = MAX(CGRectGetWidth(self.bounds), CGRectGetWidth(token.frame));
        CGFloat tokenWidth = MIN(CGRectGetWidth(self.bounds), CGRectGetWidth(token.frame));
        if (x > width - tokenWidth) {
            y += lineHeight + margin;
            x = 0;
            rowCount = 0;
        }
        
        block((CGRect){x, y, tokenWidth, token.frame.size.height});
        x += tokenWidth + margin;
        rowCount++;
    }
}


@end