//
//  FLTextView.h
//  FLUIKit
//
//  Created by forthonliu on 2023/12/5.
//

#import <UIKit/UIKit.h>

typedef void (^FLTextViewHeightBlock)(CGFloat heigth);

@class FLTextView;

@protocol FLTextViewDelegate <NSObject>

- (void)onTextView:(FLTextView *)textView heightWillChange:(CGFloat)height;

- (void)onTextView:(FLTextView *)textView heightDidChange:(CGFloat)height;

- (void)beyondMaxCharacterOnTextView:(FLTextView *)textView;

@end

@interface FLTextView : UITextView

@property (nonatomic, weak) id<FLTextViewDelegate>flDelegate;

@property (nonatomic, copy) NSString *placeholderText;

@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, assign) NSUInteger maxNumberOfLines;

@property (nonatomic, assign) NSUInteger maxNumberOfCharacter;

@property (nonatomic, assign) CGFloat cornerRadius;

@end
