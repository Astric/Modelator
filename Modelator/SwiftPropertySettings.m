//
//  SwiftPropertySettings.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 13/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "SwiftPropertySettings.h"

@implementation SwiftPropertySettings

- (NSArray *)propertyTypes {
    return @[
             @"NSString",
             @"NSArray",
             @"NSDictionary",
             @"NSNumber",
             @"BOOL",
             @"CGFloat",
             @"NSInteger",
             @"NSObject",
             @"id"
             ];
}

- (NSString *)stringRepresentationOfProperty:(ModelatorProperty *)property {
    NSMutableArray *result = [NSMutableArray array];
    if (!self.atomicProperty) {
        [result addObject:@"nonatomic"];
    }
    if ([self propertyIsObject:property]) {
        if (self.weakProperty) {
            [result addObject:@"weak"];
        }
        if (self.strongProperty) {
            [result addObject:@"strong"];
        }
        if (self.copyProperty) {
            [result addObject:@"copy"];
        }
    } else {
        if (self.assignProperty) {
            [result addObject:@"assign"];
        }
    }
    if (self.readOnlyProperty) {
        [result addObject:@"readonly"];
    }
    NSMutableString *resultStr = [NSMutableString string];
    for (NSString *str in result) {
        [resultStr appendFormat:@"%@, ",str];
    }
    if ([resultStr length]) {
        return [resultStr substringToIndex:[resultStr length] - 2];
    }
    return @"";
}

- (NSString *)extrasOfProperty:(ModelatorProperty *)property {
    return [self propertyIsObject:property]?@"*":@"";
}

- (BOOL)propertyIsObject:(ModelatorProperty *)property {
    NSArray *objects = @[@"NSString",@"NSArray",@"NSNumber",@"NSDictionary",@"NSObject"];
    return [objects containsObject:property.propertyType];
}

- (NSString *)convinientNameOfProperty:(ModelatorProperty *)property {
    if ([property.propertyType isEqualToString:@"BOOL"]) {
        return @"Bool";
    } else if ([property.propertyType isEqualToString:@"CGFloat"]) {
        return @"Float";
    }   else if ([property.propertyType isEqualToString:@"NSInteger"]) {
        return @"Int";
    }
    return @"Object";
}

@end
