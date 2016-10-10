# PPTextField
> 一个属性搞定textfield的各种（纯数字，出数字最大个数，价格，字符串长度【区分中英文，不区分】等）限制

##作用：处理各种烦人的限制

> 在开发中，你是否遇到这样的产品需求：
```
  1> 手机号必须是11位纯数字，多了不能输入
  2> 密码只能是数字和字母
  3> 价格必须保留两位小数，并且用户第一个输入“.”，要变为“0.”，小数点后超过2位不能再输入
  4> 一个中文算2个字符，一个英文算1个字符，合起来不超过10个字符
  5> 不管你中文英文，最多别超过12个字符
```
  等等，每次都是遵循代理，写一大堆代码,今天我把这些都集中起来，整理下，分享出来！
  
##PPTextField简单易用API
```
/** 纯数字 */
@property(nonatomic,assign)BOOL isOnlyNumber;

/** 最多纯数字个数【isOnlyNumber == yes 有效】，比如手机11位，商品条码13位等 【设置了maxNumberCount,就默认 isOnlyNumber = YES】*/
@property(nonatomic,assign)NSInteger maxNumberCount;

/** 价格(只有一个"."，小数点后保留2位小数) */
@property(nonatomic,assign)BOOL isPrice;

/** 价格是否允许以“.”开头，默认是不允许，如果允许，请设置为YES 【设置了isPriceHeaderPoint,就默认 isPrice = YES】*/
@property(nonatomic,assign)BOOL isPriceHeaderPoint;

/** 字符串最大长度（一个中文2个字符，一个英文1个字符【中文输入法下的都算中文】） */
@property(nonatomic,assign)NSInteger maxCharactersLength;

/** tf.text最大长度（不考虑中英文） */
@property(nonatomic,assign)NSInteger maxTextLength;

```
嘿嘿，一切都在不言中！！！
