//
//  ModuleLoader.h
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 12/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelatorModule.h"

@interface ModuleManager : NSObject

+ (instancetype)sharedManager;
- (void)loadModules;

@property (nonatomic, strong) NSArray *modules;
@property (nonatomic, strong) NSArray *moduleNames;
@property (nonatomic, assign) NSInteger selectedModuleIndex;
@property (nonatomic, readonly, weak) ModelatorModule *selectedModule;

@end
