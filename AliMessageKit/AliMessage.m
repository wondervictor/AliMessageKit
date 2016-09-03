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

@property (nonatomic, strong, readwrite) NSString *appScret;

@property (nonatomic, strong, readwrite) NSString *appKey;




@end




static NSString *const method = @"alibaba.aliqin.fc.sms.num.send";

@implementation AliMessage

+ (AliMessage *)manager {
    return [[[self class]alloc]init];
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
