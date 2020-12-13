//
//  PPTextField.h
//  PPDemos
//
//  Created by Abner on 16/10/9.
//  Copyright © 2016年 PPAbner. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPTextField;
@class PPTextFieldAssistant;

NS_ASSUME_NONNULL_BEGIN


/*
 支持PPTextFieldDidChangedTextBlockTimingWhenDidTappedChinese的大厂APPs:
 - 微信
 - 微博
 
 支持PPTextFieldDidChangedTextBlockTimingWhenDidTappedChinese的大厂APPs:
 - 抖音 「当我输入bobo时，搜索结果有bobm的，只出现过一次」
   
 ///⚠️九宫格中文⚠️时，控制台打印如下：
 ///原因可参考[iOS 自带九宫格拼音键盘与 Emoji 表情之间的坑](https://kangzubin.com/nine-keyboard-emoji/)
 selectedRange is = <_UITextKitTextRange: 0x600003a0f760> (0, 1)F
 text = a
 selectedRange is = <_UITextKitTextRange: 0x600003a210a0> (0, 1)F
 text = b
 selectedRange is = <_UITextKitTextRange: 0x600003aebc00> (0, 2)F
 text = bm
 selectedRange is = <_UITextKitTextRange: 0x600003aea940> (0, 2)F
 text = bo
 selectedRange is = <_UITextKitTextRange: 0x600003a2c700> (0, 3)F
 text = boa
 selectedRange is = <_UITextKitTextRange: 0x600003a2c3e0> (0, 4)F
 text = bo b
 selectedRange is = <_UITextKitTextRange: 0x600003aff600> (0, 5)F
 text = bo bm
 selectedRange is = <_UITextKitTextRange: 0x600003a0f560> (0, 5)F
 text = bo bo

 */
///tf文字变化回调时机「主要针对中文」
typedef NS_ENUM(NSInteger, PPTextFieldDidChangedTextBlockTiming) {
    PPTextFieldDidChangedTextBlockTimingWhenDidTappedChinese,   ///中文输入，单击中文文字才回调
    PPTextFieldDidChangedTextBlockTimingIfChanged               ///只要改变，就回调
};

typedef NS_ENUM(NSInteger, PPTextFieldMaxLengthStyle) {
    PPTextFieldMaxLengthStyleCN1EN1,   ///不区分中英文
    PPTextFieldMaxLengthStyleCN2EN1    ///一个中文2个字符，一个英文1个字符【中文输入法下的都算中文】
};

typedef void(^PPTextFieldDidChangedTextBlock)(PPTextField *tf);
typedef void(^PPTextFieldDidEndEditingBlock)(PPTextField *tf);
typedef void(^PPTextFieldDidTappedReturnBlock)(PPTextField *tf);

@interface PPTextField : UITextField

#pragma mark --- ❶❶❶❶❶❶❶❶---☪☪☪PPTextField is属性设置☪☪☪---❶❶❶❶❶❶❶❶

///是否开启Debug调试输出
@property (nonatomic, assign) BOOL isOnDebug;

///tf的助手类实例
@property (nonatomic, strong, readonly) PPTextFieldAssistant *assistant;

///是否当编辑的时候显示clearButton，默认为yes。
@property (nonatomic, assign) BOOL isClearWhileEditing;

///字符串最大长度的计算方式。
@property (nonatomic, assign) PPTextFieldMaxLengthStyle maxLengthStyle;

///tf.text最大长度，具体会根据`maxLengthStyle`来计算。
@property (nonatomic, assign) NSUInteger maxTextLength;

///是否可以输入特殊字符，默认YES，即可以输入。
@property (nonatomic, assign) BOOL canInputSpecialCharacter;

///不可以输入的字符串数组，🐖①：全局限制，没有前提条件。
@property (nonatomic, copy, nullable) NSArray<NSString *> *charactersThatCanotInput;

///可以输入的字符串数组 【控制不可以输入特殊字符，但是某个或者某些特殊字符又是可以输入的】。
///⚠️⚠️⚠️只有当canInputSpecialCharacter为NO时，有效。⚠️⚠️⚠️
@property (nonatomic, copy, nullable) NSArray<NSString *> *charactersThatCanInput;

///是否只能输入数字,默认为NO。
@property (nonatomic, assign) BOOL isOnlyNumber;

///是否是手机号码。
/// ☠☠设置了isPhoneNumber,就默认 isOnlyNumber = YES && maxTextLength == 11 ,此时maxTextLength和maxCharactersLength无效☠☠
@property (nonatomic, assign) BOOL isPhoneNumber;

/**
 价格(只有一个"."，小数点后保留2位小数)
 
 ◥◤首位不能输入.◥◤
 ◥◤首位输入0，第二位不是.，会自动补充.◥◤
 
 ☠☠如果isPrice == YES,则isOnlyNumber=No,即使isOnlyNumber设置为YES也没用,此时canotInputCharacters无效☠☠
 */
@property (nonatomic, assign) BOOL isPrice;

///价格是否允许以“.”开头，默认是不允许，如果允许，请设置为YES。
/// ☠☠设置了isAllowPricePrefixPoint，则isPrice = YES,此时canotInputCharacters无效☠☠
@property (nonatomic, assign) BOOL isAllowPricePrefixPoint;

///是不是密码 （默认只能字母和数字）
@property (nonatomic, assign) BOOL isPassword;

///密码可以输入的字符串数组 【控制不可以输入特殊字符，但是某个或者某些特殊字符又是可以输入的】。
///⚠️⚠️⚠️只有当`isPassword`为YES时，有效。⚠️⚠️⚠️
@property (nonatomic, copy, nullable) NSArray<NSString *> *passwordsThatCanInput;

///tf文字变化回调时机「主要针对中文」，默认PPTextFieldDidChangedTextBlockTimingWhenDidTappedChinese。
@property (nonatomic, assign) PPTextFieldDidChangedTextBlockTiming didChangedTextBlockTiming;


#pragma mark --- ❷❷❷❷❷❷❷❷---☮☮☮PPTextField Block回调☮☮☮---❷❷❷❷❷❷❷❷
@property (nonatomic, copy, nullable) PPTextFieldDidChangedTextBlock didChangedTextBlock;
@property (nonatomic, copy, nullable) PPTextFieldDidEndEditingBlock didEndEditingBlock;
@property (nonatomic, copy, nullable) PPTextFieldDidTappedReturnBlock didTappedReturnBlock;

@end

NS_ASSUME_NONNULL_END
