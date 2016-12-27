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
@property (nonatomic, strong) NSMutableArray *classArray;

@end

@implementation BasicClassParser

- (instancetype)initWithJSON:(id)json rootClassName:(NSString *)rootClassName {
    if (self = [super init]) {
        _json = json;
        self.classArray = [NSMutableArray array];
        [self grabClassesWithRootClassName:rootClassName source:_json];
        [self.classes = self.classArray copy];
    }
    return self;
}

- (void)grabClassesWithRootClassName:(NSString *)rootClassName source:(id)source {
    ModelatorClass *mClass = [ModelatorClass new];
    mClass.name = [[self prettyClassName:rootClassName] singularizedString];
    NSMutableArray *propertyArray = [NSMutableArray array];
    NSDictionary *src = [source isKindOfClass:[NSDictionary class]]? source: [source firstObject];
    if ([src isKindOfClass:[NSArray class]] || [src isKindOfClass:[NSDictionary class]]) {
        for (id obj in src) {
            
            ModelatorProperty *prop = [ModelatorProperty propertyWithName:[self prettyPropretyName:obj] type:[self objectClassToString:src[obj]]];
            Class aClass = [[ModuleManager sharedManager] selectedModule].propertySettingsClass;
            id settings = [[aClass alloc] init];
            prop.propertySettings = settings;
            [propertyArray addObject:prop];
            
            if ([src[obj] isKindOfClass:[NSArray class]] || [src[obj] isKindOfClass:[NSDictionary class]]) {
                [self grabClassesWithRootClassName:obj source:src[obj]];
            }
        }
        mClass.properties = [propertyArray copy];
        [self.classArray addObject:mClass];
    }
}

- (NSString *)prettyClassName:(NSString *)className {
    return nil;
}
- (NSString *)objectClassToString:(id)obj {
    return nil;
}

- (NSString *)prettyPropretyName:(NSString*)propName {
    return nil;
}

- (NSString *)obectClassToConvinentString:(id)obj {
    return nil;
}

- (void)saveAllClassesToURL:(NSURL *)url {
    for (ModelatorClass *cls in self.classes) {


    }
}
@end
