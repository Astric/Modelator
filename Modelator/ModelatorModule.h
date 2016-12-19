//
//  ModelatorModule.h
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 12/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelatorModule : NSObject

@property (nonatomic, strong) NSArray *templateFiles;
@property (nonatomic, strong) NSArray *moduleTitles;
@property (nonatomic, strong) NSString *propertyFormat;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Class parserClass;
@property (nonatomic, strong) Class propertySettingsClass;
@property (nonatomic, strong) NSString *propertyViewClassName;
@property (nonatomic, strong) NSArray *exportFileExtensions;

@end
