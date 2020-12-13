//
//  NSString+PPTextField.m
//  PPDemos
//
//  Created by ╰莪呮想好好宠Nǐつ on 2017/3/19.
//  Copyright © 2017年 PPAbner. All rights reserved.
//

#import "NSString+PPTextField.h"

@implementation NSString (PPTextField)
- (BOOL)pp_is:(PPTextFieldStringType)stringType
{
    return [self matchRegularWith:stringType];
}


- (BOOL)pp_isSpecialLetter
{
    if ([self pp_is:PPTextFieldStringTypeNumber] || [self pp_is:PPTextFieldStringTypeLetter] || [self pp_is:PPTextFieldStringTypeChinese]) {
        return NO;
    }
    return YES;
}

#pragma mark --- 用正则判断条件
- (BOOL)matchRegularWith:(PPTextFieldStringType)type
{
    NSString *regularStr = @"";
    switch (type) {
        case PPTextFieldStringTypeNumber:      //数字
            regularStr = @"^[0-9]*$";
            break;
        case PPTextFieldStringTypeLetter:      //字母
            regularStr = @"^[A-Za-z]+$";
            break;
        case PPTextFieldStringTypeChinese:     //汉字
            regularStr = @"^[\u4e00-\u9fa5]{0,}$";
            break;
        default:
            break;
    }
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularStr];
    
    if ([regextestA evaluateWithObject:self] == YES){
        return YES;
    }
    return NO;
}

- (NSUInteger)pp_lengthForCN2EN1
{
    NSUInteger length = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0 ; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            length++;
        }else {
            p++;
        }
    }
    return length;
}

- (NSString *)pp_removeSpecialLettersExceptLetters:(NSArray<NSString *> *)exceptLetters
{
    if (self.length > 0) {
        NSMutableString *resultStr = [[NSMutableString alloc]init];
        for (int i = 0; i < self.length; i++) {
            NSString *indexStr = [self substringWithRange:NSMakeRange(i, 1)];
            
            if (![indexStr pp_isSpecialLetter] || (exceptLetters && [exceptLetters containsObject:indexStr])) {
                [resultStr appendString:indexStr];
            }
        }
        if (resultStr.length > 0) {
            return resultStr;
        }else{
            return @"";
        }
    }else{
        return @"";
    }
}

@end
