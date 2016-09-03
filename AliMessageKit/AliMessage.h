//
//  AliMessage.h
//  AliMessage
//
//  Created by VicChan on 16/9/3.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliMessage : NSObject

/// Count of Verification Code default is 6.
@property (nonatomic, assign) NSInteger verifyCodeCount;
/// SMS Template Code the code for your template which was set when you apply for this app.
@property (nonatomic, strong, readwrite) NSString *smsTemplateCode;
/// receiveNumber the user phone number
@property (nonatomic, strong, readwrite) NSString *receiveNumber;
/// SMS Free Sign Name
@property (nonatomic, strong, readwrite) NSString *freeSignName;
/// params for the template sms Message(JSON). (短信模板内容参数)  ‘{"code":"1234","product":"alidayu"}’
@property (nonatomic, strong, readwrite) NSString *smsParam;

/**
 * @return the instance with the default configuration 
 **/
+ (AliMessage *)manager;

- (instancetype)initWithAppKey:(NSString *)appKey appScrect:(NSString *)appScrect;



/**
 * @name    set AppKey and AppScrect
 * @param   appkey
 * @param   appScrect
 **/
- (void)setAppKey:(NSString *)appKey appScrect:(NSString *)appScrect;

/**
 * @name    sendMessage
 * @param   phone
 * @param   block to handle the result of the process
 **/
- (void)sendMessage:(NSString *)phone withBlock:(void (^)(NSString *code, NSString *error))block;
/**
 * @name    set Session String for the request.
 **/
- (void)setSessionString:(NSString *)session;

/**
 * @name    set verification code numbers.
 **/
- (void)setVerifyCodeCount:(NSInteger)verifyCodeCount;

/**
 * @name    check phone available
 * @param   phone
 * @return  YES if the phone is correct or NO
 **/
- (BOOL)checkPhoneAvaiableWith:(NSString *)phone;

/**
 * @name    generate verification code
 * @return  code(String)
 **/
- (NSString *)generateVerifyCode;

@end
