//
//  MJExtensionConvert.h
//  JsonToModelConverter
//
//  Created by chenjb on 2017/8/22.
//  Copyright © 2017年 chenjb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJExtensionConvert : NSObject

- (void)createHFileWithModelName:(NSString *)modelName dictionary:(NSDictionary *)dictionary;
- (void)createMFileWithModelName:(NSString *)modelName dictionary:(NSDictionary *)dictionary;

@end
