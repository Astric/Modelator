//
//  ObjCClassParser.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 28/12/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "SwiftClassParser.h"

@implementation SwiftClassParser

- (NSString *)objectClassToString:(id)obj {
    if ([obj isKindOfClass:[NSNumber class]]) {
        if ([obj isKindOfClass:[NSClassFromString(@"__NSCFBoolean") class]]) {
            return @"Bool";
        } else {
            return @"NSNumber";
        }
    } else if ([obj isKindOfClass:[NSString class]])  {
        return @"String";
    } else if ([obj isKindOfClass:[NSArray class]])  {
        return @"[Any]";
    }
    return @"NSObject";
}

- (NSString *)prettyPropretyName:(NSString*)propName {
    NSArray *dissalowedNames = @[@"id",@"self",@"class",@"virtual"];
    NSString *str = propName ;
    NSArray *arr = [str componentsSeparatedByString:@"_"];
    NSMutableString *result = [NSMutableString string];
    for (NSInteger i = 0;i < [arr count]; i++) {
        NSString *name = arr[i];
        if (i) {
            name = [name capitalizedString];
        }
        [result appendString:name];
    }
    [result replaceCharactersInRange:NSMakeRange(0, 1) withString:[[result substringWithRange:NSMakeRange(0, 1)] lowercaseString]];
    if ([dissalowedNames containsObject:result]) {
        [result appendString:@"_"];
    }
    return result;
}

- (NSString *)prettyClassName:(NSString *)className {
    NSArray *arr = [className componentsSeparatedByString:@"_"];
    NSMutableString *result = [NSMutableString string];
    for (NSInteger i = 0;i < [arr count]; i++) {
        NSString *name = arr[i];
        if (i) {
            name = [name capitalizedString];
        }
        [result appendString:name];
    }
    [result replaceCharactersInRange:NSMakeRange(0, 1) withString:[[result substringWithRange:NSMakeRange(0, 1)] uppercaseString]];

    return result;
}

- (NSString *)obectClassToConvinentString:(id)obj {
    if ([obj isKindOfClass:[NSNumber class]]) {
        if ([obj isKindOfClass:[NSClassFromString(@"__NSCFBoolean") class]]) {
            return @"Bool";
        } else {
            return @"Object";
        }
    } else if ([obj isKindOfClass:[NSString class]])  {
        return @"Object";
    } else if ([obj isKindOfClass:[NSArray class]])  {
        return @"Object";
    }
    return @"Object";
}
@end
