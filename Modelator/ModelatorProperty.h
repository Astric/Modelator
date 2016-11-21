//
//  ModelatorProperty.h
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 11/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelatorProperty;

@protocol ModelatorPropertyProtocol <NSObject>

- (NSString *)stringRepresentationOfProperty:(ModelatorProperty *)property;

@optional

- (NSString *)extrasOfProperty:(ModelatorProperty *)property;

@end

@interface ModelatorProperty : NSObject

@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) NSString *propertyType;
@property (nonatomic, strong) id propertySettings;

+ (instancetype)propertyWithName:(NSString *)name type:(NSString *)type;

@end
