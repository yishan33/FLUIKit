//
//  FLTextView.m
//  FLUIKit
//
//  Created by forthonliu on 2023/12/5.
//

#import "FLTextView.h"

@interface FLTextView () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *placeholderTextView;

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
    [self addSubview:self.placeholderTextView];
    self.maxNumberOfLines = 2;
    self.delegate = self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.placeholderTextView.frame = self.bounds;
}

#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.maxNumberOfCharacter > 0) {
        BOOL isBeyond = textView.text.length + (text.length - range.length) > self.maxNumberOfCharacter;
        if (self.flDelegate && [self.flDelegate respondsToSelector:@selector(beyondMaxCharacterOnTextView:)]) {
            [self.flDelegate beyondMaxCharacterOnTextView:self];
        }
        return !isBeyond;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (!self.text.length || self.text.length == 0) {
        self.placeholderTextView.hidden = NO;
    } else {
        self.placeholderTextView.hidden = YES;
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
    
    if (self.flDelegate && [self.flDelegate respondsToSelector:@selector(onTextView:heightWillChange:)]) {
        [self.flDelegate onTextView:self heightWillChange:height];
    }
    
    if (self.flDelegate && [self.flDelegate respondsToSelector:@selector(onTextView:heightDidChange:)]) {
        [self.flDelegate onTextView:self heightDidChange:height];
    }
}

#pragma mark - Setter

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textViewDidChange:self];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    [super setTextContainerInset:textContainerInset];
    self.placeholderTextView.textContainerInset = textContainerInset;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderTextView.font = font;
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    self.placeholderTextView.text = placeholderText;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.placeholderTextView.textColor = placeholderColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.placeholderTextView.layer.cornerRadius = cornerRadius;
}

#pragma mark - Getter

- (UITextView *)placeholderTextView
{
    if (!_placeholderTextView) {
        _placeholderTextView = [[UITextView alloc] init];
        _placeholderTextView.userInteractionEnabled = NO;
        _placeholderTextView.layer.borderColor = UIColor.clearColor.CGColor;
        _placeholderTextView.layer.borderWidth = 0;
        _placeholderTextView.backgroundColor = UIColor.clearColor;
        
    }
    return _placeholderTextView;
}

- (NSNumber *)originalHeight {
    if (!_originalHeight) {
        [self.superview layoutIfNeeded];
        _originalHeight = @(self.bounds.size.height);
    }
    return _originalHeight;
}
@end
