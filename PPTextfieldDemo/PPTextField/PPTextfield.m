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
#import "NSString+PPTextField.h"

#define kNumbersPeriod  @"0123456789."
#define kOnlyNumber  @"0123456789"
#define KOnlyCharacter @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define KCharacterNumber @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"



@interface PPTextfield ()

@end
@implementation PPTextfield

-(void)configurePPTextfield
{
    self.delegate = (id<UITextFieldDelegate>)self;
    self.autocorrectionType = UITextAutocorrectionTypeNo;//不自动提示
    [self pp_addTargetEditingChanged];
    [self setupDefaultConfigure];
    
}
#pragma mark --- 配置默认设置
-(void)setupDefaultConfigure
{
    _isOnlyNumber = NO;
    _isPriceHeaderPoint = NO;
    
    //清楚按钮默认设置
    _isClearWhileEditing = YES;
    if (_isClearWhileEditing) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    _isSpecialCharacter = YES;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configurePPTextfield];
    }
    return self;
}
#pragma mark --- 支持xib
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self configurePPTextfield];
}

-(void)setIsClearWhileEditing:(BOOL)isClearWhileEditing
{
    _isClearWhileEditing = isClearWhileEditing;
    if (isClearWhileEditing) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }else{
        self.clearButtonMode = UITextFieldViewModeNever;
    }
}
-(void)setIsSpecialCharacter:(BOOL)isSpecialCharacter
{
    _isSpecialCharacter = isSpecialCharacter;
}
-(void)setCanInputCharacters:(NSArray<NSString *> *)canInputCharacters
{
    //再次说明：当不可以输入特殊字符，但是特殊字符中的某个或某几个又是需要的时，所以前提是不可以输入特殊字符
    _canInputCharacters = canInputCharacters;
    [self setIsSpecialCharacter:NO];
    
}
-(void)setCanotInputCharacters:(NSArray<NSString *> *)canotInputCharacters
{
    _canotInputCharacters = canotInputCharacters;
}

