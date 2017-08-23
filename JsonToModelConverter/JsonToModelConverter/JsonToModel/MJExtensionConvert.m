//
//  MJExtensionConvert.m
//  JsonToModelConverter
//
//  Created by chenjb on 2017/8/22.
//  Copyright © 2017年 chenjb. All rights reserved.
//

#import "MJExtensionConvert.h"
#import "ConvertHelper.h"

// if you want your own prefix or suffix,change here
#define Prefix @""
#define Suffix @"Model"

@implementation MJExtensionConvert

#pragma mark - Public Methods
- (void)createHFileWithModelName:(NSString *)modelName dictionary:(NSDictionary *)dictionary {
    NSMutableString *headerFileString = [NSMutableString string];
    
    NSString *fullName = [self fullNameWithModelName:modelName];
    NSString *headerFileName  = [NSString stringWithFormat:@"%@.h", fullName];
    
    NSString *head = \
    [NSString stringWithFormat:@"//\n//  %@.h\n//  JsonToModelConverter\n//\n//  Created by JsonToModelConverter.\n//  Copyright © JsonToModelConverter. All rights reserved.\n//\n\n#import <Foundation/Foundation.h>\n\n@interface %@ : NSObject\n\n",fullName,fullName];
    [headerFileString appendString:head];
    
    // if contains dictionary
    NSMutableString *importString = [NSMutableString string];
    
    NSString *middle = [self getPropertyWithDictionary:dictionary importString:importString];
    [headerFileString appendString:middle];
    
    NSRange range = [headerFileString rangeOfString:@"#import <Foundation/Foundation.h>"];
    NSUInteger index = range.location + range.length;
    [headerFileString insertString:importString atIndex:index];
    
    [headerFileString appendString:@"\n@end\n\n"];
    
    // write file
    [headerFileString writeToFile:[self fullFilePathWithName:headerFileName]
                       atomically:YES
                         encoding:NSUTF8StringEncoding
                            error:nil];
}

- (void)createMFileWithModelName:(NSString *)modelName dictionary:(NSDictionary *)dictionary {
    NSMutableString *implementFileString = [NSMutableString string];
    
    NSString *fullName = [self fullNameWithModelName:modelName];
    NSString *implementFileName  = [NSString stringWithFormat:@"%@.m", fullName];
    
    NSString *head = \
    [NSString stringWithFormat:@"//\n//  %@.m\n//  JsonToModelConverter\n//\n//  Created by JsonToModelConverter.\n//  Copyright © JsonToModelConverter. All rights reserved.\n//\n\n#import \"%@.h\"\n\n@implementation %@\n",fullName,fullName,fullName];
    [implementFileString appendString:head];
    
    NSString *middel = [self getClassInArrayWithDictionary:dictionary];
    if (middel.length) {
        [implementFileString appendString:middel];
    }
    
    [implementFileString appendString:@"\n@end\n\n"];
    
    // write file
    [implementFileString writeToFile:[self fullFilePathWithName:implementFileName]
                       atomically:YES
                         encoding:NSUTF8StringEncoding
                            error:nil];
}

#pragma mark - Private Methods
- (NSString *)getPropertyWithDictionary:(NSDictionary *)dictionary importString:(NSMutableString *)importString {
    NSMutableString *string = [NSMutableString string];
    
    for (id key in dictionary.allKeys) {
        if ([key isKindOfClass:[NSString class]]) {
            if ([dictionary[key] isKindOfClass:[NSString class]]) {
                [string appendString:[NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;\n", key]];
            } else if ([dictionary[key] isKindOfClass:[NSNumber class]]) {
                [string appendString:[NSString stringWithFormat:@"@property (nonatomic, strong) NSNumber *%@;\n", key]];
            } else if ([dictionary[key] isKindOfClass:[NSDictionary class]]) {
                [importString appendString:[NSString stringWithFormat:@"\n@class %@;",[self fullNameWithModelName:key]]];
                [string appendString:[NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;\n", [self fullNameWithModelName:key],key]];
                [self createHFileWithModelName:key dictionary:dictionary[key]];
            } else if ([dictionary[key] isKindOfClass:[NSArray class]]) {
                [string appendString:[NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;\n", key]];
                [ConvertHelper convertWithModelName:key array:dictionary[key] type:MJEXTENSION];
            } else {
                [string appendString:[NSString stringWithFormat:@"//@property (nonatomic, strong) %@ *%@;\n", [dictionary[key] class],key]];
            }
        }
    }
    
    return string;
}

- (NSString *)getClassInArrayWithDictionary:(NSDictionary *)dictionary {
    NSMutableString *string = [NSMutableString string];
    BOOL containsClassArray = NO;
    
    for (id key in dictionary.allKeys) {
        if ([key isKindOfClass:[NSString class]]) {
            if ([dictionary[key] isKindOfClass:[NSArray class]]) {
                NSDictionary *subobject = nil;
                
                for (id object in dictionary[key]) {
                    if ([object isKindOfClass:[NSDictionary class]]) {
                        if (!subobject) {
                            subobject = object;
                        }else if (subobject && ((NSDictionary *)object).count > subobject.count) {
                            subobject = object;
                        }
                    }
                }
                
                if (subobject) {
                    if (!containsClassArray) {
                        containsClassArray = YES;
                        [string appendString:[NSString stringWithFormat:@"\n+ (NSDictionary *)mj_objectClassInArray {\n    return @{\n"]];
                    }
                    
                    [string appendString:[NSString stringWithFormat:@"             @\"%@\":@\"%@\",",key,[self fullNameWithModelName:key]]];
                }
            }
        }
    }
    
    // delete last ,
    if (containsClassArray) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
        [string appendString:[NSString stringWithFormat:@"\n             };\n}\n"]];
    }
    
    return string;
}

- (NSString *)fullNameWithModelName:(NSString *)modelName {
    NSMutableString *fullName = [NSMutableString string];
    if (Prefix.length > 0) {
        [fullName appendString:Prefix];
    }
    
    [fullName appendString:[modelName capitalizedString]];
    
    if (Suffix.length > 0) {
        [fullName appendString:Suffix];
    }
    
    return fullName;
}

- (NSString *)fullFilePathWithName:(NSString *)fileName {
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Desktop/%@", fileName]];
}

@end
