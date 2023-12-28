//
//  FLViewController.m
//  FLUIKit
//
//  Created by 021159 on 12/06/2023.
//  Copyright (c) 2023 021159. All rights reserved.
//

#import "FLViewController.h"
#import <FLUIKit/FLTextView.h>
#import <Masonry/Masonry.h>

@interface FLViewController () <FLTextViewDelegate>

@property (nonatomic, strong) UIView *toolView;

@property (nonatomic, strong) FLTextView *textView;

@end

@implementation FLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    CGFloat textViewOriginHeight = 44;
//    FLTextView *inputView = [[FLTextView alloc] initWithFrame:CGRectMake(48, 12, 200, textViewOriginHeight)];
    FLTextView *inputView = [[FLTextView alloc] init];
    inputView.font = [UIFont systemFontOfSize:18];
    inputView.placeholderText =  @"请输入";
    inputView.placeholderColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3];
    inputView.maxNumberOfLines = 3;
    inputView.cornerRadius = 6;
    inputView.textContainerInset = UIEdgeInsetsMake(12, 10, 12, 10);
    inputView.flDelegate = self;

    UIView *toolView = [[UIView alloc] init];
    toolView.backgroundColor = [UIColor.grayColor colorWithAlphaComponent:0.3];
    [self.view addSubview:toolView];
    
    UIButton *switchBtn = [[UIButton alloc] init];
    switchBtn.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    switchBtn.layer.cornerRadius = 6.0;
    [toolView addSubview:switchBtn];

    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-400);
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.height.equalTo(@(textViewOriginHeight + 24));
    }];
    
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toolView).offset(8);
        make.centerY.equalTo(toolView);
        make.size.equalTo(@(CGSizeMake(32, 32)));
    }];
    
    [toolView addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toolView).offset(48);
        make.centerY.equalTo(toolView);
        make.right.equalTo(toolView).offset(-12);
        make.height.equalTo(@(textViewOriginHeight));
    }];
    
    self.toolView = toolView;
    self.textView = inputView;
}

#pragma mark - FLTextViewDelegate

- (void)onTextView:(FLTextView *)textView heightDidChange:(CGFloat)height
{

    NSLog(@"heightDidChange: %@", @(height));
}

- (void)onTextView:(FLTextView *)textView heightWillChange:(CGFloat)height
{
    NSLog(@"heightWillChange: %@", @(height));
    [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(24 + height));
    }];

    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    
    [UIView animateWithDuration:0.25
                     animations:^{
        [self.toolView.superview layoutIfNeeded];
    }];
}

- (void)beyondMaxCharacterOnTextView:(FLTextView *)textView
{
    NSLog(@"超过最大文本输入限制");
}

@end