-(void)setIsOnlyNumber:(BOOL)isOnlyNumber
{
    _isOnlyNumber = isOnlyNumber;
    _isSpecialCharacter = NO;
    if (_isOnlyNumber) {
        _isPrice = NO;
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
    
}

-(void)setIsPrice:(BOOL)isPrice
{
    _isPrice = isPrice;
    _isSpecialCharacter = NO;
    if (_canotInputCharacters) {
        _canotInputCharacters = [NSArray array];
    }
    //防止冲突
    if (_isPrice) {
        _isOnlyNumber = NO;
        self.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
}
-(void)setIsPriceHeaderPoint:(BOOL)isPriceHeaderPoint
{
    _isPriceHeaderPoint = isPriceHeaderPoint;
    [self setIsPrice:YES];
}
#pragma mark --- 最大纯数字数量
-(void)setMaxNumberCount:(NSInteger)maxNumberCount
{
    _maxNumberCount = maxNumberCount;
    [self setIsOnlyNumber:YES];
}
#pragma mark ---  电话号码
-(void)setIsPhoneNumber:(BOOL)isPhoneNumber
{
    _isPhoneNumber = isPhoneNumber;
    [self setIsOnlyNumber:YES];
    [self setMaxNumberCount:11];
    
}
#pragma mark --- 是不是密码
-(void)setIsPassword:(BOOL)isPassword
{
    _isPassword = isPassword;
    self.secureTextEntry = YES;
    _isSpecialCharacter = NO;
}
-(void)setCanInputPassword:(NSArray<NSString *> *)canInputPasswords
{
    //再次说明：密码默认只能输入字母和数字，但有时又要可以输入某个或某些非字母或数字的字符，所以前提是（是输入密码）
    _canInputPasswords = canInputPasswords;
    [self setIsPassword:YES];
}

-(void)setMaxCharactersLength:(NSInteger)maxCharactersLength
{
    _maxCharactersLength = maxCharactersLength;
    //说明：maxCharactersLength和maxTextLength互斥，无论谁，都是要判断其值是否大于0，所以，其中一个大于0时，另一个就要为0
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


//===================---☮☮☮UITextfieldDelegate☮☮☮---===================

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.ppTextFieldReturnTypeBlock) {
        self.ppTextFieldReturnTypeBlock(self);
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //必须textFieldShouldEndEditing返回为YES
    if (self.ppTextFieldEndEditBlock) {
        self.ppTextFieldEndEditBlock(self);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //【注】此方法里面不需要根据字符串最大个数判断是否可以输入,截取方法里面用到，超过了就截取！！！
    
    //  判断输入的是否为数字 (只能输入数字)
    if (_isOnlyNumber) {
        //如果是数字了，但是该数字包含在数组canotInputCharacters里，同样不能输入
        if ([string pp_is:PPTextFieldStringTypeNumber]) {
            if ([self.canotInputCharacters containsObject:string]) {
                return NO;
            }else{
                return YES;
            }
        }else{
            return NO;
        }
    }
    
    //密码
    if (_isPassword) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:KCharacterNumber] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL canChange = [string isEqualToString:filtered];
        if (!canChange) {
            if ([self.canInputPasswords containsObject:string]) {
                return YES;
            }
            return NO;
        }else{
            return YES;
        }
    }
    //与_isSpecialCharacter互斥，所以此处必须写，要不走下面的_isSpecialCharacter的判断
    if (_isPrice) {
        return [self limitPriceWithTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    //特殊字符 【一定要放在该方法最后一个判断，要不会影响哪些它互斥的设置】
    if (!_isSpecialCharacter) {
        if ([self.canInputCharacters containsObject:string] ||[self.canInputPasswords containsObject:string]) {
            return YES;
        }else{
            if ([string pp_isSpecialLetter] || [self.canotInputCharacters containsObject:string]) {
                return NO;
            }
            return YES;
        }
    }
    return YES;
}
-(BOOL)limitPriceWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //参考：[UITextField 的限制输入金额(可为小数的正确金额)](http://www.cnblogs.com/fcug/p/5500349.html)
    if (textField.text.length > 10) {
        return range.location < 11;
    }else{
        BOOL isHaveDian = YES;
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            isHaveDian=NO;
        }
        if ([string length] > 0){
            unichar single=[string characterAtIndex:0];//当前输入的字符
            
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {
                if (_isPriceHeaderPoint) {
                    //首字母可以为小数点
                    if([textField.text length]==0){
                        if(single == '.'){
                            NSLog(@"isheder11 %@",textField.text);
                            textField.text = @"0"; //此处强制让textField.text = 0,然后又return YES,这样第一个字符输入.，显示的就是0.
                            NSLog(@"%@",textField.text);
                            
                            return YES;
                            
                        }
                    }
                }
                //首字母不能为小数点
                if([textField.text length]==0){
                    if(single == '.'){
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                        
                    }
                }
                if([textField.text length]==1 && [textField.text isEqualToString:@"0"]){
                    if(single != '.'){
                        textField.text = @"0.";
                        return YES;
                        
                    }
                }
                if (single=='.'){
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian=YES;
                        return YES;
                    }else
                    {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                else
                {
                    if (isHaveDian)//存在小数点
                    {
                        //判断小数点的位数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        NSInteger tt=range.location-ran.location;
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }
                    else
                    {
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }
    }
}


- (void)pp_addTargetEditingChanged
{
    [self addTarget:self action:@selector(textFieldTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextEditingChanged:(id)sender
{
    
    bool isChinese;//判断当前输入法是否是中文
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    //[[UITextInputMode currentInputMode] primaryLanguage]，废弃的方法
    if ([current.primaryLanguage isEqualToString: @"en-US"]) {
        isChinese = false;
    }else{
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
    
    //所有都处理完了来回调
    if (self.ppTextfieldTextChangedBlock) {
        self.ppTextfieldTextChangedBlock(self);
    }
}

-(void)setupLimits:(NSString *)toBeString
{
    if (toBeString.length == 0) {
        return;
    }
    
    //价格 【return 不然的话会走（特殊字符处理），这样就把.去掉了】
    if (_isPrice) {
        self.text = toBeString;
        //价格要放在【特殊字符处理】前，并且不让再继续下去。
        return;
    }
    NSLog(@"price---%@----%@",toBeString,self.text);
    
    
    //特殊字符处理
    if (!_isSpecialCharacter) {
        NSMutableArray *filterArrs = [NSMutableArray arrayWithArray:self.canInputCharacters];
        //要处理
        if (_isPassword && self.canInputPasswords.count > 0) {
            [filterArrs addObjectsFromArray:self.canInputPasswords];
        }
        NSLog(@"phone11 %@---%@",toBeString,self.text);
        self.text = [toBeString pp_removeSpecialLettersExceptLetters:filterArrs];
        NSLog(@"phone22 %@---%@",toBeString,self.text);
        
    }
    
    //纯数字限制：如果限制最大个数大于0，就配置_maxNumberCount，不允许多输入
    //☠要放在特殊字符处理后，因为放在前，走特殊字符时，toBeString并没有被裁剪，而self.text又=toBeString，所以放后面☠
    if (_isOnlyNumber) {
        if ([toBeString pp_is:PPTextFieldStringTypeNumber]) {
            if (_maxNumberCount > 0) {
                if (toBeString.length > _maxNumberCount) {
                    self.text = [toBeString substringToIndex:_maxNumberCount];
                }else{
                    self.text = toBeString;
                }
            }
        }
    }
    
    //区分中英文
    if (_maxCharactersLength > 0) {
        if (!_isPhoneNumber) {  //电话号码时_maxCharactersLength无效
            int totalCountAll = [toBeString pp_getStrLengthWithCh2En1];
            if (totalCountAll > _maxCharactersLength) {
                int totalCount = 0;
                for (int i = 0; i < toBeString.length; i++) {
                    NSString *str1 = [toBeString substringWithRange:NSMakeRange(i, 1)];
                    BOOL currentIsCN = [str1 pp_is:PPTextFieldStringTypeChinese]; //当前字符是不是中文
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
        
    }
    
    //不区分中英文
    if (_maxTextLength > 0) {
        if (!_isPhoneNumber) {  //电话号码时_maxTextLength无效
            if (toBeString.length > _maxTextLength) {
                self.text = [toBeString substringToIndex:_maxTextLength];
            }
        }
        
    }
    
    
    
}

@end

