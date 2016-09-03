//
//  AliMessage.h
//  AliMessage
//
//  Created by VicChan on 16/9/3.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliMessage : NSObject


+ (AliMessage *)manager;

- (instancetype)initWithAppKey:(NSString *)appKey appScrect:(NSString *)appScrect;

- (void)setAppKey:(NSString *)appKey appScrect:(NSString *)appScrect;







- (void)sendMessage:(NSString *)phone withBlock:(void (^)(NSString *code, NSString *error))block;




@end
