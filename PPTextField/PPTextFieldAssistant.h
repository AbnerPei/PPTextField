//
//  PPTextFieldAssistant.h
//  PPTextfieldDemo
//
//  Created by PPAbner on 2020/12/11.
//  Copyright © 2020 PPAbner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PPTextField;

NS_ASSUME_NONNULL_BEGIN

///字母和数字
extern NSString * _Nonnull const PPTFLeterNumber;

///中文输入法标示符「@"zh-"」
///zh-Hans ： 中文简体
///zh-Hant ： 中文繁体
extern NSString * _Nonnull const PPTFChineseInputMethodIdentifier;

void PPTFLog(NSString *format, ...);
void PPTFLogText(PPTextField *tf);


@interface PPTextFieldAssistant : NSObject<UITextFieldDelegate>

@property (nonatomic, strong, class, readonly) PPTextFieldAssistant *assistant;

@property (nonatomic, unsafe_unretained, nullable) PPTextField *tf;

///是否是中文输入法
@property (nonatomic, assign, readonly) BOOL isChineseInputMethod;

@end

NS_ASSUME_NONNULL_END
