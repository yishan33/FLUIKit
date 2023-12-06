//
//  FLTextView.h
//  FLUIKit
//
//  Created by forthonliu on 2023/12/5.
//

#import <UIKit/UIKit.h>

typedef void (^FLTextViewHeightBlock)(CGFloat heigth);

NS_ASSUME_NONNULL_BEGIN

@interface FLTextView : UITextView

@property (nonatomic, copy) NSString *placeholderText;

@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, assign) NSUInteger maxNumberOfLines;

@property (nonatomic, copy) FLTextViewHeightBlock heightWillChangeBlock;

@property (nonatomic, copy) FLTextViewHeightBlock heightDidChangeBlock;

@end

NS_ASSUME_NONNULL_END
