# AliMessageKit

**阿里短信验证iOS端**
An Open Source Kit for Ali Dayu SMS Verification 

***
### Getting Started

* **First**

你需要前往[阿里大于](https://www.alidayu.com)去注册申请短信验证。阿里会提供你一个`AppScrect`和`AppKey`，你需要设置你的短信模板，因而你会获得一个`SMS_Template_Code`

* **Second**


*Easy Start*

```
+ (void)sendMessage:(NSString *)phone
         withAppKey:(NSString *)appkey
          appSecret:(NSString *)appSecret
           smsParam:(NSString *)smsParam
    withResultBlock:(void(^)(NSString *code, NSString *error))block;
```
*Or Create an Instance*
	
```
- (instancetype)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret;
```

或者这样：

```
+ (AliMessage *)manager;
- (void)setAppKey:(NSString *)appKey appSecret:(NSString *)appSecret;
```

**Third**
*send the message with the code*

在发送短信之前，你要完成这些工作：

1. 确定`SMS_Param` **JSON格式**，调用`- (NSString *)generateVerifyCode;`获取随机验证码并整合到短信模板参数里.

然后调用`sendMessage` 在回调`block`完成验证工作.


**example**


```
NSString *code = [self generateVerifyCode];
NSString *smsParam = [NSString stringWithFormat:@"{\"code\":\"%@\"}",code];
[manager setSmsParam:smsParam];
[manager sennMessage:.......];
```
****
#### TODO:

* Error Handling 

***

> **如果有任何问题，请issue me**  
> **This project is under the MIT Licence**

