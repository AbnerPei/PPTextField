//
//  PPTextfield.m
//  PPDemos
//
//  Created by Abner on 16/10/9.
//  Copyright © 2016年 PPAbner. All rights reserved.
//
/*
   只要方法：
      法1> 主要用来判断可以不可以输入
      法2> 处理超过规定后，截取想要的范围！
 
   - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
 
   -(void)setupLimits:(NSString *)toBeString;
 
 */

#import "PPTextfield.h"
#define kNumbersPeriod  @"0123456789."

@interface PPTextfield ()

@end
@implementation PPTextfield
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = (id<UITextFieldDelegate>)self;
        self.autocorrectionType = UITextAutocorrectionTypeNo;//不自动提示
        [self pp_addTargetEditingChanged];
        _isPriceHeaderPoint = NO;

    }
    return self;
}

-(void)awakeFromNib
{
    self.delegate = (id<UITextFieldDelegate>)self;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    [self pp_addTargetEditingChanged];
    _isPriceHeaderPoint = NO;
}

-(void)setIsOnlyNumber:(BOOL)isOnlyNumber
{
    _isOnlyNumber = isOnlyNumber;
    if (_isOnlyNumber) {
        _isPrice = NO;
    }
    self.keyboardType = UIKeyboardTypeNumberPad;
    
}
-(void)setMaxNumberCount:(NSInteger)maxNumberCount
{
    _isOnlyNumber = YES;
    _maxNumberCount = maxNumberCount;
    self.keyboardType = UIKeyboardTypeNumberPad;
}

-(void)setIsPrice:(BOOL)isPrice
{
    _isPrice = isPrice;
    //防止冲突
    if (_isPrice) {
         _isOnlyNumber = NO;
    }
   
    self.keyboardType = UIKeyboardTypeDecimalPad;
}
-(void)setIsPriceHeaderPoint:(BOOL)isPriceHeaderPoint
{
    _isPriceHeaderPoint = isPriceHeaderPoint;
    _isPrice = YES;
    self.keyboardType = UIKeyboardTypeDecimalPad;
}

-(void)setMaxCharactersLength:(NSInteger)maxCharactersLength
{
    _maxCharactersLength = maxCharactersLength;
    //防止冲突（也仅仅是最大字符串的中英限制）
    if (_maxCharactersLength > 0) {
        _maxTextLength = 0;
    }
}
-(void)setMaxTextLength:(NSInteger)maxTextLength
{
    _maxTextLength = maxTextLength;
    if (_maxTextLength > 0) {
        _maxCharactersLength = 0;
    }
}



#pragma mark --- UITextfieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //  判断输入的是否为数字 (只能输入数字)
    if (_isOnlyNumber) {
        return [PPTFTool isNumber:string];
    }
    //价格
    if (_isPrice) {
        //开头处理
        if (!_isPriceHeaderPoint) {
            if (textField.text.length == 0) {
                if ([string isEqualToString:@"."]) {
                    textField.text = @"0.";
                }
            }
        }
        return [self limitTwoAfterPoint:string textField:textField range:range];
    }
    
    return YES;
}
#pragma mark --- 小数点后限制两位
-(BOOL)limitTwoAfterPoint:(NSString *)string textField:(UITextField *)textField range:(NSRange)range
{
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbersPeriod] invertedSet];
    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    if (basic) {
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        
        NSInteger flag=0;
        
        const NSInteger limited = 2;//小数点后需要限制的个数
        
        for (int i = (int)futureString.length-1; i>=0; i--) {
            if ([futureString characterAtIndex:i] == '.') {
                
                if (flag > limited) {
                    return NO;
                }
                break;
            }
            flag++;
        }
        
        return YES;
    }else{
        return NO;
    }
}

- (void)pp_addTargetEditingChanged
{
    [self addTarget:self action:@selector(textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextLengthLimit:(id)sender
{
    
    //价格限制一个“.”，微信和支付宝转账都可以“.”开头
    if (_isPrice) {
        [PPTFTool limitedPointOnlyOne:self];
    }
    
    bool isChinese;//判断当前输入法是否是中文
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    //[[UITextInputMode currentInputMode] primaryLanguage]，废弃的方法
    if ([current.primaryLanguage isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    
    if(sender == self) {
        NSString *toBeString = self.text;
        if (isChinese) { //中文输入法下
            UITextRange *selectedRange = [self markedTextRange];
            //获取高亮部分
            UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                [self setupLimits:toBeString];
            }
        }else{
            [self setupLimits:toBeString];
        }
    }
}

-(void)setupLimits:(NSString *)toBeString
{
    //纯数字限制：如果限制最大个数大于0，就配置_maxNumberCount，不允许多输入
    if (_isOnlyNumber) {
        if ([PPTFTool isNumber:toBeString]) {
            if (_maxNumberCount > 0) {
                if (toBeString.length > _maxNumberCount) {
                    self.text = [toBeString substringToIndex:_maxNumberCount];
                }
            }else{
                
            }
        }
    }
    
    //区分中英文
    if (_maxCharactersLength > 0) {
        int totalCountAll = [PPTFTool countTheStrLength:toBeString];
        if (totalCountAll > _maxCharactersLength) {
            int totalCount = 0;
            for (int i = 0; i < toBeString.length; i++) {
                NSString *str1 = [toBeString substringWithRange:NSMakeRange(i, 1)];
                BOOL currentIsCN = [PPTFTool isChinese:str1]; //当前字符是不是中文
                if (currentIsCN) {
                    totalCount +=2;
                }else{
                    totalCount +=1;
                }
#warning pp -2016--10-09
                //点击过快，会替换到最后一个字符串？？？为啥？？
                if (totalCount > _maxCharactersLength) {
                    self.text = [toBeString substringToIndex:i];
                    return;
                }
            }
        }
    }
    
    //不区分中英文
    if (_maxTextLength > 0) {
        if (toBeString.length > _maxTextLength) {
            self.text = [toBeString substringToIndex:_maxTextLength];
        }
    }
   
}

@end


//-----------------------


@implementation PPTFTool

+(BOOL)isChinese:(NSString*)c
{
    int strlength = 0;
    char* p = (char*)[c cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[c lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return ((strlength/2)==1)?YES:NO;
}

+(int)countTheStrLength:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

+ (void)limitedPointOnlyOne:(UITextField *)tf
{
    NSString *newStr = tf.text;
    NSString *temp = nil;
    int commonWordCount = 0;
    for(int i =0; i < [newStr length]; i++)
    {
        temp = [newStr substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:@"."]) {
            commonWordCount++;
            if (commonWordCount >= 2) {
                newStr = [newStr substringToIndex:newStr.length-1];
                tf.text = newStr;
            }
        }
        
    }
}

+(BOOL)isNumber:(NSString *)str
{
    NSString *validRegEx =@"^[0-9]*$";
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:str];
    if (myStringMatchesRegEx){
        return YES;
    }else{
        return NO;
    }
}
@end
