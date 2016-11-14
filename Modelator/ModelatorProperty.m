//
//  ModelatorProperty.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 11/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "ModelatorProperty.h"

@implementation ModelatorProperty

+ (instancetype)propertyWithName:(NSString *)name type:(NSString *)type {
    ModelatorProperty *prop = [[ModelatorProperty alloc] init];
    prop.propertyName = name;
    prop.propertyType = type;
    return prop;
}


@end
