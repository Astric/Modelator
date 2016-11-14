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
        return @"NSArry";
    }
    return @"NSObject";
}

@end
