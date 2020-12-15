//
//  PPTextFieldAssistant.m
//  PPTextfieldDemo
//
//  Created by PPAbner on 2020/12/11.
//  Copyright © 2020 PPAbner. All rights reserved.
//
/*
 只要方法：
 
 ///主要用来判断可以不可以输入
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
 
 ///处理超过规定后，截取想要的范围！
 - (void)setupLimits:(NSString *)toBeString;
 
 */

#import "PPTextFieldAssistant.h"
#import "NSString+PPTextField.h"
#import "PPTextField.h"

NSString * _Nonnull const PPTFLeterNumber = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
NSString * _Nonnull const PPTFChineseInputMethodIdentifier = @"zh-";

void PPTFLog(NSString *format, ...){
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}

void PPTFLogText(PPTextField *tf){
    PPTFLog(@"tf.text is %@",tf.text);
}

@interface PPTextFieldAssistant ()

@property (nonatomic, assign) BOOL isChineseInput;

///上次回调的tf文字
@property (nonatomic, copy) NSString *lastCallBackTFText;

@end


@implementation PPTextFieldAssistant

#pragma mark --- ☮☮☮UITextfieldDelegate☮☮☮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.tf.didTappedReturnBlock) {
        self.tf.didTappedReturnBlock(self.tf);
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ///必须textFieldShouldEndEditing返回为YES
    if (self.tf.didEndEditingBlock) {
        self.tf.didEndEditingBlock(self.tf);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    ///【注】此方法里面不需要根据字符串最大个数判断是否可以输入,截取方法里面用到，超过了就截取！！！
    
    ///判断输入的是否为数字 (只能输入数字)
    if (_tf.isOnlyNumber) {
        ///如果是数字了，但是该数字包含在数组canotInputCharacters里，同样不能输入
        if ([string pp_is:PPTextFieldStringTypeNumber]) {
            return ![_tf.charactersThatCanotInput containsObject:string];
        }else{
            return NO;
        }
    }
    
    ///密码
    if (_tf.isPassword) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:PPTFLeterNumber] invertedSet];
        NSString *inputStr = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL canInput = [string isEqualToString:inputStr];
        if (canInput) {
            return YES;
        }else{
            return [_tf.passwordsThatCanInput containsObject:string];
        }
    }
    
    ///价格
    ///与_isSpecialCharacter互斥，所以此处必须写，要不走下面的_isSpecialCharacter的判断
    if (_tf.isPrice) {
        return [self limitPriceWithTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    ///特殊字符 【一定要放在该方法最后一个判断，要不会影响哪些它互斥的设置】
    if (!_tf.canInputSpecialCharacter && (_tf.charactersThatCanInput.count > 0 || _tf.passwordsThatCanInput.count > 0)) {
        if ([_tf.charactersThatCanInput containsObject:string] || [_tf.passwordsThatCanInput containsObject:string]) {
            return YES;
        }else{
            if ([string pp_isSpecialLetter] || [_tf.charactersThatCanotInput containsObject:string]) {
                return NO;
            }
            return YES;
        }
    }
    
    return YES;
}



#pragma mark --- getter
+ (PPTextFieldAssistant *)assistant
{
    return [[PPTextFieldAssistant alloc] init];
}

- (UITextInputMode *)currentInputMode
{
    ///[控制textview输入文字个数的方法](http://blog.sina.com.cn/s/blog_1410870560102x0ct.html)
    return [UIApplication sharedApplication].textInputMode;
}

- (BOOL)isChineseInputMethod
{
    NSString *primaryLanguage = self.currentInputMode.primaryLanguage;
    return [primaryLanguage containsString:PPTFChineseInputMethodIdentifier];
}

#pragma mark --- setter
- (void)setTf:(PPTextField *)tf
{
    _tf = tf;
    _tf.delegate = self;
    [_tf addTarget:self action:@selector(textFieldTextEditingChanged) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark --- private method
- (void)textFieldTextEditingChanged
{
    NSString *toBeString = _tf.text;
    UITextRange *markedTextRange = _tf.markedTextRange;
    
    ///中文输入法下
    if (self.isChineseInputMethod) {
        if (markedTextRange) {
            ///如果markedTextRange不为空，说明中文输入中，但是键盘toolBar有字母组合&输入框有字母拼音，
            ///由于现在用户还没有决定选择哪个汉字，所以不做限制，可以随意输入。
        }else{
            ///没有高亮选择的字，则对已输入的文字进行字数统计和限制
            [self setupLimits:toBeString];
        }
    }else{
        [self setupLimits:toBeString];
    }
    
    ///所有都处理完了来回调
    if (_tf.didChangedTextBlock) {
        if (markedTextRange && _tf.didChangedTextBlockTiming == PPTextFieldDidChangedTextBlockTimingWhenDidTappedChinese) {
            return;
        }
        
        if (_lastCallBackTFText &&_tf.text && [_lastCallBackTFText isEqualToString:_tf.text]) {
            ///回调会走2次，所以这里判断一下
        }else{
            if (_tf.isOnDebug) {
                PPTFLogText(_tf);
            }
            _lastCallBackTFText = _tf.text;
            _tf.didChangedTextBlock(_tf);
        }
    }
}

- (void)setupLimits:(NSString *)toBeString
{
    if (toBeString.length == 0) {
        return;
    }
    
    ///价格 【要记得return，不然的话会走（特殊字符处理），这样就把`.`去掉了】
    if (_tf.isPrice) {
        _tf.text = toBeString;
        ///价格要放在【特殊字符处理】前，并且不让再继续下去。
        return;
    }
    
    ///特殊字符处理
    if (!_tf.canInputSpecialCharacter) {
        NSMutableArray *filterArrs;
        if (_tf.charactersThatCanInput.count > 0) {
            filterArrs = [NSMutableArray arrayWithArray:_tf.charactersThatCanInput];
        }else{
            filterArrs = [NSMutableArray array];
        }
        ///要处理
        if (_tf.isPassword && _tf.passwordsThatCanInput.count > 0) {
            [filterArrs addObjectsFromArray:_tf.passwordsThatCanInput];
        }
        _tf.text = [toBeString pp_removeSpecialLettersExceptLetters:filterArrs];
    }
    
    ///☠要放在特殊字符处理后，因为放在前，走特殊字符时，toBeString并没有被裁剪，而self.text又 = toBeString，所以放后面☠
    if (_tf.isOnlyNumber) {
        if ([toBeString pp_is:PPTextFieldStringTypeNumber]) {
            if (_tf.maxTextLength > 0) {
                if (toBeString.length > _tf.maxTextLength) {
                    _tf.text = [toBeString substringToIndex:_tf.maxTextLength];
                }else{
                    _tf.text = toBeString;
                }
            }
        }
    }
    
    if (_tf.maxLengthStyle == PPTextFieldMaxLengthStyleCN2EN1) {
        ///区分中英文
        if (!_tf.isPhoneNumber) {
            NSUInteger length = toBeString.pp_lengthForCN2EN1;
            if (length > _tf.maxTextLength) {
                NSUInteger totalCount = 0;
                for (NSUInteger i = 0; i < toBeString.length; i++) {
                    NSString *str1 = [toBeString substringWithRange:NSMakeRange(i, 1)];
                    BOOL currentIsCN = [str1 pp_is:PPTextFieldStringTypeChinese]; //当前字符是不是中文
                    if (currentIsCN) {
                        totalCount +=2;
                    }else{
                        totalCount +=1;
                    }
                    if (totalCount > _tf.maxTextLength) {
                        _tf.text = [toBeString substringToIndex:i];
                        return;
                    }
                }
            }
        }
    }else{
        ///不区分中英文
        if (_tf.maxTextLength > 0) {
            if (toBeString.length > _tf.maxTextLength) {
                _tf.text = [toBeString substringToIndex:_tf.maxTextLength];
            }
        }
    }
}

- (BOOL)limitPriceWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL hasPoint = YES;
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        hasPoint = NO;
    }
    if ([string length] > 0){
        ///当前输入的字符
        unichar single = [string characterAtIndex:0];
        ///数据格式正确
        if ((single >= '0' && single <= '9') || single == '.') {
            if (_tf.isAllowPricePrefixPoint) {
                ///首字母可以为小数点
                if([textField.text length] == 0){
                    if(single == '.'){
                        //此处强制让textField.text = 0,然后又return YES,这样第一个字符输入`.`，显示的就是`0.`。
                        textField.text = @"0";
                        return YES;
                    }
                }
            }else{
                ///首字母不能为小数点
                if([textField.text length] == 0){
                    if(single == '.'){
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
            }
            
            ///如果开头是`0`，自动添加`.`，则输入框文字为`0.`
            if([textField.text length] == 1 && [textField.text isEqualToString:@"0"]){
                if(single != '.'){
                    textField.text = @"0.";
                    return YES;
                }
            }
            
            ///限制只能输入一个`.`
            if (single == '.'){
                if(hasPoint){
                    ///text中有小数点
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }else{
                    ///text中还没有小数点
                    hasPoint = YES;
                    return YES;
                }
            }else{
                if (hasPoint){
                    ///存在小数点
                    ///判断小数点的位数
                    NSRange pointRange = [textField.text rangeOfString:@"."];
                    NSUInteger pointDigit = range.location - pointRange.location;
                    if (pointDigit <= 2){
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{
            ///输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }else{
        return YES;
    }
}



#ifdef DEBUG
- (void)dealloc
{
    PPTFLog(@"%s",__func__);
}
#endif




@end
