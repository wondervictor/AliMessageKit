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
@property (nonatomic, strong, readwrite) NSString *appScret;
/// App Key: the same as App Screct.
@property (nonatomic, strong, readwrite) NSString *appKey;
/// Session for Authorization, optional default is "Session"/
@property (nonatomic, strong, readwrite) NSString *sessionString;
/// SMS Template Code the code for your template which was set when you apply for this app.
@property (nonatomic, strong, readwrite) NSString *smsTemplateCode;
/// receiveNumber the user phone number
@property (nonatomic, strong, readwrite) NSString *receiveNumber;

@end




static NSString *const method = @"alibaba.aliqin.fc.sms.num.send";

@implementation AliMessage

+ (AliMessage *)manager {
    return [[[self class]alloc]init];
}

- (instancetype)initWithDefaultConfiguration {
    self = [super init];
    if (self) {
        self.sessionString = @"session";
        
    }
    return self;
}

- (instancetype)initWithAppKey:(NSString *)appKey appScrect:(NSString *)appScrect {
    self = [super init];
    if (self) {
        self.appKey = appKey;
        self.appScret = appScrect;
    }
    return self;
}

- (void)sendMessage:(NSString *)phone withBlock:(void (^)(NSString *, NSString *))block {
    
    
    
    
    
}

- (BOOL)checkPhoneAvaiableWith:(NSString *)phone {
    

    return NO;
}



- (void)setAppKey:(NSString *)appKey appScrect:(NSString *)appScrect {
    self.appKey = appKey;
    self.appScret = appScrect;
}


- (void)requestWithURLString:(NSString *)urlString withParameters:(NSDictionary *)parameters {
    
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





@end
