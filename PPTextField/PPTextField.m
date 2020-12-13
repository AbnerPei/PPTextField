//
//  PPTextField.m
//  PPDemos
//
//  Created by Abner on 16/10/9.
//  Copyright © 2016年 PPAbner. All rights reserved.
//

#import "PPTextField.h"
#import "NSString+PPTextField.h"
#import "PPTextFieldAssistant.h"

@interface PPTextField ()
@property (nonatomic, strong) PPTextFieldAssistant *internalAssistant;
@end


@implementation PPTextField

- (void)configurePPTextField
{
    self.internalAssistant.tf = self;
    self.autocorrectionType = UITextAutocorrectionTypeNo;//不自动提示
    [self setupDefaultConfigure];
    
}

#pragma mark --- 配置默认设置
- (void)setupDefaultConfigure
{
    _canInputSpecialCharacter = YES;
    _isOnlyNumber = NO;
    _isAllowPricePrefixPoint = NO;
    _maxLengthStyle = PPTextFieldMaxLengthStyleCN1EN1;
    _didChangedTextBlockTiming = PPTextFieldDidChangedTextBlockTimingWhenDidTappedChinese;
    _isOnDebug = NO;
    _isClearWhileEditing = YES;
    if (_isClearWhileEditing) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configurePPTextField];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configurePPTextField];
    }
    return self;
}

- (NSString *)text
{
    NSString *tfText = [self valueForKey:@"_text"];
    if (self.assistant.isChineseInputMethod) {
        UITextRange *markedTextRange = self.markedTextRange;
        if (markedTextRange) {
            if (self.didChangedTextBlockTiming == PPTextFieldDidChangedTextBlockTimingWhenDidTappedChinese) {
                NSString *str = [self textInRange:markedTextRange];
                str = [tfText substringWithRange:NSMakeRange(0, tfText.length - str.length)];
                return str;
            }
        }
    }
    return tfText;
}

#pragma mark --- 支持xib
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configurePPTextField];
}

- (void)setIsClearWhileEditing:(BOOL)isClearWhileEditing
{
    _isClearWhileEditing = isClearWhileEditing;
    if (isClearWhileEditing) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }else{
        self.clearButtonMode = UITextFieldViewModeNever;
    }
}


- (void)setCharactersThatCanInput:(NSArray<NSString *> *)charactersThatCanInput
{
    _charactersThatCanInput = charactersThatCanInput;
    ///再次说明：当不可以输入特殊字符，但是特殊字符中的某个或某几个又是需要的时，所以前提是不可以输入特殊字符
    if (charactersThatCanInput.count > 0) {
        _canInputSpecialCharacter = NO;
    }
    
}


- (void)setIsOnlyNumber:(BOOL)isOnlyNumber
{
    _isOnlyNumber = isOnlyNumber;
    _canInputSpecialCharacter = NO;
    if (_isOnlyNumber) {
        _isPrice = NO;
        self.keyboardType = UIKeyboardTypeNumberPad;
        _maxLengthStyle = PPTextFieldMaxLengthStyleCN1EN1;
    }
}

- (void)setIsPrice:(BOOL)isPrice
{
    _isPrice = isPrice;
    _canInputSpecialCharacter = NO;
    ///防止冲突
    if (_isPrice) {
        _isOnlyNumber = NO;
        self.keyboardType = UIKeyboardTypeDecimalPad;
        _maxLengthStyle = PPTextFieldMaxLengthStyleCN1EN1;
    }
    
}

- (void)setIsAllowPricePrefixPoint:(BOOL)isAllowPricePrefixPoint
{
    _isAllowPricePrefixPoint = isAllowPricePrefixPoint;
    [self setIsPrice:YES];
}

#pragma mark ---  电话号码
- (void)setIsPhoneNumber:(BOOL)isPhoneNumber
{
    _isPhoneNumber = isPhoneNumber;
    [self setIsOnlyNumber:YES];
    [self setMaxTextLength:11];
    
}

#pragma mark --- 是不是密码
- (void)setIsPassword:(BOOL)isPassword
{
    _isPassword = isPassword;
    self.secureTextEntry = YES;
    _canInputSpecialCharacter = NO;
}

- (void)setPasswordsThatCanInput:(NSArray<NSString *> *)passwordsThatCanInput
{
    ///再次说明：密码默认只能输入字母和数字，但有时又要可以输入某个或某些非字母或数字的字符，所以前提是（是输入密码）
    _passwordsThatCanInput = passwordsThatCanInput;
    if (passwordsThatCanInput.count > 0) {
        [self setIsPassword:YES];
    }
}


#pragma mark --- getter
- (PPTextFieldAssistant *)assistant
{
    return _internalAssistant;
}

#pragma mark --- lazy load
- (PPTextFieldAssistant *)internalAssistant
{
    if (!_internalAssistant) {
        _internalAssistant = PPTextFieldAssistant.assistant;
    }
    return _internalAssistant;
}


#ifdef DEBUG
- (void)dealloc
{
    PPTFLog(@"%s",__func__);
}
#endif

@end

