### PPTextField来由：
> 做项目，经常遇到输入内容的各种限制，说来说去，无非都是UITextField的功能，但是各种限制，不同公司不同要求，不同功能不同要求等等，如果每一次都写一大堆的tf代理方法，配合各种限制、截取，未免有些太过于麻烦，可能自己比较懒不想每次都写（其实跟自己做的项目有关：比如整个界面就是添加商品：**商品名称**`(不能输入特殊字符)`、**商品编码**`(纯数字，必须13位)`、**商品价格**`（第一个字符不能为0，一个小数点，保留2位等）`  **and so on** !），我就想着怎么用一个属性就可以做到，于是在去年10月份写了一个初步的，昨天(`2017-03-18`)刚好最近项目遇到的比较多，自己就又重新整理优化下，于是有了它的更好的成品。
> >各种限制，可以灵活组合，如有问题，欢迎提issue！
#### PPTextField属性S：`（个人觉得表格更好）`
|    属性名    | 属性介绍 |    使用注意   | 
| :-------: | :--- |:----: | 
| **isClearWhileEditing** |  【1-001】是否当编辑的时候显示clearButton 默认为yes | `无` | 
| **isSpecialCharacter**     | 【1-002】是否可以输入特殊字符 （默认YES，即可以输入）  |  `特殊字符：除数字、字母、汉字外的字符`|  
| **canInputCharacters**      | 【1-003】可以输入的字符串数组 【控制不可以输入特殊字符，但是某个或者某些特殊字符又是可以输入的】  |   `☠☠只有当isSpecialCharacter为NO时，有效☠☠ `     | 
| **canotInputCharacters**      | 【1-004】不可以输入的字符串数组   |   `全局限制，没有前提条件 `     |  
| **isOnlyNumber**      | 【1-005】是否只能输入数字,默认为NO  |   `无 `     |  
| **maxNumberCount**      | 【1-006】最多纯数字个数，比如手机11位，商品条码13位等  |   `☠☠设置了maxNumberCount,就默认 isOnlyNumber = YES☠☠ `     |  
| **isPhoneNumber**      | 【1-007】是否是手机号码  |   ` ☠☠设置了isPhoneNumber,就默认 isOnlyNumber = YES && maxNumberCount == 11 ,此时maxTextLength和maxCharactersLength无效☠☠`     |  
| **isPrice**      | 【1-008】价格(只有一个"."，小数点后保留2位小数) ◥◤首位输入0，第二位不是.，会自动补充.◥◤ |   ` ☠☠如果isPrice==YES,则isOnlyNumber=No,即使isOnlyNumber设置为YES也没用,此时canotInputCharacters无效☠☠`     |  
| **isPriceHeaderPoint**      |  【1-009】价格是否允许以“.”开头，默认是不允许，如果允许，请设置为YES  |   ` ☠☠设置了isPriceHeaderPoint,则isPrice = YES,此时canotInputCharacters无效☠☠`     |  
| **isPassword**      | 【1-010】是不是密码 （默认只能字母和数字）  |   `无 `     |  
| **canInputPasswords**      | 【1-011】密码可以输入的字符串数组 【控制不可以输入特殊字符，但是某个或者某些特殊字符又是可以输入的】  |   `☠☠只有当isPassword为YES时，有效 ☠☠ `     |  
| **maxTextLength**      | 【1-012】tf.text最大长度（不考虑中英文）  |   `无 `     |  
| **maxCharactersLength**      | 【1-013】字符串最大长度（一个中文2个字符，一个英文1个字符【中文输入法下的都算中文】）  |   `无 `     |  
| **ppTextfieldTextChangedBlock**      | 【2-001】文本框字符变动，回调block【实时监测tf的文字】  |   ` block回调`     |  
| **ppTextFieldEndEditBlock**      | 【2-002】结束编辑or失去第一响应，回调block  |   `block回调 `     |  
| **ppTextFieldReturnTypeBlock**      | 【2-003】键盘右下角returnType点击  |   `block回调 `     |  

> 稍后会更新demo示例！！！
 
