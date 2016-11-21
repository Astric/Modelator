//
//  ObjCClassParser.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 13/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "ObjCClassParser.h"

@implementation ObjCClassParser

- (NSString *)objectClassToString:(id)obj {
    if ([obj isKindOfClass:[NSNumber class]]) {
        if ([obj isKindOfClass:[NSClassFromString(@"__NSCFBoolean") class]]) {
            return @"BOOL";
        } else {
            return @"NSNumber";
        }
    } else if ([obj isKindOfClass:[NSString class]])  {
        return @"NSString";
    } else if ([obj isKindOfClass:[NSArray class]])  {
        return @"NSArray";
    }
    return @"NSObject";
}
- (NSString *)prettyPropretyName:(NSString*)propName {
    NSArray *dissalowedNames = @[@"id",@"self",@"class"];
    NSString *str = propName ;
    NSArray *arr = [str componentsSeparatedByString:@"_"];
    NSMutableString *result = [NSMutableString string];
    for (NSString *s in arr) {
        [result appendString:s];
    }
    [result replaceCharactersInRange:NSMakeRange(0, 1) withString:[[result substringWithRange:NSMakeRange(0, 1)] lowercaseString]];
    if ([dissalowedNames containsObject:result]) {
        [result appendString:@"_"];
    }
    return result;
}

@end
