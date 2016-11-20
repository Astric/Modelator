//
//  ObjcPropertySettings.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 13/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "ObjcPropertySettings.h"

@implementation ObjcPropertySettings

- (NSArray *)propertyTypes {
    return @[@"NSString",@"NSArray",@"NSNumber",@"BOOL"];
}
+ (NSString *)stringRepresentation {
    return @"nonatomic, strong";
}

@end
