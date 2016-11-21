//
//  BasicClassParser.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 11/11/2016.
//  Copyright © 2016 Kostantinos Aggelopoulos. All rights reserved.
//

#import "BasicClassParser.h"
#import "ModelatorProperty.h"
#import "ModuleManager.h"
#import "NSString+InflectorKit.h"

@interface BasicClassParser()

@property (nonatomic, strong) id json;

@end

@implementation BasicClassParser

- (instancetype)initWithJSON:(id)json rootClassName:(NSString *)rootClassName {
    if (self = [super init]) {
        _json = json;
        [self generateClassesWithRootClassName:rootClassName];
    }
    return self;
}

- (void)generateClassesWithRootClassName:(NSString *)rootClassName {
    NSMutableArray *classArray = [NSMutableArray array];
    NSDictionary *src = [self.json isKindOfClass:[NSDictionary class]]? self.json: [self.json firstObject];
    [self generateClassWithRoodObject:src classArray:classArray className:rootClassName];
    [self setClasses:classArray];
}

- (void)generateClassWithRoodObject:(id)rootObject classArray:(NSMutableArray *)classArray className:(NSString *)className {
    NSMutableArray *propertyArray = [NSMutableArray array];
    ModelatorClass *mClass = [ModelatorClass new];
    mClass.name = [[className capitalizedString] singularizedString];
    for (id obj in rootObject) {
        if ([rootObject[obj] isKindOfClass:[NSArray class]]) {
            BOOL containsObjects = NO;
            for (id subObj in rootObject[obj]) {
                if ([subObj isKindOfClass:[NSDictionary class]]) {
                    containsObjects = YES;
                    [self generateClassWithRoodObject:subObj classArray:classArray className:obj];
                    break;
                }
            }
            ModelatorProperty *prop = [ModelatorProperty propertyWithName:[self prettyPropretyName:obj] type:[self objectClassToString:rootObject[obj]]];
            Class aClass = [[ModuleManager sharedManager] selectedModule].propertySettingsClass;
            id settings = [[aClass alloc] init];
            prop.propertySettings = settings;
            [propertyArray addObject:prop];
//            if (!containsObjects) {
//                ModelatorProperty *prop = [ModelatorProperty propertyWithName:[self prettyPropretyName:obj] type:[self objectClassToString:rootObject[obj]]];
//                Class aClass = [[ModuleManager sharedManager] selectedModule].propertySettingsClass;
//                id settings = [[aClass alloc] init];
//                prop.propertySettings = settings;
//                [propertyArray addObject:prop];
//            } else {
//                ModelatorProperty *prop = [ModelatorProperty propertyWithName:obj type:[self objectClassToString:rootObject[obj]]];
//                Class aClass = [[ModuleManager sharedManager] selectedModule].propertySettingsClass;
//                id settings = [[aClass alloc] init];
//                prop.propertySettings = settings;
//                [propertyArray addObject:prop];
//
//            }
        } else if ([rootObject[obj] isKindOfClass:[NSDictionary class]]) {
            [self generateClassWithRoodObject:rootObject[obj] classArray:classArray className:obj];
        } else {
            ModelatorProperty *prop = [ModelatorProperty propertyWithName:[self prettyPropretyName:obj] type:[self objectClassToString:rootObject[obj]]];
            Class aClass = [[ModuleManager sharedManager] selectedModule].propertySettingsClass;
            id settings = [[aClass alloc] init];
            prop.propertySettings = settings;
            [propertyArray addObject:prop];
        }
    }
    [classArray addObject:mClass];
    mClass.properties = propertyArray;
}

- (NSString *)objectClassToString:(id)obj {
    return nil;
}


- (NSString *)prettyPropretyName:(NSString*)propName {
    return nil;
}


@end
