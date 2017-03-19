//
//  PPTextfield.h
//  PPDemos
//
//  Created by Abner on 16/10/9.
//  Copyright © 2016年 PPAbner. All rights reserved.
//

/*
 已知bug:设置maxCharactersLength或者maxTextLength大于0，如果输入达到最大限制，虽然可以输入，但是快速点击键盘，会替换最后一个字符串
 默认都不能输入特殊字符
 */

#import <UIKit/UIKit.h>

@interface PPTextfield : UITextField

//❶❶❶❶❶❶❶❶---☪☪☪PPTextField is属性设置☪☪☪---❶❶❶❶❶❶❶❶


/**
 【1-001】是否当编辑的时候显示clearButton 默认为yes
 */
@property(nonatomic,assign)BOOL isClearWhileEditing;
/**
 【1-002】是否可以输入特殊字符 （默认YES，即可以输入）
 */
@property(nonatomic,assign)BOOL isSpecialCharacter;
/**
 【1-003】可以输入的字符串数组 【控制不可以输入特殊字符，但是某个或者某些特殊字符又是可以输入的】
 ☠☠只有当isSpecialCharacter为NO时，有效☠☠
 */
@property(nonatomic,strong)NSArray<NSString *> *canInputCharacters;
/**
 【1-004】不可以输入的字符串数组 【全局限制，没有前提条件】
 */
@property(nonatomic,strong)NSArray<NSString *> *canotInputCharacters;
/**
 【1-005】是否只能输入数字,默认为NO，
 */
@property(nonatomic,assign)BOOL isOnlyNumber;
/**
 【1-006】最多纯数字个数，比如手机11位，商品条码13位等 【
 ☠☠设置了maxNumberCount,就默认 isOnlyNumber = YES☠☠
 */
@property(nonatomic,assign)NSInteger maxNumberCount;
/**
 【1-007】是否是手机号码
 ☠☠设置了isPhoneNumber,就默认 isOnlyNumber = YES && maxNumberCount == 11 ,此时maxTextLength和maxCharactersLength无效☠☠
 */
@property(nonatomic,assign)BOOL isPhoneNumber;

/**
 【1-008】价格(只有一个"."，小数点后保留2位小数)
 
 ◥◤首位不能输入.◥◤
 ◥◤首位输入0，第二位不是.，会自动补充.◥◤
 
 ☠☠如果isPrice==YES,则isOnlyNumber=No,即使isOnlyNumber设置为YES也没用,此时canotInputCharacters无效☠☠
 */
@property(nonatomic,assign)BOOL isPrice;
/**
 【1-009】价格是否允许以“.”开头，默认是不允许，如果允许，请设置为YES
 ☠☠设置了isPriceHeaderPoint,则isPrice = YES,此时canotInputCharacters无效☠☠
 */
@property(nonatomic,assign)BOOL isPriceHeaderPoint;
/**
 【1-010】是不是密码 （默认只能字母和数字）
 */
@property(nonatomic,assign)BOOL isPassword;
/**
 【1-011】密码可以输入的字符串数组  【只有当isPassword为YES时，有效 】
 【控制不可以输入特殊字符，但是某个或者某些特殊字符又是可以输入的】
 */
@property(nonatomic,strong)NSArray<NSString *> *canInputPasswords;
/**
 【1-012】tf.text最大长度（不考虑中英文）
 */
@property(nonatomic,assign)NSInteger maxTextLength;
/**
 【1-013】字符串最大长度（一个中文2个字符，一个英文1个字符【中文输入法下的都算中文】）
 */
@property(nonatomic,assign)NSInteger maxCharactersLength;


//❷❷❷❷❷❷❷❷---☮☮☮PPTextField Block回调☮☮☮---❷❷❷❷❷❷❷❷

/**
 【2-001】文本框字符变动，回调block【实时监测tf的文字】
 */
@property(nonatomic,copy)void(^ppTextfieldTextChangedBlock)(PPTextfield *tf);
/**
 【2-002】结束编辑or失去第一响应，回调block
 */
@property(nonatomic,copy)void(^ppTextFieldEndEditBlock)(PPTextfield *tf);
/**
 【2-003】键盘右下角returnType点击
 */
@property(nonatomic,copy)void(^ppTextFieldReturnTypeBlock)(PPTextfield *tf);


@end

