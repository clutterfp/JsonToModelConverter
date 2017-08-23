//
//  NSString+JsonToObject.h
//  JsonToModelConverter
//
//  Created by chenjb on 2017/8/22.
//  Copyright © 2017年 chenjb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JsonToObject)

- (NSDictionary *)jsonToDictionary;
- (NSArray *)jsonToArray;

@end
