//
//  NSString+JsonToObject.m
//  JsonToModelConverter
//
//  Created by chenjb on 2017/8/22.
//  Copyright © 2017年 chenjb. All rights reserved.
//

#import "NSString+JsonToObject.h"

@implementation NSString (JsonToObject)

- (NSDictionary *)jsonToDictionary {
    if (!self || self == (id)kCFNull) {
        return nil;
    }
    
    NSDictionary *dic = nil;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        
        if (![dic isKindOfClass:[NSDictionary class]]) {
            dic = nil;
        }
    }
    
    return dic;
}

- (NSArray *)jsonToArray {
    if (!self || self == (id)kCFNull) {
        return nil;
    }
    
    NSArray *arr = nil;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    if (jsonData) {
        arr = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        
        if (![arr isKindOfClass:[NSArray class]]) {
            arr = nil;
        }
    }
    
    return arr;
}

@end
