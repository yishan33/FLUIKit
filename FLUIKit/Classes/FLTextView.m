//
//  FLTextView.m
//  FLUIKit
//
//  Created by forthonliu on 2023/12/5.
//

#import "FLTextView.h"

@interface FLTextView () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *placeholderView;

@property (nonatomic, strong) NSNumber *originalHeight;

@end

@implementation FLTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.placeholderView];
    self.maxNumberOfLines = 2;
    self.delegate = self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.placeholderView.frame = self.bounds;
}

#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (!self.text.length || self.text.length == 0) {
        self.placeholderView.hidden = NO;
    } else {
        self.placeholderView.hidden = YES;
    }
    [self updateHight];
}

#pragma mark -

- (void)updateHight
{
    CGFloat maxHeight =  ceil(self.font.lineHeight * self.maxNumberOfLines +  self.textContainerInset.top + self.textContainerInset.bottom);
    CGFloat textHeight = ceil([self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)].height);
    CGFloat originHeight = [self.originalHeight floatValue];
    CGFloat height = 0;
    
    // 设置了最大行数时
    if (self.maxNumberOfLines > 0) {
        NSAssert(originHeight < maxHeight, @"控件最大高度需大于控件原始高度");
        if (textHeight < originHeight) {
            // 内容高度小于控件原始高度时 不可滚动
            height = originHeight;
            self.scrollEnabled = NO;
        } else {
            // 内容高度大于控件原始高度时 内容高度大于最大高度时可滚动
            height = MIN(textHeight, maxHeight);
            self.scrollEnabled = textHeight > maxHeight;
        }
    } else {
        // 无最大行数模式,一直撑大
        self.scrollEnabled = NO;
        height = MAX(textHeight, originHeight);
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    
    if (self.heightWillChangeBlock) {
        self.heightWillChangeBlock(frame.size.height);
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = frame;
    }];
    
    if (self.heightDidChangeBlock) {
        self.heightDidChangeBlock(frame.size.height);
    }
}

#pragma mark - Setter

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderView.font = font;
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    self.placeholderView.text = placeholderText;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.placeholderView.textColor = placeholderColor;
}

#pragma mark - Getter

- (UITextView *)placeholderView
{
    if (!_placeholderView) {
        _placeholderView = [[UITextView alloc] init];
        _placeholderView.userInteractionEnabled = NO;
    }
    return _placeholderView;
}


- (NSNumber *)originalHeight {
    if (!_originalHeight) {
        [self.superview layoutIfNeeded];
        _originalHeight = @(self.bounds.size.height);
    }
    return _originalHeight;
}
@end
