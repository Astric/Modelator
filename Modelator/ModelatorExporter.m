//
//  ModelatorExporter.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 20/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "ModelatorExporter.h"
#import "ModelatorProperty.h"

@implementation ModelatorExporter

+ (NSArray *)classTokens
{
    static NSArray *_classTokens;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _classTokens = @[@"<#CLASS_NAME#>",@"<#NOW#>",@"<#CLASS_PROPERTIES#>"];
    });
    return _classTokens;
}

+ (NSArray *)propertyTokens
{
    static NSArray *_propertyTokens;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _propertyTokens = @[@"<#PROPERTY_ATTRS#>",@"<#PROPERTY_TYPE#>",@"<#PROPERTY_NAME#>"];
    });
    return _propertyTokens;
}

- (id)codeFromClass:(ModelatorClass *)mClass module:(ModelatorModule *)module {
    NSMutableArray *arr = [NSMutableArray array];
    NSString *propertiesStr = [self propertiesFromClass:mClass module:module];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"dd/MM/yyyy";
    for (NSString *template in module.templateFiles) {
        NSString *path = [[NSBundle mainBundle] pathForResource:template ofType:nil];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSString *templateStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        templateStr = [templateStr stringByReplacingOccurrencesOfString:@"<#CLASS_NAME#>" withString:mClass.name];
        templateStr = [templateStr stringByReplacingOccurrencesOfString:@"<#CLASS_PROPERTIES#>" withString:propertiesStr];
        templateStr = [templateStr stringByReplacingOccurrencesOfString:@"<#NOW#>" withString:[formatter stringFromDate:[NSDate date]]];
        [arr addObject:templateStr];
        
    }
    return arr;
}

- (NSString *)propertiesFromClass:(ModelatorClass *)mClass module:(ModelatorModule *)module {
    NSMutableString *str = [NSMutableString string];
    for (ModelatorProperty *prop in mClass.properties) {
        //[str appendFormat:@"%@\n",module.propertyFormat];
        NSString *propertyStr = module.propertyFormat;
        NSString *propertySettingsStr = [module.propertySettingsClass stringRepresentation];
        propertyStr = [propertyStr stringByReplacingOccurrencesOfString:@"<#PROPERTY_ATTRS#>" withString:propertySettingsStr];
        propertyStr = [propertyStr stringByReplacingOccurrencesOfString:@"<#PROPERTY_TYPE#>" withString:prop.propertyType];
        propertyStr = [propertyStr stringByReplacingOccurrencesOfString:@"<#PROPERTY_NAME#>" withString:prop.propertyName];
        [str appendFormat:@"%@\n",propertyStr];
    }
    return str;
}

@end