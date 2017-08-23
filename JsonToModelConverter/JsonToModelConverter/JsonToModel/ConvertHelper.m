//
//  ConvertHelper.m
//  JsonToModelConverter
//
//  Created by chenjb on 2017/8/22.
//  Copyright © 2017年 chenjb. All rights reserved.
//

#import "ConvertHelper.h"
#import "MJExtensionConvert.h"

@implementation ConvertHelper

+ (void)convertWithModelName:(NSString *)modelName dictionary:(NSDictionary *)dictionary type:(ModelType)type {
    ConvertHelper *convertHelper = [[ConvertHelper alloc] init];
    convertHelper.modelName = modelName;
    convertHelper.dictionary = dictionary;
    convertHelper.modelType = type;
    [convertHelper convert];
}

+ (void)convertWithModelName:(NSString *)modelName array:(NSArray *)array type:(ModelType)type {
    NSDictionary *subobject = nil;
    
    for (id object in array) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            if (!subobject) {
                subobject = object;
            }else if (subobject && ((NSDictionary *)object).count > subobject.count) {
                subobject = object;
            }
        }
    }
    
    if (subobject) {
        [ConvertHelper convertWithModelName:modelName dictionary:subobject type:type];
    }
}

- (void)convert {
    if (!self.modelName || !self.dictionary || ![self.dictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    if (self.modelType == MJEXTENSION) { // mjextension
        [self mjExtensionConvert];
    }
}

- (void)mjExtensionConvert {
    // create .h .m file
    MJExtensionConvert *mjExtensionConvert = [[MJExtensionConvert alloc] init];
    [mjExtensionConvert createHFileWithModelName:self.modelName dictionary:self.dictionary];
    [mjExtensionConvert createMFileWithModelName:self.modelName dictionary:self.dictionary];
}
@end
