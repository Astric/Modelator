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

- (id)codeFromClass:(ModelatorClass *)mClass module:(ModelatorModule *)module {
    NSMutableArray *arr = [NSMutableArray array];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"dd/MM/yyyy";
    for (NSString *template in module.templateFiles) {
        NSString *path = [[NSBundle mainBundle] pathForResource:template ofType:nil];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        __block NSString *templateStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        templateStr = [templateStr stringByReplacingOccurrencesOfString:@"<#CLASS_NAME#>" withString:mClass.name];
        templateStr = [templateStr stringByReplacingOccurrencesOfString:@"<#NOW#>" withString:[formatter stringFromDate:[NSDate date]]];
        
        NSError *error = NULL;
        NSString *pattern = @"_LOOP_PROPERTY_BEGIN_.*?_LOOP_PROPERTY_END_";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        if (error) {  NSLog(@"Couldn't create regex with given string and options"); }
        
        NSRange wholeStringRange = NSMakeRange(0, [templateStr length] - 1);
        
        
        __block NSMutableArray *matchArray = [NSMutableArray array];
        [regex enumerateMatchesInString:templateStr options:0 range:wholeStringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            //NSRange range = result.range;
            //[rangeArray addObject:[NSValue valueWithRange:range]];
            [matchArray addObject:[templateStr substringWithRange:result.range]];
        }];
        
        NSMutableArray *replacementStrArray = [NSMutableArray array];
        for (NSString *val in matchArray) {
            NSMutableString *str = [NSMutableString string];
            for (ModelatorProperty *prop in mClass.properties) {
                NSString *propertyStr = [[val stringByReplacingOccurrencesOfString:@"_LOOP_PROPERTY_BEGIN_" withString:@""] stringByReplacingOccurrencesOfString:@"_LOOP_PROPERTY_END_" withString:@""];
                NSString *propertySettingsStr = [(id<ModelatorPropertyProtocol>)prop.propertySettings stringRepresentationOfProperty:prop];
                NSString *propertyExtrasStr = [(id<ModelatorPropertyProtocol>)prop.propertySettings extrasOfProperty:prop];
                NSString *propertyConvinentName =  [(id<ModelatorPropertyProtocol>)prop.propertySettings convinientNameOfProperty:prop];
                propertyStr = [propertyStr stringByReplacingOccurrencesOfString:@"<#PROPERTY_ATTRS#>" withString:propertySettingsStr];
                propertyStr = [propertyStr stringByReplacingOccurrencesOfString:@"<#PROPERTY_TYPE#>" withString:prop.propertyType];
                propertyStr = [propertyStr stringByReplacingOccurrencesOfString:@"<#PROPERTY_NAME#>" withString:prop.propertyName];
                propertyStr = [propertyStr stringByReplacingOccurrencesOfString:@"<#PROPERTY_EXTRAS#>" withString:propertyExtrasStr];
                propertyStr = [propertyStr stringByReplacingOccurrencesOfString:@"<#PROPERTY_CONV_NAME#>" withString:propertyConvinentName];
                propertyStr = [propertyStr stringByReplacingOccurrencesOfString:@"<#NEW_LINE#>" withString:@"\n"];
                [str appendString:propertyStr];
                
            }
            [replacementStrArray addObject:str];
        }
        
        for (NSInteger i = 0; i< [matchArray count]; i++) {
            templateStr = [templateStr stringByReplacingOccurrencesOfString:matchArray[i] withString:replacementStrArray[i]];
        }
        [arr addObject:templateStr];
        
    }
    return arr;
}




@end
