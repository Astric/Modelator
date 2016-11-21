//
//  ObjcPropertySettings.h
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 13/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelatorProperty.h"

@interface ObjcPropertySettings : NSObject<ModelatorPropertyProtocol>

@property (nonatomic, assign) BOOL atomicProperty;
@property (nonatomic, assign) BOOL assignProperty;
@property (nonatomic, assign) BOOL copyProperty;
@property (nonatomic, assign) BOOL weakProperty;
@property (nonatomic, assign) BOOL strongProperty;
@property (nonatomic, assign) BOOL readOnlyProperty;
@property (nonnull, strong, readonly) NSArray *propertyTypes;

@end
