//
//  ConvertHelper.h
//  JsonToModelConverter
//
//  Created by chenjb on 2017/8/22.
//  Copyright © 2017年 chenjb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MJEXTENSION
} ModelType;

@interface ConvertHelper : NSObject

@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, assign) ModelType modelType;

- (void)convert;

+ (void)convertWithModelName:(NSString *)modelName dictionary:(NSDictionary *)dictionary type:(ModelType)type;
+ (void)convertWithModelName:(NSString *)modelName array:(NSArray *)array type:(ModelType)type;

@end
