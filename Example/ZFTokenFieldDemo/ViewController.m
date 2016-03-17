//
//  ViewController.m
//  ZFTokenFieldDemo
//
//  Created by Źmicier Biesau, based on Amornchai Kanokpullwad project
//  Copyright (c) 2016
//

#import "ViewController.h"
#import "ZBTokenField.h"

@interface ViewController () <ZBTokenFieldDataSource, ZBTokenFieldDelegate>
@property (weak, nonatomic) IBOutlet ZBTokenField *tokenField;
@property (nonatomic, strong) NSMutableArray *tokens;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tokens = [NSMutableArray array];
    
    self.tokenField.dataSource = self;
    self.tokenField.delegate = self;

    [self.tokens addObject:@"name1"];
    [self.tokens addObject:@"name2"];
    [self.tokens addObject:@"name3"];
    [self.tokens addObject:@"name4blame"];
    [self.tokenField reloadData];
    
}

- (IBAction)sendButtonPressed:(id)sender
{
    self.tokens = [NSMutableArray array];
    [self.tokenField reloadData];
}

- (void)tokenDeleteButtonPressed:(UIButton *)tokenButton
{
    NSUInteger index = [self.tokenField indexOfTokenView:tokenButton.superview];
    if (index != NSNotFound) {
        [self.tokens removeObjectAtIndex:index];
        [self.tokenField reloadData];
    }
}

#pragma mark - ZBTokenField DataSource

- (CGFloat)lineHeightForTokenInField:(ZBTokenField *)tokenField
{
    return 40;
}

- (NSUInteger)numberOfTokenInField:(ZBTokenField *)tokenField
{
    return self.tokens.count;
}

- (NSString *)tokenField:(ZBTokenField *)tokenField titleTokenAtIndex:(NSUInteger)index
{
    return self.tokens[index];
}

- (UIFont *)tokenField:(ZBTokenField *)tokenField labelFontTokenAtIndex:(NSUInteger)index
{
    return [UIFont systemFontOfSize:14];
}

- (UIColor *)tokenField:(ZBTokenField *)tokenField labelColorTokenAtIndex:(NSUInteger)index
{
    return [UIColor greenColor];
}

- (UIColor *)tokenField:(ZBTokenField *)tokenField backgroundColorTokenAtIndex:(NSUInteger)index
{
    return [UIColor blueColor];
}

#pragma mark - ZBTokenField Delegate

- (CGFloat)tokenMarginInTokenInField:(ZBTokenField *)tokenField
{
    return 5;
}

- (void)tokenField:(ZBTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
    [self.tokens removeObjectAtIndex:index];
    NSLog(@"Tokens are - %@", self.tokens);
}

@end
