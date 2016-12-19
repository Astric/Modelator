//
//  ModuleLoader.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 12/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "ModuleManager.h"


@implementation ModuleManager

+ (instancetype)sharedManager {
    static ModuleManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)loadModules {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"objC" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    ModelatorModule *module = [ModelatorModule new];
    module.propertyFormat = json[@"propertyFormat"];
    module.templateFiles = json[@"temlpateFiles"];
    module.moduleTitles = json[@"temlpateTitles"];
    module.exportFileExtensions = json[@"exportFileExtensions"];
    module.name = json[@"name"];
    module.parserClass = NSClassFromString(json[@"parserClass"]);
    module.propertySettingsClass = NSClassFromString(json[@"propertySettingsClass"]);
    module.propertyViewClassName = json[@"propertyView"];
    self.modules = @[module];
}

- (NSArray *)moduleNames {
    NSMutableArray *arr = [NSMutableArray array];
    for (ModelatorModule *module in self.modules) {
        [arr addObject:module.name];
    }
    return [arr copy];
}

- (ModelatorModule *)selectedModule {
    return self.modules[self.selectedModuleIndex];
}

@end
