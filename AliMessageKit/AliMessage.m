//
//  AliMessage.m
//  AliMessage
//
//  Created by VicChan on 16/9/3.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import "AliMessage.h"
#import <CommonCrypto/CommonCrypto.h>

@interface AliMessage()

/// App Screct: Ali will provide you with a screct for this service.
@property (nonatomic, strong, readwrite) NSString *appSecret;
/// App Key: the same as App Screct.
@property (nonatomic, strong, readwrite) NSString *appKey;
/// Session for Authorization, optional default is "Session"/
@property (nonatomic, strong, readwrite) NSString *sessionString;
/// verification code
@property (nonatomic, copy, readwrite) NSString *code;

@end




static NSString *const method = @"alibaba.aliqin.fc.sms.num.send";

@implementation AliMessage


- (instancetype)initWithDefaultConfiguration {
    self = [super init];
    if (self) {
        self.verifyCodeCount = 6;
        self.sessionString = @"session";
    }
    return self;
}


+ (void)sendMessage:(NSString *)phone
                 withAppKey:(NSString *)appkey
                  appSecret:(NSString *)appSecret
                   smsParam:(NSString *)smsParam
            withResultBlock:(void (^)(NSString *, NSString *))block {
    AliMessage *manager = [AliMessage manager];
    manager.appKey = appkey;
    manager.appSecret = appSecret;
    manager.smsParam = smsParam;
    [manager sendMessage:phone withBlock:^(NSString *code, NSString *error) {
        block(code, error);
    }];
}


+ (AliMessage *)manager {
    return [[[self class]alloc]initWithDefaultConfiguration];
}

- (instancetype)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    self = [super init];
    if (self) {
        self.appKey = appKey;
        self.appSecret = appSecret;
    }
    return self;
}

- (void)sendMessage:(NSString *)phone withBlock:(void (^)(NSString *code, NSString *error))block {
    
    if (![self checkPhoneAvaiableWith:phone]) {
        block(nil, @"手机号输入错误");
        return;
    }
    NSString *timestamp = [self getTimestamp];
    NSDictionary *parameters = @{@"format":@"json",
                                 @"v":@"2.0",
                                 @"method":method,
                                 @"app_key":self.appKey,
                                 @"sign_method":@"md5",
                                 @"session":self.sessionString,
                                 @"timestamp":timestamp,
                                 @"sms_type":@"normal",
                                 @"sS":self.freeSignName,
                                 @"sms_param":self.smsParam,
                                 @"rec_num":phone,
                                 @"sms_template_code":self.smsTemplateCode
                                 };
    
    NSString *sign = [self getSignWithDict:parameters];
    NSMutableDictionary *finalParam = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    [finalParam setObject:sign forKey:@"sign"];
    
    NSString *code = self.code;
    
    [self requestWithURLString:@"http://gw.api.taobao.com/router/rest" withParameters:finalParam completition:^(id response, NSError *error) {
        if (error) {
            block(nil, @"网络错误");
            return ;
        }
        NSError *jsonError = nil;
        id responseObj = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError) {
            block(nil, @"解析错误");
            return;
        } else {
            NSDictionary *send_response = [responseObj valueForKey:@"alibaba_aliqin_fc_sms_num_send_response"];
            if (send_response) {
                NSDictionary *result = [send_response valueForKey:@"result"];
                if (result) {
                    NSString *errorCode = [result objectForKey:@"err_code"];
                    if ([errorCode isEqualToString:@"0"]) {
                        block(nil, code);
                    } else {
                        block(nil, @"短信发送失败");
                    }
                } else {
                    block(nil, @"短信发送失败");
                }
            } else {
                block(nil, @"短信发送失败");
            }

        }
    }];
    
}

- (BOOL)checkPhoneAvaiableWith:(NSString *)phone {
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc]initWithPattern:@"^1[0-9]{10}$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *results = [regx matchesInString:phone options:0 range:NSMakeRange(0, phone.length)];
    if (results.count == 0) {
        return NO;
    } else {
        return YES;
    }
}


- (void)setAppKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    self.appKey = appKey;
    self.appSecret = appSecret;
}

/// Network
- (void)requestWithURLString:(NSString *)urlString withParameters:(NSDictionary *)parameters completition:(void(^)(id response, NSError *error))block {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    
    request.HTTPMethod = @"POST";
    
    NSMutableString *query = [NSMutableString new];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        NSString *paramKey = key;
        NSString *paramObj = obj;
        [query appendFormat:@"%@=%@&",paramKey,paramObj];
    }];

    NSData *body = [[query substringToIndex:query.length - 1]dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = body;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        block(data, error);
    }];
    
    [dataTask resume];
    
}

- (NSString *)getTimestamp {
    /// format : yyyy-MM-dd HH:mm:ss
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

/// MD5
- (NSString *)getMD5StringWithString:(NSString *)string {
    const char *pwdString = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(pwdString,(unsigned int)strlen(pwdString),result);
    NSMutableString *output = [NSMutableString stringWithCapacity: 2 * CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ output appendFormat:@"%02x",result[i] ];
    }
    NSString *finnalResults = [NSString stringWithString:output];
    finnalResults = [finnalResults uppercaseString];
    return finnalResults;
}



- (NSString *)getSignWithDict:(NSDictionary *)params  {
    NSMutableString *str = [NSMutableString new];
    NSArray *keys = params.allKeys;
    NSArray *sortKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    for (NSString *key in sortKeys) {
        NSLog(@"%@",key);
        [str appendFormat:@"%@%@",key,[params objectForKey:key]];
    }
    
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@",self.appSecret,str,self.appSecret];
    NSString *sign = [self getMD5StringWithString:signStr];
    return sign;
}


/// generate verification code
- (NSString *)generateVerifyCode {
    NSInteger code = 0;
    for (int i = 0; i < self.verifyCodeCount; i ++) {
        code = code * 10 + arc4random()%10;
    }
    self.code = [NSString stringWithFormat:@"%lu",code];
    return self.code;
}

- (void)setSmsParam:(NSString *)smsParam {
    self.smsParam = smsParam;
}


- (void)setSessionString:(NSString *)session {
    self.sessionString = session;
}

- (void)setVerifyCodeCount:(NSInteger)verifyCodeCount {
    self.verifyCodeCount = verifyCodeCount;
}



@end
